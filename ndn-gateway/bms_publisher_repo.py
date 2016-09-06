# repo publisher for raw sensor data; updated Aug 4 for making UCLA raw sensor data available on testbed

import tailer 
import parse 
import argparse
import sys
import json
import logging
from datetime import datetime

from base64 import b64decode, b64encode

import subprocess
import time
import select

import csv

try:
    import asyncio
except ImportError:
    import trollius as asyncio
    from concurrent.futures import ProcessPoolExecutor

from pyndn import Name, Data, KeyLocator, Interest
from pyndn.threadsafe_face import ThreadsafeFace
from pyndn.util.memory_content_cache import MemoryContentCache
from pyndn.util import Blob
from pyndn.encoding import ProtobufTlv

from pyndn.security import KeyChain
from pyndn.security.identity.file_private_key_storage import FilePrivateKeyStorage
from pyndn.security.identity.basic_identity_storage import BasicIdentityStorage
from pyndn.security.identity.identity_manager import IdentityManager
from pyndn.security.policy.config_policy_manager import ConfigPolicyManager

import repo_command_parameter_pb2
import repo_command_response_pb2

import subprocess

repoCommandPrefix = Name("/repo/command")
epoch = datetime.utcfromtimestamp(0)

class DataPublisher(object):
    def __init__(self, face, keyChain, loop, cache, namespace):
        # Start time of this instance
        self._startTime = 0

        self._defaultFreshnessPeriod = 10000
        # Dictionary that holds the temporary data to calculate aggregation with
        # Key   - sensor name
        # Value - data list: [], list of sensor data
        #         timeThreshold: int, any data before this timestamp should be used for aggregation calculation; 
        #                             here we assume for each sensor, its data would come in order on this node
        self._dataQueue = dict()
        self._face = face
        self._keyChain = keyChain
        self._loop = loop
        self._cache = cache
        self._namespace = namespace
        self._sensorList = []

    def publishMetadata(self):
        # For now, hardcoded sensor list on gateway's end
        data = Data(Name(self._namespace).append("_meta").append(str(int(time.time() * 1000.0))))
        data.setContent(json.dumps({"list" : self._sensorList}))
        data.getMetaInfo().setFreshnessPeriod(self._defaultFreshnessPeriod)
        self._keyChain.sign(data)
        self._cache.add(data)
        print("Metadata " + data.getName().toUri() + " added for sensor list: " + str(self._sensorList))

        self.startRepoInsertion(data)

    def publish(self, line):
        dataObject = json.loads(line)
        locationName = Name(self.msgLocationToHierarchicalName(dataObject["sensor_id"]))
        if not (locationName.toUri() in self._sensorList):
            self._sensorList.append(locationName.toUri())
            self.publishMetadata()
        dataName = Name(self._namespace).append(locationName).append(self.msgTimestampToNameComponent(dataObject["timestamp"]))
        data = Data(dataName)
        data.setContent(line)
        data.getMetaInfo().setFreshnessPeriod(self._defaultFreshnessPeriod)
        self._keyChain.sign(data)
        self._cache.add(data)
        print("Data " + dataName.toUri() + " added for record: " + line)

        self.startRepoInsertion(data)

    def startRepoInsertion(self, data):
        # For now we only insert raw data into repo
        parameter = repo_command_parameter_pb2.RepoCommandParameterMessage()
        # Add the Name.
        for i in range(data.getName().size()):
            parameter.repo_command_parameter.name.component.append(
              data.getName().get(i).toEscapedString())
        
        # Create the command interest.
        commandInterest = Interest(Name(repoCommandPrefix).append("insert")
          .append(Name.Component(ProtobufTlv.encode(parameter))))
        self._face.makeCommandInterest(commandInterest)
        
        # Send the command interest and get the response or timeout.
        def onRepoCommandResponse(interest, data):
            # repo_command_response_pb2 was produced by protoc.
            response = repo_command_response_pb2.RepoCommandResponseMessage()
            try:
                ProtobufTlv.decode(response, data.content)
            except:
                print("Cannot decode the repo command response")
                
            if response.repo_command_response.status_code == 100:
                if __debug__:
                    print("Insertion started")
            else:
                print("Got repo command error code", response.repo_command_response.status_code)
                
        def onRepoCommandTimeout(interest):
            if __debug__:
                print("Insert repo command timeout")
            
        self._face.expressInterest(commandInterest, onRepoCommandResponse, onRepoCommandTimeout)


    def msgLocationToHierarchicalName(self, location):
        return location.replace("_", "/")

    def msgTimestampToNameComponent(self, timestamp):
        dt = datetime.strptime(timestamp, '%H:%M:%S')
        dt = dt.replace(year = datetime.today().year, month = datetime.today().month, day = datetime.today().day)
        return str(int((dt - epoch).total_seconds()))

    @asyncio.coroutine
    def readfile(self, filename):
        f = open(filename, 'r')
        for line in f:
            self.publish(line)
            yield None
        f.close()
        
    @asyncio.coroutine
    def followfile(self, filename):
        f = subprocess.Popen(['tail','-F', filename],\
              stdout = subprocess.PIPE,stderr = subprocess.PIPE)
        
        # Using kqueue instead of select.poll for OSX
        kq = select.kqueue()
        kevent = select.kevent(f.stdout,
                       filter=select.KQ_FILTER_READ, # we are interested in reads
                       flags=select.KQ_EV_ADD)

        while True:
            revents = kq.control([kevent], 1, None)
            for event in revents:
                if (event.filter == select.KQ_FILTER_READ):
                    self.publish(f.stdout.readline())
            time.sleep(0.1)
            yield None

        #for line in tailer.follow(open(filename)):
        #    publish(line, namespace, cache)

    def onRegisterFailed(self, prefix):
        print("register failed for " + prefix.getName().toUri())
        raise RuntimeError("Register failed for prefix", prefix.toUri())

    def onDataNotFound(self, prefix, interest, face, interestFilterId, filter):
        print('DataNotFound : ' + interest.getName().toUri())
        return

class Logger(object):
    def prepareLogging(self):
        self.log = logging.getLogger(str(self.__class__))
        self.log.setLevel(logging.DEBUG)
        logFormat = "%(asctime)-15s %(name)-20s %(funcName)-20s (%(levelname)-8s):\n\t%(message)s"
        self._console = logging.StreamHandler()
        self._console.setFormatter(logging.Formatter(logFormat))
        self._console.setLevel(logging.INFO)
        # without this, a lot of ThreadsafeFace errors get swallowed up
        logging.getLogger("trollius").addHandler(self._console)
        self.log.addHandler(self._console)

    def setLogLevel(self, level):
        """
        Set the log level that will be output to standard error
        :param level: A log level constant defined in the logging module (e.g. logging.INFO) 
        """
        self._console.setLevel(level)

    def getLogger(self):
        """
        :return: The logger associated with this node
        :rtype: logging.Logger
        """
        return self.log

def main(): 
    # Params parsing
    parser = argparse.ArgumentParser(description='bms gateway node to Parse or follow Cascade Datahub log and publish to MiniNdn.')
    parser.add_argument('filename', help='datahub log file')
    parser.add_argument('-f', dest='follow', action='store_true', help='follow (tail -f) the log file')  
    parser.add_argument('--namespace', default='/ndn/nist/bms', help='root of ndn name, no trailing slash')
    args = parser.parse_args()
    
    # Setup logging
    logger = Logger()
    logger.prepareLogging()

    # Face, KeyChain, memoryContentCache and asio event loop initialization
    loop = asyncio.get_event_loop()
    face = ThreadsafeFace(loop)

    keyChain = KeyChain(IdentityManager(BasicIdentityStorage()))
    # For the gateway publisher, we create one identity for it to sign nfd command interests
    certificateName = keyChain.createIdentityAndCertificate(Name("/ndn/nist/gateway"))
    face.setCommandSigningInfo(keyChain, certificateName)
    cache = MemoryContentCache(face)

    dataPublisher = DataPublisher(face, keyChain, loop, cache, args.namespace)
    cache.registerPrefix(Name(args.namespace), dataPublisher.onRegisterFailed, dataPublisher.onDataNotFound)
    
    if args.follow:
        #asyncio.async(loop.run_in_executor(executor, followfile, args.filename, args.namespace, cache))
        loop.run_until_complete(dataPublisher.followfile(args.filename))
    else:
        loop.run_until_complete(dataPublisher.readfile(args.filename))
        
    loop.run_forever()
    face.shutdown()
        
if __name__ == '__main__':
    main()

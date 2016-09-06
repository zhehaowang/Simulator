NIST Building Simulator and NDN Interface
===================

NIST Building Simulator and NDN Interface.

Siham Khoussi <siham.khoussi@nist.gov>

Jaafar Chbili <jaafar.chbili@nist.gov>

Zhehao Wang <zhehao@cs.ucla.edu>

#### Functionalities

#### Interface

#### Repository structure
 * **simulator** : the building simulator (Java)
 * **ndn-gateway** : the NDN gateway (Python) that reads sensor data messages produced by the simulator and publishes to repo-ng
 * **ndn-consumer** : an example (JavaScript) NDN consumer that consumes data produced by the NDN gateway
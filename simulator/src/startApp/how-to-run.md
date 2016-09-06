On zhehao's laptop, in this folder:

Compile:

javac -cp json-simple-1.1.1.jar Simulator.java

Run:

java -cp $(pwd)/../:$(pwd)/mysql-connector-java-5.1.39-bin.jar:$(pwd)/json-simple-1.1.1.jar  startApp.Simulator

If no db entry before:

mysql -u[] -p[] < smart-building.sql

Change in source the dbConnection (usr pwd, etc)

Change file path to being suitable for a UNIX FS
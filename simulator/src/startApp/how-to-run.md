On zhehao's laptop, in this folder:

javac -cp json-simple-1.1.1.jar Simulator.java

java -cp $(pwd)/../:$(pwd)/mysql-connector-java-5.1.39-bin.jar:$(pwd)/json-simple-1.1.1.jar  startApp.Simulator

If no db entry before:

mysql -u[] -p[] < smart-building.sql

Change in source the dbConnection (usr pwd, etc)

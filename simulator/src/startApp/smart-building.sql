-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: smart_buildings
-- ------------------------------------------------------
-- Server version	5.7.12-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `building`
--

CREATE DATABASE IF NOT EXISTS `smart_buildings`;

USE smart_buildings;

DROP TABLE IF EXISTS `building`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `building` (
  `building_id` int(11) NOT NULL,
  `affiliation` varchar(5) DEFAULT NULL,
  `address` varchar(25) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zipcode` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`building_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `building`
--

LOCK TABLES `building` WRITE;
/*!40000 ALTER TABLE `building` DISABLE KEYS */;
INSERT INTO `building` VALUES (16,'wer','wer','Aberdeen','Alabama','wer'),(101,'fgh','fgh','Aberdeen','Alabama','fgh'),(220,'nist','100 bureau','Gaithersburg','Maryland','20899'),(222,'nist','100 bureau','Gaithersburg','Maryland','20899'),(225,'nist','100 bureau','Gaithersburg','Maryland','20899');
/*!40000 ALTER TABLE `building` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data` (
  `value` int(11) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `sensor_id` varchar(45) NOT NULL,
  PRIMARY KEY (`timestamp`,`sensor_id`),
  KEY `timestamp_index` (`timestamp`),
  KEY `owner` (`sensor_id`),
  CONSTRAINT `data_ibfk_1` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`),
  CONSTRAINT `data_ibfk_2` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data`
--

LOCK TABLES `data` WRITE;
/*!40000 ALTER TABLE `data` DISABLE KEYS */;
INSERT INTO `data` VALUES (73,'11:02:42','s2'),(74,'11:02:43','s1'),(74,'11:02:44','s3'),(71,'11:02:45','s4'),(73,'11:02:46','s2'),(76,'11:02:48','s1'),(69,'11:02:49','s3'),(71,'11:02:50','s4'),(70,'11:02:51','s2'),(69,'11:02:52','s1'),(68,'11:02:53','s3'),(76,'11:02:54','s4'),(75,'11:02:55','s2'),(68,'11:02:56','s1'),(70,'11:02:57','s3'),(76,'11:02:58','s4'),(74,'11:02:59','s2'),(75,'11:03:01','s1'),(74,'11:04:39','s2'),(68,'11:04:40','s1'),(70,'11:04:41','s3'),(69,'11:04:42','s4'),(68,'11:04:43','s2'),(72,'11:04:44','s1'),(72,'11:04:45','s3'),(75,'11:06:59','s2'),(76,'11:07:00','s1'),(76,'11:07:01','s3'),(70,'11:07:02','s4'),(71,'11:07:03','s2'),(75,'11:07:04','s1'),(75,'11:07:05','s3'),(71,'11:07:06','s4'),(72,'11:07:07','s2'),(74,'11:07:08','s1'),(76,'11:07:09','s3'),(71,'11:07:10','s4'),(76,'11:07:11','s2'),(76,'11:07:13','s1'),(71,'11:07:14','s3'),(72,'11:07:15','s4'),(74,'11:07:16','s2'),(70,'11:07:29','s2'),(70,'11:07:30','s1'),(68,'11:07:31','s3'),(68,'11:07:32','s4'),(75,'11:07:33','s2'),(74,'11:07:34','s1'),(72,'11:07:35','s3'),(71,'11:07:36','s4'),(72,'11:07:37','s2'),(70,'11:07:38','s1'),(69,'11:09:08','s2'),(76,'11:09:09','s1'),(72,'11:09:10','s3'),(76,'11:09:11','s4'),(68,'11:09:12','s2'),(76,'11:09:13','s1'),(72,'11:09:14','s3'),(68,'11:09:34','s2'),(72,'11:09:35','s1'),(68,'11:09:36','s3'),(76,'11:09:37','s4'),(74,'11:09:38','s2'),(76,'11:09:39','s1'),(70,'11:09:40','s3'),(72,'11:09:41','s4'),(69,'11:09:42','s2'),(76,'11:09:44','s1'),(73,'11:09:45','s3'),(72,'11:09:46','s4'),(69,'11:09:47','s2'),(68,'11:09:48','s1'),(75,'11:09:49','s3'),(75,'11:09:50','s4'),(69,'11:09:51','s2'),(76,'11:09:52','s1'),(76,'11:09:53','s3'),(76,'11:09:54','s4'),(75,'11:09:55','s2'),(73,'11:09:56','s1'),(71,'11:09:57','s3'),(74,'11:09:58','s4'),(74,'11:09:59','s2'),(72,'11:10:00','s1'),(69,'11:10:01','s3'),(68,'11:10:02','s4'),(74,'11:10:03','s2'),(73,'11:10:04','s1'),(73,'11:10:05','s3'),(72,'11:10:07','s4'),(68,'11:10:08','s2'),(76,'11:10:09','s1'),(74,'11:10:10','s3'),(76,'11:10:11','s4'),(72,'11:10:12','s2'),(74,'11:10:13','s1'),(68,'11:10:14','s3'),(69,'11:10:15','s4'),(72,'11:10:16','s2'),(72,'11:10:17','s1'),(74,'11:10:18','s3'),(76,'11:10:19','s4'),(69,'11:10:20','s2'),(69,'11:10:21','s1'),(72,'11:10:22','s3'),(70,'11:10:23','s4'),(68,'11:10:24','s2'),(75,'11:10:25','s1'),(73,'11:10:27','s3'),(74,'11:10:28','s4'),(72,'11:10:29','s2');
/*!40000 ALTER TABLE `data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `floor`
--

DROP TABLE IF EXISTS `floor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `floor` (
  `floor_id` varchar(12) NOT NULL,
  `building_id` int(11) NOT NULL,
  PRIMARY KEY (`floor_id`),
  KEY `building_id_index` (`building_id`),
  CONSTRAINT `floor_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `building` (`building_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `floor`
--

LOCK TABLES `floor` WRITE;
/*!40000 ALTER TABLE `floor` DISABLE KEYS */;
INSERT INTO `floor` VALUES ('f1_16',16),('f1_101',101),('f2_101',101),('b_220',220),('f1_220',220),('f1_222',222),('f2_222',222),('f1_225',225);
/*!40000 ALTER TABLE `floor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hallway`
--

DROP TABLE IF EXISTS `hallway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hallway` (
  `hallway_id` varchar(12) NOT NULL,
  `floor_id` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`hallway_id`),
  KEY `floor_id` (`floor_id`),
  CONSTRAINT `hallway_ibfk_1` FOREIGN KEY (`floor_id`) REFERENCES `floor` (`floor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hallway`
--

LOCK TABLES `hallway` WRITE;
/*!40000 ALTER TABLE `hallway` DISABLE KEYS */;
INSERT INTO `hallway` VALUES ('220_b_HE','b_220'),('101_f1_HA','f1_101'),('16_f1_HA','f1_16'),('220_f1_HW','f1_220'),('222_f1_HA','f1_222'),('222_f1_HB','f1_222');
/*!40000 ALTER TABLE `hallway` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `room` (
  `room_id` varchar(60) NOT NULL,
  `floor_id` varchar(25) DEFAULT NULL,
  `room_type` varchar(12) DEFAULT NULL,
  `hallway` varchar(12) DEFAULT NULL,
  `n_doors` int(11) NOT NULL,
  `n_windows` int(11) NOT NULL,
  PRIMARY KEY (`room_id`),
  KEY `n_doors_index` (`n_doors`),
  KEY `n_windows_index` (`n_windows`),
  KEY `hallway` (`hallway`),
  CONSTRAINT `room_ibfk_1` FOREIGN KEY (`hallway`) REFERENCES `hallway` (`hallway_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES ('16_f1_a2','f1','er','16_f1_HA',0,0),('a11','b_220','office','220_b_HE',4,4),('a12','b_220','office','220_b_HE',4,4),('a13','b_220','office','220_b_HE',4,4),('a14','f1_220','office','220_f1_HW',4,4),('a15','f1_220','office','220_f1_HW',4,4),('a16','f1_222','office','222_f1_HA',4,4),('a17','f1_222','office','222_f1_HB',4,4);
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensor`
--

DROP TABLE IF EXISTS `sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensor` (
  `sensor_id` varchar(45) NOT NULL,
  `sensor_type` varchar(45) DEFAULT NULL,
  `sensor_location` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`sensor_id`),
  KEY `sensor_location_index` (`sensor_location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor`
--

LOCK TABLES `sensor` WRITE;
/*!40000 ALTER TABLE `sensor` DISABLE KEYS */;
INSERT INTO `sensor` VALUES ('s1','temperature','222_f1_HA_A12'),('s2','temperature','222_f1_HA'),('s3','temperature','222_f1_HA_A13'),('s4','temperature','222_st1');
/*!40000 ALTER TABLE `sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `v_transport`
--

DROP TABLE IF EXISTS `v_transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `v_transport` (
  `v_transport_id` varchar(12) NOT NULL,
  `type` varchar(12) DEFAULT NULL,
  `building_id` int(11) NOT NULL,
  PRIMARY KEY (`v_transport_id`),
  KEY `building_id_index` (`building_id`),
  CONSTRAINT `v_transport_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `building` (`building_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `v_transport`
--

LOCK TABLES `v_transport` WRITE;
/*!40000 ALTER TABLE `v_transport` DISABLE KEYS */;
INSERT INTO `v_transport` VALUES ('16_s1','stairs',16),('e1_222','elevator',222),('e4_220','elevator',220),('s1_222','stairs',222),('s1_225','stairs',225);
/*!40000 ALTER TABLE `v_transport` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-08-31 13:49:38

-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: referralpath
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrative_union`
--

DROP TABLE IF EXISTS `administrative_union`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrative_union` (
  `union_id` int unsigned NOT NULL AUTO_INCREMENT,
  `upazila_id` int unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`union_id`),
  UNIQUE KEY `uq_union_upazila_name` (`upazila_id`,`name`),
  CONSTRAINT `fk_union_upazila` FOREIGN KEY (`upazila_id`) REFERENCES `upazila` (`upazila_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrative_union`
--

LOCK TABLES `administrative_union` WRITE;
/*!40000 ALTER TABLE `administrative_union` DISABLE KEYS */;
INSERT INTO `administrative_union` VALUES (1,1,'Kushura'),(2,1,'Sutipara'),(4,2,'Aminbazar'),(3,2,'Tetuljhora'),(5,3,'Basan'),(6,3,'Harinal'),(7,4,'Mouchak');
/*!40000 ALTER TABLE `administrative_union` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `appointment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` bigint unsigned NOT NULL,
  `department_id` int unsigned NOT NULL,
  `slot_id` int unsigned NOT NULL,
  `doctor_id` int unsigned DEFAULT NULL,
  `appointment_date` date NOT NULL,
  `status` enum('BOOKED','CANCELLED','RESCHEDULED','COMPLETED','NO_SHOW') NOT NULL DEFAULT 'BOOKED',
  `reason` varchar(255) DEFAULT NULL,
  `rescheduled_from_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  KEY `idx_appointment_patient` (`patient_id`),
  KEY `idx_appointment_department` (`department_id`),
  KEY `idx_appointment_slot` (`slot_id`),
  KEY `idx_appointment_doctor` (`doctor_id`),
  KEY `idx_appointment_date_status` (`appointment_date`,`status`),
  KEY `fk_appointment_rescheduled_from` (`rescheduled_from_id`),
  CONSTRAINT `fk_appointment_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_rescheduled_from` FOREIGN KEY (`rescheduled_from_id`) REFERENCES `appointment` (`appointment_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_slot` FOREIGN KEY (`slot_id`) REFERENCES `department_slot` (`slot_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (1,1,1,1,1,'2026-09-21','COMPLETED','Routine gynecology consultation',NULL,'2026-09-20 20:16:39','2026-09-24 18:14:17'),(2,2,1,2,1,'2026-09-21','COMPLETED','Follow-up consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(3,3,3,5,3,'2026-09-21','RESCHEDULED','Gynecology consultation',NULL,'2026-09-20 20:16:39','2026-09-21 07:40:31'),(4,4,3,6,3,'2026-09-21','CANCELLED','Appointment cancelled by patient',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(5,5,4,7,2,'2026-09-21','BOOKED','Gynecology consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(6,6,4,8,2,'2026-09-21','COMPLETED','Prenatal consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(7,7,7,13,5,'2026-09-21','BOOKED','Gynecology consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(8,8,7,14,5,'2026-09-21','BOOKED','Women health consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(9,9,10,19,6,'2026-09-21','BOOKED','Specialist consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(10,10,10,20,6,'2026-09-21','COMPLETED','Follow-up consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(11,11,11,21,7,'2026-09-21','BOOKED','Fever and general medicine',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(12,12,11,22,7,'2026-09-21','NO_SHOW','Patient did not attend',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(13,13,13,25,8,'2026-09-21','BOOKED','Gynecology consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(14,14,13,26,8,'2026-09-21','BOOKED','Specialist consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(15,15,15,29,10,'2026-09-21','BOOKED','Advanced gynecology consultation',NULL,'2026-09-20 20:16:39','2026-09-20 20:16:39'),(18,15,4,7,2,'2026-09-21','CANCELLED','New gynecology appointment through booking procedure',NULL,'2026-09-21 07:31:01','2026-09-21 07:35:59'),(19,3,3,6,3,'2026-09-21','BOOKED','Gynecology consultation',3,'2026-09-21 07:40:31','2026-09-21 07:40:31'),(20,15,1,1,1,'2026-09-25','BOOKED','Current day booking test',NULL,'2026-09-24 18:16:21','2026-09-24 18:16:21');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_punch`
--

DROP TABLE IF EXISTS `attendance_punch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_punch` (
  `punch_event_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `credential_id` int unsigned NOT NULL,
  `source_id` int unsigned NOT NULL,
  `event_type` enum('PUNCH_IN','PUNCH_OUT') NOT NULL,
  `punched_at` datetime NOT NULL,
  `recorded_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation_status` enum('VALID','INVALID','PENDING') NOT NULL DEFAULT 'PENDING',
  `validation_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`punch_event_id`),
  KEY `idx_punch_credential_time` (`credential_id`,`punched_at`),
  KEY `idx_punch_source_recorded` (`source_id`,`recorded_at`),
  CONSTRAINT `fk_punch_credential` FOREIGN KEY (`credential_id`) REFERENCES `doctor_credential` (`credential_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_punch_source` FOREIGN KEY (`source_id`) REFERENCES `attendance_source` (`source_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_punch`
--

LOCK TABLES `attendance_punch` WRITE;
/*!40000 ALTER TABLE `attendance_punch` DISABLE KEYS */;
INSERT INTO `attendance_punch` VALUES (1,1,1,'PUNCH_IN','2026-09-21 00:42:54','2026-09-21 00:42:54','VALID',NULL),(2,1,1,'PUNCH_OUT','2026-09-21 01:12:54','2026-09-21 01:12:54','VALID',NULL),(3,2,3,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(4,3,2,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(5,4,3,'PUNCH_IN','2026-09-20 23:12:54','2026-09-20 23:12:54','VALID',NULL),(6,5,4,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(7,6,5,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(8,7,5,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(9,8,6,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(10,9,6,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(11,10,7,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(12,11,7,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(13,12,3,'PUNCH_IN','2026-09-21 01:42:54','2026-09-21 01:42:54','VALID',NULL),(14,1,1,'PUNCH_IN','2026-09-20 02:12:54','2026-09-20 02:12:54','VALID',NULL),(15,3,2,'PUNCH_IN','2026-09-20 02:12:54','2026-09-20 02:12:54','VALID',NULL),(16,5,4,'PUNCH_IN','2026-09-20 02:12:54','2026-09-20 02:12:54','VALID',NULL),(17,10,7,'PUNCH_IN','2026-09-20 02:12:54','2026-09-20 02:12:54','VALID',NULL),(18,2,3,'PUNCH_OUT','2026-09-21 13:25:40','2026-09-21 13:25:40','VALID',NULL),(19,2,3,'PUNCH_IN','2026-09-21 13:28:37','2026-09-21 13:28:37','VALID',NULL),(20,3,2,'PUNCH_IN','2026-09-21 13:39:45','2026-09-21 13:39:45','VALID',NULL),(21,1,1,'PUNCH_IN','2026-09-21 14:00:12','2026-09-21 14:00:12','VALID',NULL),(22,1,1,'PUNCH_OUT','2026-09-21 14:00:41','2026-09-21 14:00:41','VALID',NULL),(23,1,1,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(24,3,2,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(25,5,4,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(26,6,5,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(27,7,5,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(28,8,6,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(29,9,6,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(30,10,7,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(31,11,7,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL),(32,12,3,'PUNCH_IN','2026-09-25 00:15:35','2026-09-25 00:15:35','VALID',NULL);
/*!40000 ALTER TABLE `attendance_punch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_source`
--

DROP TABLE IF EXISTS `attendance_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_source` (
  `source_id` int unsigned NOT NULL AUTO_INCREMENT,
  `facility_id` int unsigned NOT NULL,
  `source_name` varchar(100) NOT NULL,
  `stale_after_minutes` int unsigned NOT NULL DEFAULT '120',
  `reliability_window_days` int unsigned NOT NULL DEFAULT '30',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `uq_attendance_source` (`facility_id`,`source_name`),
  CONSTRAINT `fk_source_facility` FOREIGN KEY (`facility_id`) REFERENCES `health_facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_reliability_window` CHECK ((`reliability_window_days` > 0)),
  CONSTRAINT `chk_stale_after` CHECK ((`stale_after_minutes` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_source`
--

LOCK TABLES `attendance_source` WRITE;
/*!40000 ALTER TABLE `attendance_source` DISABLE KEYS */;
INSERT INTO `attendance_source` VALUES (1,1,'Main Staff Card Reader',120,30,1),(2,2,'Main Staff Card Reader',120,30,1),(3,3,'Main Staff Card Reader',120,30,1),(4,4,'Main Staff Card Reader',120,30,1),(5,5,'Main Staff Card Reader',120,30,1),(6,6,'Main Staff Card Reader',120,30,1),(7,7,'Main Staff Card Reader',120,30,1),(8,8,'Main Staff Card Reader',120,30,1);
/*!40000 ALTER TABLE `attendance_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_queue`
--

DROP TABLE IF EXISTS `daily_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_queue` (
  `queue_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` bigint unsigned NOT NULL,
  `appointment_id` bigint unsigned DEFAULT NULL,
  `department_id` int unsigned NOT NULL,
  `queue_number` int unsigned NOT NULL,
  `queue_date` date NOT NULL,
  `status` enum('WAITING','CALLED','IN_SERVICE','COMPLETED','CANCELLED','NO_SHOW') NOT NULL DEFAULT 'WAITING',
  `issued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `called_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`queue_id`),
  UNIQUE KEY `uq_queue_number` (`department_id`,`queue_date`,`queue_number`),
  KEY `fk_queue_patient` (`patient_id`),
  KEY `fk_queue_appointment` (`appointment_id`),
  KEY `idx_queue_department_date_status` (`department_id`,`queue_date`,`status`),
  CONSTRAINT `fk_queue_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`appointment_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_queue_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_queue_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_queue`
--

LOCK TABLES `daily_queue` WRITE;
/*!40000 ALTER TABLE `daily_queue` DISABLE KEYS */;
INSERT INTO `daily_queue` VALUES (1,1,1,1,1,'2026-09-21','COMPLETED','2026-09-21 02:17:10','2026-09-25 00:12:15','2026-09-25 00:14:17'),(2,2,2,1,2,'2026-09-21','COMPLETED','2026-09-21 02:17:10',NULL,NULL),(3,3,3,3,1,'2026-09-21','CANCELLED','2026-09-21 02:17:10',NULL,NULL),(4,5,5,4,1,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(5,6,6,4,2,'2026-09-21','COMPLETED','2026-09-21 02:17:10',NULL,NULL),(6,7,7,7,1,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(7,8,8,7,2,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(8,9,9,10,1,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(9,10,10,10,2,'2026-09-21','COMPLETED','2026-09-21 02:17:10',NULL,NULL),(10,11,11,11,1,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(11,12,12,11,2,'2026-09-21','NO_SHOW','2026-09-21 02:17:10',NULL,NULL),(12,13,13,13,1,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(13,14,14,13,2,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(14,15,15,15,1,'2026-09-21','WAITING','2026-09-21 02:17:10',NULL,NULL),(15,15,18,4,3,'2026-09-21','CANCELLED','2026-09-21 13:31:01',NULL,NULL),(16,3,19,3,2,'2026-09-21','WAITING','2026-09-21 13:40:31',NULL,NULL),(17,15,20,1,1,'2026-09-25','IN_SERVICE','2026-09-25 00:16:21','2026-09-25 00:23:02',NULL);
/*!40000 ALTER TABLE `daily_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `department_id` int unsigned NOT NULL AUTO_INCREMENT,
  `facility_id` int unsigned NOT NULL,
  `specialty_id` int unsigned NOT NULL,
  `name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `uq_department_facility_name` (`facility_id`,`name`),
  KEY `fk_department_specialty` (`specialty_id`),
  CONSTRAINT `fk_department_facility` FOREIGN KEY (`facility_id`) REFERENCES `health_facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_department_specialty` FOREIGN KEY (`specialty_id`) REFERENCES `specialty` (`specialty_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,1,1,'Gynecology',1),(2,1,2,'Medicine',1),(3,2,1,'Gynecology',1),(4,3,1,'Gynecology',1),(5,3,2,'Medicine',1),(6,3,3,'Pediatrics',1),(7,4,1,'Gynecology',1),(8,4,3,'Pediatrics',1),(9,4,6,'Orthopedics',1),(10,5,1,'Gynecology',1),(11,5,2,'Medicine',1),(12,5,4,'General Surgery',1),(13,6,1,'Gynecology',1),(14,6,5,'Cardiology',1),(15,7,1,'Gynecology',1),(16,7,5,'Cardiology',1),(17,7,4,'General Surgery',1),(18,8,1,'Gynecology',1),(19,8,3,'Pediatrics',1);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_capacity`
--

DROP TABLE IF EXISTS `department_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_capacity` (
  `capacity_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int unsigned NOT NULL,
  `capacity_date` date NOT NULL,
  `daily_limit` int unsigned NOT NULL,
  PRIMARY KEY (`capacity_id`),
  UNIQUE KEY `uq_department_capacity` (`department_id`,`capacity_date`),
  CONSTRAINT `fk_capacity_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_daily_limit` CHECK ((`daily_limit` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_capacity`
--

LOCK TABLES `department_capacity` WRITE;
/*!40000 ALTER TABLE `department_capacity` DISABLE KEYS */;
INSERT INTO `department_capacity` VALUES (1,1,'2026-09-21',20),(2,2,'2026-09-21',25),(3,3,'2026-09-21',20),(4,4,'2026-09-21',15),(5,5,'2026-09-21',20),(6,6,'2026-09-21',20),(7,7,'2026-09-21',15),(8,8,'2026-09-21',20),(9,9,'2026-09-21',15),(10,10,'2026-09-21',30),(11,11,'2026-09-21',35),(12,12,'2026-09-21',25),(13,13,'2026-09-21',20),(14,14,'2026-09-21',20),(15,15,'2026-09-21',40),(16,16,'2026-09-21',30),(17,17,'2026-09-21',25),(18,18,'2026-09-21',25),(19,19,'2026-09-21',20),(20,1,'2026-09-25',20),(21,2,'2026-09-25',25),(22,3,'2026-09-25',20),(23,4,'2026-09-25',15),(24,5,'2026-09-25',20),(25,6,'2026-09-25',20),(26,7,'2026-09-25',15),(27,8,'2026-09-25',20),(28,9,'2026-09-25',15),(29,10,'2026-09-25',30),(30,11,'2026-09-25',35),(31,12,'2026-09-25',25),(32,13,'2026-09-25',20),(33,14,'2026-09-25',20),(34,15,'2026-09-25',40),(35,16,'2026-09-25',30),(36,17,'2026-09-25',25),(37,18,'2026-09-25',25),(38,19,'2026-09-25',20);
/*!40000 ALTER TABLE `department_capacity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_slot`
--

DROP TABLE IF EXISTS `department_slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_slot` (
  `slot_id` int unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int unsigned NOT NULL,
  `slot_name` varchar(50) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`slot_id`),
  UNIQUE KEY `uq_slot_department_name` (`department_id`,`slot_name`),
  CONSTRAINT `fk_slot_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_slot_time` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_slot`
--

LOCK TABLES `department_slot` WRITE;
/*!40000 ALTER TABLE `department_slot` DISABLE KEYS */;
INSERT INTO `department_slot` VALUES (1,1,'Morning-1','09:00:00','11:00:00',1),(2,1,'Morning-2','11:00:00','13:00:00',1),(3,2,'Morning-1','09:00:00','11:00:00',1),(4,2,'Morning-2','11:00:00','13:00:00',1),(5,3,'Morning-1','09:00:00','11:00:00',1),(6,3,'Morning-2','11:00:00','13:00:00',1),(7,4,'Morning-1','09:00:00','11:00:00',1),(8,4,'Morning-2','11:00:00','13:00:00',1),(9,5,'Morning-1','09:00:00','11:00:00',1),(10,5,'Morning-2','11:00:00','13:00:00',1),(11,6,'Morning-1','09:00:00','11:00:00',1),(12,6,'Morning-2','11:00:00','13:00:00',1),(13,7,'Morning-1','09:00:00','11:00:00',1),(14,7,'Morning-2','11:00:00','13:00:00',1),(15,8,'Morning-1','09:00:00','11:00:00',1),(16,8,'Morning-2','11:00:00','13:00:00',1),(17,9,'Morning-1','09:00:00','11:00:00',1),(18,9,'Morning-2','11:00:00','13:00:00',1),(19,10,'Morning-1','09:00:00','11:00:00',1),(20,10,'Morning-2','11:00:00','13:00:00',1),(21,11,'Morning-1','09:00:00','11:00:00',1),(22,11,'Morning-2','11:00:00','13:00:00',1),(23,12,'Morning-1','09:00:00','11:00:00',1),(24,12,'Morning-2','11:00:00','13:00:00',1),(25,13,'Morning-1','09:00:00','11:00:00',1),(26,13,'Morning-2','11:00:00','13:00:00',1),(27,14,'Morning-1','09:00:00','11:00:00',1),(28,14,'Morning-2','11:00:00','13:00:00',1),(29,15,'Morning-1','09:00:00','11:00:00',1),(30,15,'Morning-2','11:00:00','13:00:00',1),(31,16,'Morning-1','09:00:00','11:00:00',1),(32,16,'Morning-2','11:00:00','13:00:00',1),(33,17,'Morning-1','09:00:00','11:00:00',1),(34,17,'Morning-2','11:00:00','13:00:00',1),(35,18,'Morning-1','09:00:00','11:00:00',1),(36,18,'Morning-2','11:00:00','13:00:00',1),(37,19,'Morning-1','09:00:00','11:00:00',1),(38,19,'Morning-2','11:00:00','13:00:00',1);
/*!40000 ALTER TABLE `department_slot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `district`
--

DROP TABLE IF EXISTS `district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `district` (
  `district_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`district_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `district`
--

LOCK TABLES `district` WRITE;
/*!40000 ALTER TABLE `district` DISABLE KEYS */;
INSERT INTO `district` VALUES (1,'Dhaka'),(2,'Gazipur');
/*!40000 ALTER TABLE `district` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `doctor_id` int unsigned NOT NULL AUTO_INCREMENT,
  `registration_no` varchar(50) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`doctor_id`),
  UNIQUE KEY `registration_no` (`registration_no`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'BMDC-10001','Dr. Nusrat Jahan','01811000001','nusrat.jahan@referralpath.test','ACTIVE'),(2,'BMDC-10002','Dr. Arif Hossain','01811000002','arif.hossain@referralpath.test','ACTIVE'),(3,'BMDC-10003','Dr. Sadia Rahman','01811000003','sadia.rahman@referralpath.test','ACTIVE'),(4,'BMDC-10004','Dr. Mahmud Karim','01811000004','mahmud.karim@referralpath.test','ACTIVE'),(5,'BMDC-10005','Dr. Farzana Akter','01811000005','farzana.akter@referralpath.test','ACTIVE'),(6,'BMDC-10006','Dr. Tanvir Ahmed','01811000006','tanvir.ahmed@referralpath.test','ACTIVE'),(7,'BMDC-10007','Dr. Samia Islam','01811000007','samia.islam@referralpath.test','ACTIVE'),(8,'BMDC-10008','Dr. Rafiul Hasan','01811000008','rafiul.hasan@referralpath.test','ACTIVE'),(9,'BMDC-10009','Dr. Mitu Sultana','01811000009','mitu.sultana@referralpath.test','ACTIVE'),(10,'BMDC-10010','Dr. Imran Kabir','01811000010','imran.kabir@referralpath.test','ACTIVE'),(11,'BMDC-10011','Dr. Jannatul Ferdous','01811000011','jannatul.ferdous@referralpath.test','ACTIVE'),(12,'BMDC-10012','Dr. Shakil Ahmed','01811000012','shakil.ahmed@referralpath.test','ACTIVE');
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_assignment`
--

DROP TABLE IF EXISTS `doctor_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_assignment` (
  `assignment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `doctor_id` int unsigned NOT NULL,
  `department_id` int unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`assignment_id`),
  KEY `fk_assignment_doctor` (`doctor_id`),
  KEY `fk_assignment_department` (`department_id`),
  CONSTRAINT `fk_assignment_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_assignment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_assignment_dates` CHECK (((`end_date` is null) or (`end_date` >= `start_date`)))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_assignment`
--

LOCK TABLES `doctor_assignment` WRITE;
/*!40000 ALTER TABLE `doctor_assignment` DISABLE KEYS */;
INSERT INTO `doctor_assignment` VALUES (1,1,1,'2026-01-01',NULL,1),(2,2,4,'2026-01-01',NULL,1),(3,3,3,'2026-01-01',NULL,1),(4,4,5,'2026-01-01',NULL,1),(5,5,7,'2026-01-01',NULL,1),(6,6,10,'2026-01-01',NULL,1),(7,7,11,'2026-01-01',NULL,1),(8,8,13,'2026-01-01',NULL,1),(9,9,14,'2026-01-01',NULL,1),(10,10,15,'2026-01-01',NULL,1),(11,11,16,'2026-01-01',NULL,1),(12,12,6,'2026-01-01',NULL,1);
/*!40000 ALTER TABLE `doctor_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_credential`
--

DROP TABLE IF EXISTS `doctor_credential`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_credential` (
  `credential_id` int unsigned NOT NULL AUTO_INCREMENT,
  `doctor_id` int unsigned NOT NULL,
  `facility_id` int unsigned NOT NULL,
  `staff_id` varchar(50) NOT NULL,
  `card_uid` varchar(100) NOT NULL,
  `active_from` datetime NOT NULL,
  `active_to` datetime DEFAULT NULL,
  PRIMARY KEY (`credential_id`),
  UNIQUE KEY `staff_id` (`staff_id`),
  UNIQUE KEY `card_uid` (`card_uid`),
  KEY `fk_credential_doctor` (`doctor_id`),
  KEY `fk_credential_facility` (`facility_id`),
  CONSTRAINT `fk_credential_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_credential_facility` FOREIGN KEY (`facility_id`) REFERENCES `health_facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_credential_dates` CHECK (((`active_to` is null) or (`active_to` >= `active_from`)))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_credential`
--

LOCK TABLES `doctor_credential` WRITE;
/*!40000 ALTER TABLE `doctor_credential` DISABLE KEYS */;
INSERT INTO `doctor_credential` VALUES (1,1,1,'STF-KUS-001','CARD-KUS-001','2026-01-01 00:00:00',NULL),(2,2,3,'STF-DHA-UHC-001','CARD-DHA-UHC-001','2026-01-01 00:00:00',NULL),(3,3,2,'STF-SUT-001','CARD-SUT-001','2026-01-01 00:00:00',NULL),(4,4,3,'STF-DHA-UHC-002','CARD-DHA-UHC-002','2026-01-01 00:00:00',NULL),(5,5,4,'STF-SAV-001','CARD-SAV-001','2026-01-01 00:00:00',NULL),(6,6,5,'STF-DHK-DIST-001','CARD-DHK-DIST-001','2026-01-01 00:00:00',NULL),(7,7,5,'STF-DHK-DIST-002','CARD-DHK-DIST-002','2026-01-01 00:00:00',NULL),(8,8,6,'STF-GAZ-DIST-001','CARD-GAZ-DIST-001','2026-01-01 00:00:00',NULL),(9,9,6,'STF-GAZ-DIST-002','CARD-GAZ-DIST-002','2026-01-01 00:00:00',NULL),(10,10,7,'STF-DMC-001','CARD-DMC-001','2026-01-01 00:00:00',NULL),(11,11,7,'STF-DMC-002','CARD-DMC-002','2026-01-01 00:00:00',NULL),(12,12,3,'STF-DHA-UHC-003','CARD-DHA-UHC-003','2026-01-01 00:00:00',NULL);
/*!40000 ALTER TABLE `doctor_credential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_facility`
--

DROP TABLE IF EXISTS `health_facility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_facility` (
  `facility_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `facility_level` enum('UNION','UPAZILA','DISTRICT') NOT NULL,
  `facility_type` enum('UNION_FACILITY','UPAZILA_HEALTH_COMPLEX','DISTRICT_GOVERNMENT_HOSPITAL','MEDICAL_COLLEGE_HOSPITAL') NOT NULL,
  `upazila_id` int unsigned NOT NULL,
  `union_id` int unsigned DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`facility_id`),
  UNIQUE KEY `uq_facility_name_upazila` (`upazila_id`,`name`),
  KEY `fk_facility_union` (`union_id`),
  CONSTRAINT `fk_facility_union` FOREIGN KEY (`union_id`) REFERENCES `administrative_union` (`union_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_facility_upazila` FOREIGN KEY (`upazila_id`) REFERENCES `upazila` (`upazila_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_facility`
--

LOCK TABLES `health_facility` WRITE;
/*!40000 ALTER TABLE `health_facility` DISABLE KEYS */;
INSERT INTO `health_facility` VALUES (1,'Kushura Union Health Centre','UNION','UNION_FACILITY',1,1,'Kushura, Dhamrai, Dhaka','01711000001',23.855100,90.070200,1),(2,'Sutipara Union Health Centre','UNION','UNION_FACILITY',1,2,'Sutipara, Dhamrai, Dhaka','01711000002',23.820500,90.120100,1),(3,'Dhamrai Upazila Health Complex','UPAZILA','UPAZILA_HEALTH_COMPLEX',1,NULL,'Dhamrai Upazila, Dhaka','01711000003',23.913100,90.142500,1),(4,'Savar Upazila Health Complex','UPAZILA','UPAZILA_HEALTH_COMPLEX',2,NULL,'Savar, Dhaka','01711000004',23.858300,90.266900,1),(5,'Dhaka District Government Hospital','DISTRICT','DISTRICT_GOVERNMENT_HOSPITAL',1,NULL,'Dhaka District, Bangladesh','01711000005',23.810300,90.412500,1),(6,'Gazipur District Government Hospital','DISTRICT','DISTRICT_GOVERNMENT_HOSPITAL',3,NULL,'Gazipur District, Bangladesh','01711000006',24.002500,90.426400,1),(7,'Dhaka Medical College Hospital','DISTRICT','MEDICAL_COLLEGE_HOSPITAL',1,NULL,'Dhaka, Bangladesh','01711000007',23.725800,90.397000,1),(8,'Gazipur Medical College Hospital','DISTRICT','MEDICAL_COLLEGE_HOSPITAL',3,NULL,'Gazipur, Bangladesh','01711000008',24.006400,90.397800,1);
/*!40000 ALTER TABLE `health_facility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER','UNSPECIFIED') NOT NULL DEFAULT 'UNSPECIFIED',
  `blood_group` enum('A_POS','A_NEG','B_POS','B_NEG','AB_POS','AB_NEG','O_POS','O_NEG','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
  `address` varchar(255) DEFAULT NULL,
  `union_id` int unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`),
  KEY `fk_patient_union` (`union_id`),
  CONSTRAINT `fk_patient_union` FOREIGN KEY (`union_id`) REFERENCES `administrative_union` (`union_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'Rahim Uddin','01710000001','rahim@gmail.com','1998-04-12','MALE','B_POS','Kushura, Dhamrai',1,'2026-09-20 20:16:10'),(2,'Nusrat Akter','01710000002','nusrat@gmail.com','2001-08-22','FEMALE','O_POS','Kushura, Dhamrai',1,'2026-09-20 20:16:10'),(3,'Karim Hasan','01710000003','karim@gmail.com','1995-02-14','MALE','A_POS','Sutipara, Dhamrai',2,'2026-09-20 20:16:10'),(4,'Mitu Rahman','01710000004','mitu@gmail.com','2000-11-05','FEMALE','AB_POS','Sutipara, Dhamrai',2,'2026-09-20 20:16:10'),(5,'Sakib Ahmed','01710000005','sakib@gmail.com','1997-06-30','MALE','O_NEG','Tetuljhora, Savar',3,'2026-09-20 20:16:10'),(6,'Tania Sultana','01710000006','tania@gmail.com','1999-03-18','FEMALE','B_POS','Tetuljhora, Savar',3,'2026-09-20 20:16:10'),(7,'Imran Hossain','01710000007','imran@gmail.com','1994-09-09','MALE','A_NEG','Aminbazar, Savar',4,'2026-09-20 20:16:10'),(8,'Jannat Ara','01710000008','jannat@gmail.com','2002-01-27','FEMALE','O_POS','Aminbazar, Savar',4,'2026-09-20 20:16:10'),(9,'Fahim Chowdhury','01710000009','fahim@gmail.com','1996-12-11','MALE','B_NEG','Basan, Gazipur',5,'2026-09-20 20:16:10'),(10,'Rima Yasmin','01710000010','rima@gmail.com','2001-05-24','FEMALE','A_POS','Basan, Gazipur',5,'2026-09-20 20:16:10'),(11,'Nayeem Islam','01710000011','nayeem@gmail.com','1993-07-16','MALE','O_POS','Harinal, Gazipur',6,'2026-09-20 20:16:10'),(12,'Shila Akter','01710000012','shila@gmail.com','1998-10-03','FEMALE','AB_NEG','Harinal, Gazipur',6,'2026-09-20 20:16:10'),(13,'Rafi Khan','01710000013','rafi@gmail.com','1999-01-19','MALE','B_POS','Mouchak, Kaliakair',7,'2026-09-20 20:16:10'),(14,'Mariya Islam','01710000014','mariya@gmail.com','2000-07-07','FEMALE','O_POS','Mouchak, Kaliakair',7,'2026-09-20 20:16:10'),(15,'Siam Hossain','01710000015','siam@gmail.com','1997-03-02','MALE','A_POS','Kushura, Dhamrai',1,'2026-09-20 20:16:10');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral_check`
--

DROP TABLE IF EXISTS `referral_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referral_check` (
  `check_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `referral_id` bigint unsigned NOT NULL,
  `facility_id` int unsigned NOT NULL,
  `sequence_no` int unsigned NOT NULL,
  `checked_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `doctor_availability` enum('AVAILABLE','UNAVAILABLE','STALE','NO_DATA') NOT NULL,
  `capacity_status` enum('AVAILABLE','LIMITED','FULL','NO_DATA') NOT NULL,
  `attendance_freshness` enum('FRESH','STALE','NO_DATA') NOT NULL,
  `reason` varchar(255) NOT NULL,
  `is_selected` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`check_id`),
  UNIQUE KEY `uq_referral_sequence` (`referral_id`,`sequence_no`),
  UNIQUE KEY `uq_referral_facility` (`referral_id`,`facility_id`),
  KEY `fk_check_facility` (`facility_id`),
  CONSTRAINT `fk_check_facility` FOREIGN KEY (`facility_id`) REFERENCES `health_facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_check_referral` FOREIGN KEY (`referral_id`) REFERENCES `referral_request` (`referral_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referral_check`
--

LOCK TABLES `referral_check` WRITE;
/*!40000 ALTER TABLE `referral_check` DISABLE KEYS */;
INSERT INTO `referral_check` VALUES (1,2,1,1,'2026-09-21 07:21:36','STALE','AVAILABLE','STALE','Attendance information is stale',0),(2,2,3,2,'2026-09-21 07:21:36','STALE','AVAILABLE','STALE','Attendance information is stale',0),(3,2,5,3,'2026-09-21 07:21:36','STALE','AVAILABLE','STALE','Attendance information is stale',0),(4,2,7,4,'2026-09-21 07:21:36','STALE','AVAILABLE','STALE','Attendance information is stale',0),(8,3,1,1,'2026-09-21 07:26:50','STALE','AVAILABLE','STALE','Attendance information is stale',0),(9,3,3,2,'2026-09-21 07:26:50','UNAVAILABLE','AVAILABLE','FRESH','No currently available doctor',0),(10,3,5,3,'2026-09-21 07:26:50','STALE','AVAILABLE','STALE','Attendance information is stale',0),(11,3,7,4,'2026-09-21 07:26:50','STALE','AVAILABLE','STALE','Attendance information is stale',0),(12,4,1,1,'2026-09-24 18:25:11','AVAILABLE','AVAILABLE','FRESH','Eligible facility',0),(13,4,3,2,'2026-09-24 18:25:11','UNAVAILABLE','AVAILABLE','FRESH','No currently available doctor',0),(14,4,5,3,'2026-09-24 18:25:11','AVAILABLE','AVAILABLE','FRESH','Eligible facility',1),(15,4,7,4,'2026-09-24 18:25:11','AVAILABLE','AVAILABLE','FRESH','Eligible facility',0);
/*!40000 ALTER TABLE `referral_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral_request`
--

DROP TABLE IF EXISTS `referral_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referral_request` (
  `referral_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` bigint unsigned NOT NULL,
  `requested_union_id` int unsigned NOT NULL,
  `specialty_id` int unsigned NOT NULL,
  `origin_facility_id` int unsigned NOT NULL,
  `destination_facility_id` int unsigned DEFAULT NULL,
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` varchar(255) NOT NULL,
  `status` enum('REQUESTED','ROUTED','ACCEPTED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'REQUESTED',
  PRIMARY KEY (`referral_id`),
  KEY `fk_referral_union` (`requested_union_id`),
  KEY `fk_referral_specialty` (`specialty_id`),
  KEY `fk_referral_destination` (`destination_facility_id`),
  KEY `idx_referral_patient_time` (`patient_id`,`requested_at`),
  KEY `idx_referral_origin_time` (`origin_facility_id`,`requested_at`),
  CONSTRAINT `fk_referral_destination` FOREIGN KEY (`destination_facility_id`) REFERENCES `health_facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_referral_origin` FOREIGN KEY (`origin_facility_id`) REFERENCES `health_facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_referral_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_referral_specialty` FOREIGN KEY (`specialty_id`) REFERENCES `specialty` (`specialty_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_referral_union` FOREIGN KEY (`requested_union_id`) REFERENCES `administrative_union` (`union_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referral_request`
--

LOCK TABLES `referral_request` WRITE;
/*!40000 ALTER TABLE `referral_request` DISABLE KEYS */;
INSERT INTO `referral_request` VALUES (2,1,1,1,1,NULL,'2026-09-21 07:21:36','Gynecology specialist unavailable at local facility','REQUESTED'),(3,15,1,1,1,NULL,'2026-09-21 07:26:50','Gynecology unavailable at Union and Upazila facilities','REQUESTED'),(4,15,1,1,1,5,'2026-09-24 18:25:11','Referral lifecycle test','COMPLETED');
/*!40000 ALTER TABLE `referral_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specialty`
--

DROP TABLE IF EXISTS `specialty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialty` (
  `specialty_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`specialty_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialty`
--

LOCK TABLES `specialty` WRITE;
/*!40000 ALTER TABLE `specialty` DISABLE KEYS */;
INSERT INTO `specialty` VALUES (5,'Cardiology'),(4,'General Surgery'),(1,'Gynecology'),(2,'Medicine'),(6,'Orthopedics'),(3,'Pediatrics');
/*!40000 ALTER TABLE `specialty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upazila`
--

DROP TABLE IF EXISTS `upazila`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `upazila` (
  `upazila_id` int unsigned NOT NULL AUTO_INCREMENT,
  `district_id` int unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`upazila_id`),
  UNIQUE KEY `uq_upazila_district_name` (`district_id`,`name`),
  CONSTRAINT `fk_upazila_district` FOREIGN KEY (`district_id`) REFERENCES `district` (`district_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upazila`
--

LOCK TABLES `upazila` WRITE;
/*!40000 ALTER TABLE `upazila` DISABLE KEYS */;
INSERT INTO `upazila` VALUES (1,1,'Dhamrai'),(2,1,'Savar'),(3,2,'Gazipur Sadar'),(4,2,'Kaliakair');
/*!40000 ALTER TABLE `upazila` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_admin_dashboard`
--

DROP TABLE IF EXISTS `v_admin_dashboard`;
/*!50001 DROP VIEW IF EXISTS `v_admin_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_admin_dashboard` AS SELECT 
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `facility_level`,
 1 AS `total_departments`,
 1 AS `active_departments`,
 1 AS `no_doctor_departments`,
 1 AS `total_booked_appointments`,
 1 AS `total_remaining_capacity`,
 1 AS `available_doctors`,
 1 AS `last_attendance_update`,
 1 AS `attendance_freshness`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_appointment_dashboard`
--

DROP TABLE IF EXISTS `v_appointment_dashboard`;
/*!50001 DROP VIEW IF EXISTS `v_appointment_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_appointment_dashboard` AS SELECT 
 1 AS `appointment_id`,
 1 AS `appointment_date`,
 1 AS `appointment_status`,
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `phone`,
 1 AS `department_id`,
 1 AS `department_name`,
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `facility_level`,
 1 AS `slot_id`,
 1 AS `slot_name`,
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `doctor_id`,
 1 AS `doctor_name`,
 1 AS `queue_id`,
 1 AS `queue_number`,
 1 AS `queue_status`,
 1 AS `reason`,
 1 AS `rescheduled_from_id`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_department_live_status`
--

DROP TABLE IF EXISTS `v_department_live_status`;
/*!50001 DROP VIEW IF EXISTS `v_department_live_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_department_live_status` AS SELECT 
 1 AS `department_id`,
 1 AS `department_name`,
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `daily_limit`,
 1 AS `used_capacity`,
 1 AS `remaining_capacity`,
 1 AS `booked_appointments`,
 1 AS `available_doctors`,
 1 AS `assigned_doctors`,
 1 AS `department_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_doctor_attendance`
--

DROP TABLE IF EXISTS `v_doctor_attendance`;
/*!50001 DROP VIEW IF EXISTS `v_doctor_attendance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_doctor_attendance` AS SELECT 
 1 AS `doctor_id`,
 1 AS `full_name`,
 1 AS `credential_id`,
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `source_name`,
 1 AS `last_event_type`,
 1 AS `last_punch_at`,
 1 AS `attendance_status`,
 1 AS `attendance_freshness`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_facility_attendance`
--

DROP TABLE IF EXISTS `v_facility_attendance`;
/*!50001 DROP VIEW IF EXISTS `v_facility_attendance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_facility_attendance` AS SELECT 
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `source_id`,
 1 AS `source_name`,
 1 AS `stale_after_minutes`,
 1 AS `last_attendance_update`,
 1 AS `attendance_freshness`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_facility_dashboard`
--

DROP TABLE IF EXISTS `v_facility_dashboard`;
/*!50001 DROP VIEW IF EXISTS `v_facility_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_facility_dashboard` AS SELECT 
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `facility_level`,
 1 AS `union_id`,
 1 AS `upazila_id`,
 1 AS `district_id`,
 1 AS `specialty_id`,
 1 AS `specialty_name`,
 1 AS `available_doctors`,
 1 AS `remaining_capacity`,
 1 AS `booked_appointments`,
 1 AS `facility_referral_status`,
 1 AS `attendance_freshness`,
 1 AS `last_attendance_update`,
 1 AS `attendance_consistency_pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_facility_reliability`
--

DROP TABLE IF EXISTS `v_facility_reliability`;
/*!50001 DROP VIEW IF EXISTS `v_facility_reliability`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_facility_reliability` AS SELECT 
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `reliability_window_days`,
 1 AS `attendance_active_days`,
 1 AS `attendance_consistency_pct`,
 1 AS `last_attendance_update`,
 1 AS `attendance_freshness`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_patient_dashboard`
--

DROP TABLE IF EXISTS `v_patient_dashboard`;
/*!50001 DROP VIEW IF EXISTS `v_patient_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_patient_dashboard` AS SELECT 
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `phone`,
 1 AS `appointment_id`,
 1 AS `appointment_date`,
 1 AS `appointment_status`,
 1 AS `specialty`,
 1 AS `department_name`,
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `facility_level`,
 1 AS `slot_name`,
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `doctor_id`,
 1 AS `doctor_name`,
 1 AS `queue_number`,
 1 AS `queue_status`,
 1 AS `called_at`,
 1 AS `completed_at`,
 1 AS `referral_id`,
 1 AS `destination_facility_id`,
 1 AS `referral_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_patient_referral_history`
--

DROP TABLE IF EXISTS `v_patient_referral_history`;
/*!50001 DROP VIEW IF EXISTS `v_patient_referral_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_patient_referral_history` AS SELECT 
 1 AS `referral_id`,
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `phone`,
 1 AS `specialty`,
 1 AS `origin_facility`,
 1 AS `destination_facility`,
 1 AS `status`,
 1 AS `reason`,
 1 AS `requested_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_referral_candidate_status`
--

DROP TABLE IF EXISTS `v_referral_candidate_status`;
/*!50001 DROP VIEW IF EXISTS `v_referral_candidate_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_referral_candidate_status` AS SELECT 
 1 AS `department_id`,
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `facility_level`,
 1 AS `union_id`,
 1 AS `upazila_id`,
 1 AS `district_id`,
 1 AS `department_name`,
 1 AS `specialty_id`,
 1 AS `specialty_name`,
 1 AS `daily_limit`,
 1 AS `used_capacity`,
 1 AS `remaining_capacity`,
 1 AS `available_doctors`,
 1 AS `assigned_doctors`,
 1 AS `booked_appointments`,
 1 AS `department_status`,
 1 AS `last_attendance_update`,
 1 AS `attendance_freshness`,
 1 AS `referral_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_referral_facility_status`
--

DROP TABLE IF EXISTS `v_referral_facility_status`;
/*!50001 DROP VIEW IF EXISTS `v_referral_facility_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_referral_facility_status` AS SELECT 
 1 AS `facility_id`,
 1 AS `facility_name`,
 1 AS `facility_level`,
 1 AS `union_id`,
 1 AS `upazila_id`,
 1 AS `district_id`,
 1 AS `specialty_id`,
 1 AS `specialty_name`,
 1 AS `available_doctors`,
 1 AS `remaining_capacity`,
 1 AS `booked_appointments`,
 1 AS `last_attendance_update`,
 1 AS `attendance_freshness`,
 1 AS `is_eligible`,
 1 AS `facility_referral_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_today_queue`
--

DROP TABLE IF EXISTS `v_today_queue`;
/*!50001 DROP VIEW IF EXISTS `v_today_queue`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_today_queue` AS SELECT 
 1 AS `queue_id`,
 1 AS `queue_number`,
 1 AS `queue_date`,
 1 AS `queue_status`,
 1 AS `issued_at`,
 1 AS `called_at`,
 1 AS `completed_at`,
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `phone`,
 1 AS `department_id`,
 1 AS `department_name`,
 1 AS `appointment_id`,
 1 AS `appointment_date`,
 1 AS `appointment_status`,
 1 AS `doctor_id`,
 1 AS `doctor_name`,
 1 AS `facility_id`,
 1 AS `facility_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_admin_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `v_admin_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_admin_dashboard` AS select `hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`hf`.`facility_level` AS `facility_level`,count(distinct `d`.`department_id`) AS `total_departments`,count(distinct (case when (`vds`.`department_status` in ('AVAILABLE','LIMITED')) then `d`.`department_id` end)) AS `active_departments`,count(distinct (case when (`vds`.`department_status` = 'NO_DOCTOR') then `d`.`department_id` end)) AS `no_doctor_departments`,coalesce(sum(`vds`.`booked_appointments`),0) AS `total_booked_appointments`,coalesce(sum(`vds`.`remaining_capacity`),0) AS `total_remaining_capacity`,coalesce(sum((case when (`vds`.`available_doctors` > 0) then `vds`.`available_doctors` else 0 end)),0) AS `available_doctors`,`fa`.`last_attendance_update` AS `last_attendance_update`,`fa`.`attendance_freshness` AS `attendance_freshness` from (((`health_facility` `hf` left join `department` `d` on((`d`.`facility_id` = `hf`.`facility_id`))) left join `v_department_live_status` `vds` on((`vds`.`department_id` = `d`.`department_id`))) left join `v_facility_attendance` `fa` on((`fa`.`facility_id` = `hf`.`facility_id`))) group by `hf`.`facility_id`,`hf`.`name`,`hf`.`facility_level`,`fa`.`last_attendance_update`,`fa`.`attendance_freshness` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_appointment_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `v_appointment_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_appointment_dashboard` AS select `a`.`appointment_id` AS `appointment_id`,`a`.`appointment_date` AS `appointment_date`,`a`.`status` AS `appointment_status`,`p`.`patient_id` AS `patient_id`,`p`.`full_name` AS `patient_name`,`p`.`phone` AS `phone`,`d`.`department_id` AS `department_id`,`d`.`name` AS `department_name`,`hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`hf`.`facility_level` AS `facility_level`,`ds`.`slot_id` AS `slot_id`,`ds`.`slot_name` AS `slot_name`,`ds`.`start_time` AS `start_time`,`ds`.`end_time` AS `end_time`,`a`.`doctor_id` AS `doctor_id`,`dr`.`full_name` AS `doctor_name`,`q`.`queue_id` AS `queue_id`,`q`.`queue_number` AS `queue_number`,`q`.`status` AS `queue_status`,`a`.`reason` AS `reason`,`a`.`rescheduled_from_id` AS `rescheduled_from_id`,`a`.`created_at` AS `created_at`,`a`.`updated_at` AS `updated_at` from ((((((`appointment` `a` join `patient` `p` on((`p`.`patient_id` = `a`.`patient_id`))) join `department` `d` on((`d`.`department_id` = `a`.`department_id`))) join `health_facility` `hf` on((`hf`.`facility_id` = `d`.`facility_id`))) join `department_slot` `ds` on((`ds`.`slot_id` = `a`.`slot_id`))) left join `doctor` `dr` on((`dr`.`doctor_id` = `a`.`doctor_id`))) left join `daily_queue` `q` on((`q`.`appointment_id` = `a`.`appointment_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_department_live_status`
--

/*!50001 DROP VIEW IF EXISTS `v_department_live_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_department_live_status` AS select `dep`.`department_id` AS `department_id`,`dep`.`name` AS `department_name`,`hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`dc`.`daily_limit` AS `daily_limit`,coalesce(`used`.`used_count`,0) AS `used_capacity`,greatest((`dc`.`daily_limit` - coalesce(`used`.`used_count`,0)),0) AS `remaining_capacity`,coalesce(`booked`.`booked_count`,0) AS `booked_appointments`,coalesce(`doc`.`available_doctors`,0) AS `available_doctors`,coalesce(`doc`.`assigned_doctors`,0) AS `assigned_doctors`,(case when (coalesce(`doc`.`available_doctors`,0) = 0) then 'NO_DOCTOR' when (greatest((`dc`.`daily_limit` - coalesce(`used`.`used_count`,0)),0) = 0) then 'FULL' when (coalesce(`used`.`used_count`,0) >= ceiling((`dc`.`daily_limit` * 0.80))) then 'LIMITED' else 'AVAILABLE' end) AS `department_status` from (((((`department` `dep` join `health_facility` `hf` on((`hf`.`facility_id` = `dep`.`facility_id`))) join `department_capacity` `dc` on(((`dc`.`department_id` = `dep`.`department_id`) and (`dc`.`capacity_date` = curdate())))) left join (select `appointment`.`department_id` AS `department_id`,count(0) AS `used_count` from `appointment` where ((`appointment`.`appointment_date` = curdate()) and (`appointment`.`status` in ('BOOKED','COMPLETED','NO_SHOW'))) group by `appointment`.`department_id`) `used` on((`used`.`department_id` = `dep`.`department_id`))) left join (select `appointment`.`department_id` AS `department_id`,count(0) AS `booked_count` from `appointment` where ((`appointment`.`appointment_date` = curdate()) and (`appointment`.`status` = 'BOOKED')) group by `appointment`.`department_id`) `booked` on((`booked`.`department_id` = `dep`.`department_id`))) left join (select `da`.`department_id` AS `department_id`,count(distinct `da`.`doctor_id`) AS `assigned_doctors`,count(distinct (case when (`va`.`attendance_status` = 'PRESENT') then `da`.`doctor_id` end)) AS `available_doctors` from ((`doctor_assignment` `da` join `doctor` `d` on(((`d`.`doctor_id` = `da`.`doctor_id`) and (`d`.`status` = 'ACTIVE')))) left join `v_doctor_attendance` `va` on((`va`.`doctor_id` = `da`.`doctor_id`))) where ((`da`.`start_date` <= curdate()) and ((`da`.`end_date` is null) or (`da`.`end_date` >= curdate()))) group by `da`.`department_id`) `doc` on((`doc`.`department_id` = `dep`.`department_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_doctor_attendance`
--

/*!50001 DROP VIEW IF EXISTS `v_doctor_attendance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_doctor_attendance` AS select `d`.`doctor_id` AS `doctor_id`,`d`.`full_name` AS `full_name`,`dc`.`credential_id` AS `credential_id`,`dc`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`aps`.`source_name` AS `source_name`,`latest`.`event_type` AS `last_event_type`,`latest`.`punched_at` AS `last_punch_at`,(case when (`latest`.`punched_at` is null) then 'NO_DATA' when ((`latest`.`event_type` = 'PUNCH_IN') and (timestampdiff(MINUTE,`latest`.`punched_at`,now()) <= `aps`.`stale_after_minutes`)) then 'PRESENT' when ((`latest`.`event_type` = 'PUNCH_OUT') and (timestampdiff(MINUTE,`latest`.`punched_at`,now()) <= `aps`.`stale_after_minutes`)) then 'NOT_PRESENT' else 'STALE' end) AS `attendance_status`,(case when (`latest`.`punched_at` is null) then 'NO_DATA' when (timestampdiff(MINUTE,`latest`.`punched_at`,now()) <= `aps`.`stale_after_minutes`) then 'FRESH' else 'STALE' end) AS `attendance_freshness` from ((((`doctor` `d` join `doctor_credential` `dc` on((`dc`.`doctor_id` = `d`.`doctor_id`))) join `health_facility` `hf` on((`hf`.`facility_id` = `dc`.`facility_id`))) join `attendance_source` `aps` on((`aps`.`source_id` = (select `s`.`source_id` from `attendance_source` `s` where ((`s`.`facility_id` = `dc`.`facility_id`) and (`s`.`is_active` = true)) order by `s`.`source_id` limit 1)))) left join (select `ap`.`credential_id` AS `credential_id`,`ap`.`event_type` AS `event_type`,`ap`.`punched_at` AS `punched_at` from (`attendance_punch` `ap` join (select `attendance_punch`.`credential_id` AS `credential_id`,max(`attendance_punch`.`punched_at`) AS `max_punched_at` from `attendance_punch` where (`attendance_punch`.`validation_status` = 'VALID') group by `attendance_punch`.`credential_id`) `x` on(((`x`.`credential_id` = `ap`.`credential_id`) and (`x`.`max_punched_at` = `ap`.`punched_at`)))) where (`ap`.`validation_status` = 'VALID')) `latest` on((`latest`.`credential_id` = `dc`.`credential_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_facility_attendance`
--

/*!50001 DROP VIEW IF EXISTS `v_facility_attendance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_facility_attendance` AS select `hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`aps`.`source_id` AS `source_id`,`aps`.`source_name` AS `source_name`,`aps`.`stale_after_minutes` AS `stale_after_minutes`,max(`ap`.`punched_at`) AS `last_attendance_update`,(case when (max(`ap`.`punched_at`) is null) then 'NO_DATA' when (timestampdiff(MINUTE,max(`ap`.`punched_at`),now()) <= `aps`.`stale_after_minutes`) then 'FRESH' else 'STALE' end) AS `attendance_freshness` from ((`health_facility` `hf` join `attendance_source` `aps` on(((`aps`.`facility_id` = `hf`.`facility_id`) and (`aps`.`is_active` = true)))) left join `attendance_punch` `ap` on(((`ap`.`source_id` = `aps`.`source_id`) and (`ap`.`validation_status` = 'VALID')))) group by `hf`.`facility_id`,`hf`.`name`,`aps`.`source_id`,`aps`.`source_name`,`aps`.`stale_after_minutes` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_facility_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `v_facility_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_facility_dashboard` AS select `r`.`facility_id` AS `facility_id`,`r`.`facility_name` AS `facility_name`,`r`.`facility_level` AS `facility_level`,`r`.`union_id` AS `union_id`,`r`.`upazila_id` AS `upazila_id`,`r`.`district_id` AS `district_id`,`r`.`specialty_id` AS `specialty_id`,`r`.`specialty_name` AS `specialty_name`,`r`.`available_doctors` AS `available_doctors`,`r`.`remaining_capacity` AS `remaining_capacity`,`r`.`booked_appointments` AS `booked_appointments`,`r`.`facility_referral_status` AS `facility_referral_status`,`r`.`attendance_freshness` AS `attendance_freshness`,`r`.`last_attendance_update` AS `last_attendance_update`,coalesce(`fr`.`attendance_consistency_pct`,0) AS `attendance_consistency_pct` from (`v_referral_facility_status` `r` left join `v_facility_reliability` `fr` on((`fr`.`facility_id` = `r`.`facility_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_facility_reliability`
--

/*!50001 DROP VIEW IF EXISTS `v_facility_reliability`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_facility_reliability` AS select `hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`aps`.`reliability_window_days` AS `reliability_window_days`,count(distinct (case when ((`ap`.`validation_status` = 'VALID') and (`ap`.`punched_at` >= (now() - interval `aps`.`reliability_window_days` day))) then cast(`ap`.`punched_at` as date) end)) AS `attendance_active_days`,round(((count(distinct (case when ((`ap`.`validation_status` = 'VALID') and (`ap`.`punched_at` >= (now() - interval `aps`.`reliability_window_days` day))) then cast(`ap`.`punched_at` as date) end)) / `aps`.`reliability_window_days`) * 100),2) AS `attendance_consistency_pct`,max(`ap`.`punched_at`) AS `last_attendance_update`,(case when (max(`ap`.`punched_at`) is null) then 'NO_DATA' when (timestampdiff(MINUTE,max(`ap`.`punched_at`),now()) <= `aps`.`stale_after_minutes`) then 'FRESH' else 'STALE' end) AS `attendance_freshness` from ((`health_facility` `hf` join `attendance_source` `aps` on(((`aps`.`facility_id` = `hf`.`facility_id`) and (`aps`.`is_active` = true)))) left join `attendance_punch` `ap` on((`ap`.`source_id` = `aps`.`source_id`))) group by `hf`.`facility_id`,`hf`.`name`,`aps`.`reliability_window_days`,`aps`.`stale_after_minutes` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_patient_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `v_patient_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_patient_dashboard` AS select `p`.`patient_id` AS `patient_id`,`p`.`full_name` AS `patient_name`,`p`.`phone` AS `phone`,`a`.`appointment_id` AS `appointment_id`,`a`.`appointment_date` AS `appointment_date`,`a`.`status` AS `appointment_status`,`s`.`name` AS `specialty`,`d`.`name` AS `department_name`,`hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name`,`hf`.`facility_level` AS `facility_level`,`ds`.`slot_name` AS `slot_name`,`ds`.`start_time` AS `start_time`,`ds`.`end_time` AS `end_time`,`a`.`doctor_id` AS `doctor_id`,`dr`.`full_name` AS `doctor_name`,`q`.`queue_number` AS `queue_number`,`q`.`status` AS `queue_status`,`q`.`called_at` AS `called_at`,`q`.`completed_at` AS `completed_at`,`rr`.`referral_id` AS `referral_id`,`rr`.`destination_facility_id` AS `destination_facility_id`,`rr`.`status` AS `referral_status` from ((((((((`patient` `p` left join `appointment` `a` on((`a`.`patient_id` = `p`.`patient_id`))) left join `department` `d` on((`d`.`department_id` = `a`.`department_id`))) left join `specialty` `s` on((`s`.`specialty_id` = `d`.`specialty_id`))) left join `health_facility` `hf` on((`hf`.`facility_id` = `d`.`facility_id`))) left join `department_slot` `ds` on((`ds`.`slot_id` = `a`.`slot_id`))) left join `doctor` `dr` on((`dr`.`doctor_id` = `a`.`doctor_id`))) left join `daily_queue` `q` on((`q`.`appointment_id` = `a`.`appointment_id`))) left join (select `r1`.`patient_id` AS `patient_id`,`r1`.`referral_id` AS `referral_id`,`r1`.`destination_facility_id` AS `destination_facility_id`,`r1`.`status` AS `status` from (`referral_request` `r1` join (select `referral_request`.`patient_id` AS `patient_id`,max(`referral_request`.`referral_id`) AS `latest_referral_id` from `referral_request` group by `referral_request`.`patient_id`) `latest` on((`latest`.`latest_referral_id` = `r1`.`referral_id`)))) `rr` on((`rr`.`patient_id` = `p`.`patient_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_patient_referral_history`
--

/*!50001 DROP VIEW IF EXISTS `v_patient_referral_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_patient_referral_history` AS select `rr`.`referral_id` AS `referral_id`,`rr`.`patient_id` AS `patient_id`,`p`.`full_name` AS `patient_name`,`p`.`phone` AS `phone`,`s`.`name` AS `specialty`,`origin_f`.`name` AS `origin_facility`,`dest_f`.`name` AS `destination_facility`,`rr`.`status` AS `status`,`rr`.`reason` AS `reason`,`rr`.`requested_at` AS `requested_at` from ((((`referral_request` `rr` join `patient` `p` on((`p`.`patient_id` = `rr`.`patient_id`))) join `specialty` `s` on((`s`.`specialty_id` = `rr`.`specialty_id`))) join `health_facility` `origin_f` on((`origin_f`.`facility_id` = `rr`.`origin_facility_id`))) left join `health_facility` `dest_f` on((`dest_f`.`facility_id` = `rr`.`destination_facility_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_referral_candidate_status`
--

/*!50001 DROP VIEW IF EXISTS `v_referral_candidate_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_referral_candidate_status` AS select `v`.`department_id` AS `department_id`,`v`.`facility_id` AS `facility_id`,`v`.`facility_name` AS `facility_name`,`hf`.`facility_level` AS `facility_level`,`hf`.`union_id` AS `union_id`,`hf`.`upazila_id` AS `upazila_id`,`up`.`district_id` AS `district_id`,`v`.`department_name` AS `department_name`,`s`.`specialty_id` AS `specialty_id`,`s`.`name` AS `specialty_name`,`v`.`daily_limit` AS `daily_limit`,`v`.`used_capacity` AS `used_capacity`,`v`.`remaining_capacity` AS `remaining_capacity`,`v`.`available_doctors` AS `available_doctors`,`v`.`assigned_doctors` AS `assigned_doctors`,`v`.`booked_appointments` AS `booked_appointments`,`v`.`department_status` AS `department_status`,`fa`.`last_attendance_update` AS `last_attendance_update`,`fa`.`attendance_freshness` AS `attendance_freshness`,(case when (`hf`.`is_active` = false) then 'FACILITY_INACTIVE' when (`fa`.`attendance_freshness` = 'STALE') then 'STALE_DATA' when (`v`.`available_doctors` = 0) then 'NO_DOCTOR' when (`v`.`remaining_capacity` = 0) then 'FULL' when (`v`.`department_status` in ('AVAILABLE','LIMITED')) then 'ELIGIBLE' else 'UNAVAILABLE' end) AS `referral_status` from (((((`v_department_live_status` `v` join `health_facility` `hf` on((`hf`.`facility_id` = `v`.`facility_id`))) join `upazila` `up` on((`up`.`upazila_id` = `hf`.`upazila_id`))) join `department` `dep` on((`dep`.`department_id` = `v`.`department_id`))) join `specialty` `s` on((`s`.`specialty_id` = `dep`.`specialty_id`))) left join `v_facility_attendance` `fa` on((`fa`.`facility_id` = `v`.`facility_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_referral_facility_status`
--

/*!50001 DROP VIEW IF EXISTS `v_referral_facility_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_referral_facility_status` AS select `v_referral_candidate_status`.`facility_id` AS `facility_id`,`v_referral_candidate_status`.`facility_name` AS `facility_name`,`v_referral_candidate_status`.`facility_level` AS `facility_level`,`v_referral_candidate_status`.`union_id` AS `union_id`,`v_referral_candidate_status`.`upazila_id` AS `upazila_id`,`v_referral_candidate_status`.`district_id` AS `district_id`,`v_referral_candidate_status`.`specialty_id` AS `specialty_id`,`v_referral_candidate_status`.`specialty_name` AS `specialty_name`,max(`v_referral_candidate_status`.`available_doctors`) AS `available_doctors`,max(`v_referral_candidate_status`.`remaining_capacity`) AS `remaining_capacity`,max(`v_referral_candidate_status`.`booked_appointments`) AS `booked_appointments`,max(`v_referral_candidate_status`.`last_attendance_update`) AS `last_attendance_update`,(case when (max((case when (`v_referral_candidate_status`.`attendance_freshness` = 'FRESH') then 1 else 0 end)) = 1) then 'FRESH' when (max((case when (`v_referral_candidate_status`.`attendance_freshness` = 'STALE') then 1 else 0 end)) = 1) then 'STALE' else 'NO_DATA' end) AS `attendance_freshness`,max((case when (`v_referral_candidate_status`.`referral_status` = 'ELIGIBLE') then 1 else 0 end)) AS `is_eligible`,(case when (max((case when (`v_referral_candidate_status`.`referral_status` = 'ELIGIBLE') then 1 else 0 end)) = 1) then 'ELIGIBLE' when (max((case when (`v_referral_candidate_status`.`referral_status` = 'STALE_DATA') then 1 else 0 end)) = 1) then 'STALE_DATA' when (max((case when (`v_referral_candidate_status`.`referral_status` = 'NO_DOCTOR') then 1 else 0 end)) = 1) then 'NO_DOCTOR' when (max((case when (`v_referral_candidate_status`.`referral_status` = 'FULL') then 1 else 0 end)) = 1) then 'FULL' else 'UNAVAILABLE' end) AS `facility_referral_status` from `v_referral_candidate_status` group by `v_referral_candidate_status`.`facility_id`,`v_referral_candidate_status`.`facility_name`,`v_referral_candidate_status`.`facility_level`,`v_referral_candidate_status`.`union_id`,`v_referral_candidate_status`.`upazila_id`,`v_referral_candidate_status`.`district_id`,`v_referral_candidate_status`.`specialty_id`,`v_referral_candidate_status`.`specialty_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_today_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_today_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_today_queue` AS select `q`.`queue_id` AS `queue_id`,`q`.`queue_number` AS `queue_number`,`q`.`queue_date` AS `queue_date`,`q`.`status` AS `queue_status`,`q`.`issued_at` AS `issued_at`,`q`.`called_at` AS `called_at`,`q`.`completed_at` AS `completed_at`,`p`.`patient_id` AS `patient_id`,`p`.`full_name` AS `patient_name`,`p`.`phone` AS `phone`,`q`.`department_id` AS `department_id`,`d`.`name` AS `department_name`,`a`.`appointment_id` AS `appointment_id`,`a`.`appointment_date` AS `appointment_date`,`a`.`status` AS `appointment_status`,`a`.`doctor_id` AS `doctor_id`,`dr`.`full_name` AS `doctor_name`,`hf`.`facility_id` AS `facility_id`,`hf`.`name` AS `facility_name` from (((((`daily_queue` `q` join `patient` `p` on((`p`.`patient_id` = `q`.`patient_id`))) join `department` `d` on((`d`.`department_id` = `q`.`department_id`))) join `health_facility` `hf` on((`hf`.`facility_id` = `d`.`facility_id`))) left join `appointment` `a` on((`a`.`appointment_id` = `q`.`appointment_id`))) left join `doctor` `dr` on((`dr`.`doctor_id` = `a`.`doctor_id`))) where (`q`.`queue_date` = curdate()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-02 21:09:08

--
-- Stored procedures
--
DELIMITER ;;
DROP PROCEDURE IF EXISTS `sp_book_appointment`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_book_appointment`(
    IN p_patient_id BIGINT UNSIGNED,
    IN p_department_id INT UNSIGNED,
    IN p_slot_id INT UNSIGNED,
    IN p_doctor_id INT UNSIGNED,
    IN p_appointment_date DATE,
    IN p_reason VARCHAR(255)
)
BEGIN
    DECLARE v_daily_limit INT;
    DECLARE v_used_count INT;
    DECLARE v_slot_department INT;
    DECLARE v_assignment_count INT;
    DECLARE v_doctor_available INT;
    DECLARE v_appointment_id BIGINT UNSIGNED;
    DECLARE v_queue_number INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    /* Lock the capacity row for this department/date */
    SELECT daily_limit
    INTO v_daily_limit
    FROM department_capacity
    WHERE department_id = p_department_id
      AND capacity_date = p_appointment_date
    FOR UPDATE;

    IF v_daily_limit IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'No daily capacity is configured for this department and date';
    END IF;

    /* Verify slot belongs to department */
    SELECT department_id
    INTO v_slot_department
    FROM department_slot
    WHERE slot_id = p_slot_id
      AND is_active = TRUE;

    IF v_slot_department IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Selected appointment slot does not exist or is inactive';
    END IF;

    IF v_slot_department <> p_department_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Selected slot does not belong to the selected department';
    END IF;

    /* Count capacity-consuming appointments */
    SELECT COUNT(*)
    INTO v_used_count
    FROM appointment
    WHERE department_id = p_department_id
      AND appointment_date = p_appointment_date
      AND status IN ('BOOKED', 'COMPLETED', 'NO_SHOW');

    IF v_used_count >= v_daily_limit THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Daily department capacity has been reached';
    END IF;

    /* If a doctor is specified, verify assignment */
    IF p_doctor_id IS NOT NULL THEN

        SELECT COUNT(*)
        INTO v_assignment_count
        FROM doctor_assignment
        WHERE doctor_id = p_doctor_id
          AND department_id = p_department_id
          AND start_date <= p_appointment_date
          AND (
              end_date IS NULL
              OR end_date >= p_appointment_date
          );

        IF v_assignment_count = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'Doctor is not assigned to this department on the appointment date';
        END IF;

        /* For today's appointments, doctor must currently be present */
        IF p_appointment_date = CURRENT_DATE() THEN

            SELECT COUNT(*)
            INTO v_doctor_available
            FROM v_doctor_attendance
            WHERE doctor_id = p_doctor_id
              AND attendance_status = 'PRESENT';

            IF v_doctor_available = 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT =
                    'Selected doctor is not currently available';
            END IF;

        END IF;

    END IF;

    /* Create appointment */
    INSERT INTO appointment
    (
        patient_id,
        department_id,
        slot_id,
        doctor_id,
        appointment_date,
        status,
        reason
    )
    VALUES
    (
        p_patient_id,
        p_department_id,
        p_slot_id,
        p_doctor_id,
        p_appointment_date,
        'BOOKED',
        p_reason
    );

    SET v_appointment_id = LAST_INSERT_ID();

    /* Generate next queue number */
    SELECT
        COALESCE(MAX(queue_number), 0) + 1
    INTO v_queue_number
    FROM daily_queue
    WHERE department_id = p_department_id
      AND queue_date = p_appointment_date;

    /* Create today's queue entry */
    INSERT INTO daily_queue
    (
        patient_id,
        appointment_id,
        department_id,
        queue_number,
        queue_date,
        status
    )
    VALUES
    (
        p_patient_id,
        v_appointment_id,
        p_department_id,
        v_queue_number,
        p_appointment_date,
        'WAITING'
    );

    COMMIT;

    /* Return booking result */
    SELECT
        a.appointment_id,
        a.patient_id,
        p.full_name AS patient_name,
        a.department_id,
        d.name AS department_name,
        a.slot_id,
        ds.slot_name,
        a.doctor_id,
        dr.full_name AS doctor_name,
        a.appointment_date,
        a.status AS appointment_status,
        q.queue_number,
        q.status AS queue_status
    FROM appointment a
    JOIN patient p
        ON p.patient_id = a.patient_id
    JOIN department d
        ON d.department_id = a.department_id
    JOIN department_slot ds
        ON ds.slot_id = a.slot_id
    LEFT JOIN doctor dr
        ON dr.doctor_id = a.doctor_id
    JOIN daily_queue q
        ON q.appointment_id = a.appointment_id
    WHERE a.appointment_id = v_appointment_id;

END;;
DROP PROCEDURE IF EXISTS `sp_call_next_patient`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_call_next_patient`(
    IN p_department_id INT UNSIGNED,
    IN p_queue_date DATE
)
BEGIN
    DECLARE v_queue_id BIGINT UNSIGNED DEFAULT NULL;
    DECLARE v_patient_id BIGINT UNSIGNED;
    DECLARE v_queue_number INT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    /* Find and lock the next waiting patient */
    SELECT
        queue_id,
        patient_id,
        queue_number
    INTO
        v_queue_id,
        v_patient_id,
        v_queue_number
    FROM daily_queue
    WHERE department_id = p_department_id
      AND queue_date = p_queue_date
      AND status = 'WAITING'
    ORDER BY queue_number
    LIMIT 1
    FOR UPDATE;

    IF v_queue_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'No waiting patients are available in this queue';
    END IF;

    /* Call the patient */
    UPDATE daily_queue
    SET
        status = 'CALLED',
        called_at = CURRENT_TIMESTAMP()
    WHERE queue_id = v_queue_id;

    COMMIT;

    /* Return called patient */
    SELECT
        q.queue_id,
        q.queue_number,
        q.queue_date,
        q.patient_id,
        p.full_name AS patient_name,
        q.department_id,
        d.name AS department_name,
        q.status,
        q.called_at
    FROM daily_queue q
    JOIN patient p
        ON p.patient_id = q.patient_id
    JOIN department d
        ON d.department_id = q.department_id
    WHERE q.queue_id = v_queue_id;

END;;
DROP PROCEDURE IF EXISTS `sp_cancel_appointment`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cancel_appointment`(
    IN p_appointment_id BIGINT UNSIGNED
)
BEGIN
    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT status
    INTO v_status
    FROM appointment
    WHERE appointment_id = p_appointment_id
    FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment not found';
    END IF;

    IF v_status <> 'BOOKED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Only BOOKED appointments can be cancelled';
    END IF;

    UPDATE appointment
    SET status = 'CANCELLED'
    WHERE appointment_id = p_appointment_id;

    UPDATE daily_queue
    SET status = 'CANCELLED'
    WHERE appointment_id = p_appointment_id
      AND status IN ('WAITING', 'CALLED');

    COMMIT;

    SELECT
        a.appointment_id,
        a.status AS appointment_status,
        q.status AS queue_status
    FROM appointment a
    LEFT JOIN daily_queue q
        ON q.appointment_id = a.appointment_id
    WHERE a.appointment_id = p_appointment_id;

END;;
DROP PROCEDURE IF EXISTS `sp_complete_queue_visit`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_complete_queue_visit`(
    IN p_queue_id BIGINT UNSIGNED
)
BEGIN
    DECLARE v_appointment_id BIGINT UNSIGNED;
    DECLARE v_queue_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT
        appointment_id,
        status
    INTO
        v_appointment_id,
        v_queue_status
    FROM daily_queue
    WHERE queue_id = p_queue_id
    FOR UPDATE;

    IF v_queue_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Queue entry not found';
    END IF;

    IF v_queue_status NOT IN ('CALLED', 'IN_SERVICE') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Only CALLED or IN_SERVICE queue entries can be completed';
    END IF;

    /* Complete queue entry */
    UPDATE daily_queue
    SET
        status = 'COMPLETED',
        completed_at = CURRENT_TIMESTAMP()
    WHERE queue_id = p_queue_id;

    /* Complete linked appointment */
    IF v_appointment_id IS NOT NULL THEN
        UPDATE appointment
        SET status = 'COMPLETED'
        WHERE appointment_id = v_appointment_id
          AND status = 'BOOKED';
    END IF;

    COMMIT;

    SELECT
        q.queue_id,
        q.appointment_id,
        q.patient_id,
        p.full_name AS patient_name,
        q.department_id,
        q.queue_number,
        q.status AS queue_status,
        q.completed_at,
        a.status AS appointment_status
    FROM daily_queue q
    JOIN patient p
        ON p.patient_id = q.patient_id
    LEFT JOIN appointment a
        ON a.appointment_id = q.appointment_id
    WHERE q.queue_id = p_queue_id;

END;;
DROP PROCEDURE IF EXISTS `sp_find_referral_options`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_find_referral_options`(
    IN p_patient_id BIGINT UNSIGNED,
    IN p_specialty_id INT UNSIGNED
)
BEGIN
    DECLARE v_union_id INT UNSIGNED;
    DECLARE v_upazila_id INT UNSIGNED;
    DECLARE v_district_id INT UNSIGNED;

    SELECT
        p.union_id,
        au.upazila_id,
        up.district_id
    INTO
        v_union_id,
        v_upazila_id,
        v_district_id
    FROM patient p
    JOIN administrative_union au
        ON au.union_id = p.union_id
    JOIN upazila up
        ON up.upazila_id = au.upazila_id
    WHERE p.patient_id = p_patient_id;

    IF v_union_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Patient or patient geography not found';
    END IF;

    SELECT
        facility_id,
        facility_name,
        facility_level,
        specialty_name,
        available_doctors,
        remaining_capacity,
        booked_appointments,
        attendance_freshness,
        last_attendance_update,
        attendance_consistency_pct,
        facility_referral_status,

        CASE
            WHEN facility_level = 'UNION'
                 AND union_id = v_union_id
                THEN 1

            WHEN facility_level = 'UPAZILA'
                 AND upazila_id = v_upazila_id
                THEN 2

            WHEN facility_level = 'DISTRICT'
                 AND district_id = v_district_id
                THEN 3

            ELSE 99
        END AS hierarchy_priority

    FROM v_facility_dashboard

    WHERE specialty_id = p_specialty_id

      AND
      (
          (facility_level = 'UNION'
           AND union_id = v_union_id)

          OR

          (facility_level = 'UPAZILA'
           AND upazila_id = v_upazila_id)

          OR

          (facility_level = 'DISTRICT'
           AND district_id = v_district_id)
      )

    ORDER BY
        hierarchy_priority,
        CASE
            WHEN facility_referral_status = 'ELIGIBLE' THEN 0
            ELSE 1
        END,
        facility_id;

END;;
DROP PROCEDURE IF EXISTS `sp_record_attendance_punch`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_record_attendance_punch`(
    IN p_credential_id INT UNSIGNED,
    IN p_source_id INT UNSIGNED,
    IN p_event_type VARCHAR(10)
)
BEGIN
    DECLARE v_doctor_id INT UNSIGNED;
    DECLARE v_credential_facility INT UNSIGNED;
    DECLARE v_source_facility INT UNSIGNED;
    DECLARE v_active_from DATETIME;
    DECLARE v_active_to DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    /* Get credential information */
    SELECT
        doctor_id,
        facility_id,
        active_from,
        active_to
    INTO
        v_doctor_id,
        v_credential_facility,
        v_active_from,
        v_active_to
    FROM doctor_credential
    WHERE credential_id = p_credential_id
    FOR UPDATE;

    IF v_doctor_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid doctor credential';
    END IF;

    /* Check credential validity period */
    IF CURRENT_TIMESTAMP() < v_active_from
       OR (
           v_active_to IS NOT NULL
           AND CURRENT_TIMESTAMP() > v_active_to
       ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Doctor credential is not currently active';
    END IF;

    /* Get attendance source facility */
    SELECT facility_id
    INTO v_source_facility
    FROM attendance_source
    WHERE source_id = p_source_id
      AND is_active = TRUE;

    IF v_source_facility IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Attendance source is invalid or inactive';
    END IF;

    /* Credential and card reader must belong to same facility */
    IF v_credential_facility <> v_source_facility THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Attendance source does not belong to the credential facility';
    END IF;

    /* Only valid punch types are accepted */
    IF p_event_type NOT IN ('PUNCH_IN', 'PUNCH_OUT') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Event type must be PUNCH_IN or PUNCH_OUT';
    END IF;

    INSERT INTO attendance_punch
    (
        credential_id,
        source_id,
        event_type,
        punched_at,
        recorded_at,
        validation_status,
        validation_reason
    )
    VALUES
    (
        p_credential_id,
        p_source_id,
        p_event_type,
        CURRENT_TIMESTAMP(),
        CURRENT_TIMESTAMP(),
        'VALID',
        NULL
    );

    COMMIT;

    SELECT
        ap.punch_event_id,
        ap.credential_id,
        d.doctor_id,
        d.full_name AS doctor_name,
        hf.name AS facility_name,
        ap.event_type,
        ap.punched_at,
        ap.validation_status
    FROM attendance_punch ap
    JOIN doctor_credential dc
        ON dc.credential_id = ap.credential_id
    JOIN doctor d
        ON d.doctor_id = dc.doctor_id
    JOIN health_facility hf
        ON hf.facility_id = dc.facility_id
    WHERE ap.punch_event_id = LAST_INSERT_ID();

END;;
DROP PROCEDURE IF EXISTS `sp_reschedule_appointment`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reschedule_appointment`(
    IN p_appointment_id BIGINT UNSIGNED,
    IN p_new_slot_id INT UNSIGNED,
    IN p_new_doctor_id INT UNSIGNED,
    IN p_new_date DATE
)
BEGIN
    DECLARE v_patient_id BIGINT UNSIGNED;
    DECLARE v_department_id INT UNSIGNED;
    DECLARE v_reason VARCHAR(255);

    DECLARE v_slot_department INT;
    DECLARE v_assignment_count INT;
    DECLARE v_daily_limit INT;
    DECLARE v_used_count INT;
    DECLARE v_doctor_available INT;

    DECLARE v_new_appointment_id BIGINT UNSIGNED;
    DECLARE v_queue_number INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    /* Lock and read the original appointment */
    SELECT
        patient_id,
        department_id,
        reason
    INTO
        v_patient_id,
        v_department_id,
        v_reason
    FROM appointment
    WHERE appointment_id = p_appointment_id
      AND status = 'BOOKED'
    FOR UPDATE;

    IF v_patient_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Only an existing BOOKED appointment can be rescheduled';
    END IF;

    /* Verify new slot */
    SELECT department_id
    INTO v_slot_department
    FROM department_slot
    WHERE slot_id = p_new_slot_id
      AND is_active = TRUE;

    IF v_slot_department IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Selected new slot does not exist or is inactive';
    END IF;

    IF v_slot_department <> v_department_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Selected new slot does not belong to the appointment department';
    END IF;

    /* Check capacity for new date */
    SELECT daily_limit
    INTO v_daily_limit
    FROM department_capacity
    WHERE department_id = v_department_id
      AND capacity_date = p_new_date
    FOR UPDATE;

    IF v_daily_limit IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'No daily capacity is configured for the new appointment date';
    END IF;

    SELECT COUNT(*)
    INTO v_used_count
    FROM appointment
    WHERE department_id = v_department_id
      AND appointment_date = p_new_date
      AND status IN ('BOOKED', 'COMPLETED', 'NO_SHOW');

    IF p_new_date = (
        SELECT appointment_date
        FROM appointment
        WHERE appointment_id = p_appointment_id
    ) THEN
        SET v_used_count = v_used_count - 1;
    END IF;

    IF v_used_count >= v_daily_limit THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Daily department capacity has been reached for the new date';
    END IF;

    /* Verify new doctor assignment */
    IF p_new_doctor_id IS NOT NULL THEN

        SELECT COUNT(*)
        INTO v_assignment_count
        FROM doctor_assignment
        WHERE doctor_id = p_new_doctor_id
          AND department_id = v_department_id
          AND start_date <= p_new_date
          AND (
              end_date IS NULL
              OR end_date >= p_new_date
          );

        IF v_assignment_count = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'New doctor is not assigned to this department on the new date';
        END IF;

        /* For today's date, doctor must currently be present */
        IF p_new_date = CURRENT_DATE() THEN

            SELECT COUNT(*)
            INTO v_doctor_available
            FROM v_doctor_attendance
            WHERE doctor_id = p_new_doctor_id
              AND attendance_status = 'PRESENT';

            IF v_doctor_available = 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT =
                    'New doctor is not currently available';
            END IF;

        END IF;

    END IF;

    /* Mark original appointment as rescheduled */
    UPDATE appointment
    SET status = 'RESCHEDULED'
    WHERE appointment_id = p_appointment_id;

    UPDATE daily_queue
    SET status = 'CANCELLED'
    WHERE appointment_id = p_appointment_id
      AND status IN ('WAITING', 'CALLED');

    /* Create replacement appointment */
    INSERT INTO appointment
    (
        patient_id,
        department_id,
        slot_id,
        doctor_id,
        appointment_date,
        status,
        reason,
        rescheduled_from_id
    )
    VALUES
    (
        v_patient_id,
        v_department_id,
        p_new_slot_id,
        p_new_doctor_id,
        p_new_date,
        'BOOKED',
        v_reason,
        p_appointment_id
    );

    SET v_new_appointment_id = LAST_INSERT_ID();

    /* Create new queue entry */
    SELECT
        COALESCE(MAX(queue_number), 0) + 1
    INTO v_queue_number
    FROM daily_queue
    WHERE department_id = v_department_id
      AND queue_date = p_new_date;

    INSERT INTO daily_queue
    (
        patient_id,
        appointment_id,
        department_id,
        queue_number,
        queue_date,
        status
    )
    VALUES
    (
        v_patient_id,
        v_new_appointment_id,
        v_department_id,
        v_queue_number,
        p_new_date,
        'WAITING'
    );

    COMMIT;

    SELECT
        old_a.appointment_id AS original_appointment_id,
        old_a.status AS original_status,
        new_a.appointment_id AS new_appointment_id,
        new_a.appointment_date AS new_date,
        new_a.status AS new_status,
        q.queue_number,
        q.status AS queue_status
    FROM appointment old_a
    JOIN appointment new_a
        ON new_a.appointment_id = v_new_appointment_id
    JOIN daily_queue q
        ON q.appointment_id = new_a.appointment_id
    WHERE old_a.appointment_id = p_appointment_id;

END;;
DROP PROCEDURE IF EXISTS `sp_route_referral`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_route_referral`(
    IN p_patient_id BIGINT UNSIGNED,
    IN p_specialty_id INT UNSIGNED,
    IN p_origin_facility_id INT UNSIGNED,
    IN p_reason VARCHAR(255)
)
BEGIN
    DECLARE v_union_id INT UNSIGNED;
    DECLARE v_upazila_id INT UNSIGNED;
    DECLARE v_district_id INT UNSIGNED;

    DECLARE v_referral_id BIGINT UNSIGNED;
    DECLARE v_destination_id INT UNSIGNED DEFAULT NULL;

    /* Find patient's administrative hierarchy */
    SELECT
        p.union_id,
        au.upazila_id,
        up.district_id
    INTO
        v_union_id,
        v_upazila_id,
        v_district_id
    FROM patient p
    JOIN administrative_union au
        ON au.union_id = p.union_id
    JOIN upazila up
        ON up.upazila_id = au.upazila_id
    WHERE p.patient_id = p_patient_id;

    IF v_union_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Patient or patient geography not found';
    END IF;

    /* Create referral request */
    INSERT INTO referral_request
    (
        patient_id,
        requested_union_id,
        specialty_id,
        origin_facility_id,
        destination_facility_id,
        reason,
        status
    )
    VALUES
    (
        p_patient_id,
        v_union_id,
        p_specialty_id,
        p_origin_facility_id,
        NULL,
        p_reason,
        'REQUESTED'
    );

    SET v_referral_id = LAST_INSERT_ID();

    /* Build ordered routing candidates */
    DROP TEMPORARY TABLE IF EXISTS tmp_referral_candidates;

    CREATE TEMPORARY TABLE tmp_referral_candidates AS
    SELECT
        r.facility_id,
        r.facility_name,
        r.facility_level,
        r.available_doctors,
        r.remaining_capacity,
        r.last_attendance_update,
        r.attendance_freshness,
        r.facility_referral_status,

        CASE
            WHEN r.facility_id = p_origin_facility_id
                THEN 0

            WHEN r.facility_level = 'UNION'
                 AND r.union_id = v_union_id
                THEN 1

            WHEN r.facility_level = 'UPAZILA'
                 AND r.upazila_id = v_upazila_id
                THEN 2

            WHEN r.facility_level = 'DISTRICT'
                 AND r.district_id = v_district_id
                THEN 3

            ELSE 99
        END AS routing_priority

    FROM v_referral_facility_status r

    WHERE r.specialty_id = p_specialty_id

      AND
      (
          r.facility_id = p_origin_facility_id

          OR
          (
              r.facility_level = 'UNION'
              AND r.union_id = v_union_id
          )

          OR
          (
              r.facility_level = 'UPAZILA'
              AND r.upazila_id = v_upazila_id
          )

          OR
          (
              r.facility_level = 'DISTRICT'
              AND r.district_id = v_district_id
          )
      );

    /* Record every facility checked */
    INSERT INTO referral_check
    (
        referral_id,
        facility_id,
        sequence_no,
        doctor_availability,
        capacity_status,
        attendance_freshness,
        reason,
        is_selected
    )
    SELECT
        v_referral_id,

        facility_id,

        ROW_NUMBER() OVER
        (
            ORDER BY routing_priority, facility_id
        ),

        CASE
            WHEN attendance_freshness = 'STALE'
                THEN 'STALE'

            WHEN attendance_freshness = 'NO_DATA'
                THEN 'NO_DATA'

            WHEN available_doctors > 0
                THEN 'AVAILABLE'

            ELSE 'UNAVAILABLE'
        END,

        CASE
            WHEN remaining_capacity IS NULL
                THEN 'NO_DATA'

            WHEN remaining_capacity = 0
                THEN 'FULL'

            ELSE 'AVAILABLE'
        END,

        CASE
            WHEN attendance_freshness = 'STALE'
                THEN 'STALE'

            WHEN attendance_freshness = 'NO_DATA'
                THEN 'NO_DATA'

            ELSE 'FRESH'
        END,

        CASE
            WHEN facility_referral_status = 'ELIGIBLE'
                THEN 'Eligible facility'

            WHEN facility_referral_status = 'NO_DOCTOR'
                THEN 'No currently available doctor'

            WHEN facility_referral_status = 'FULL'
                THEN 'Department capacity is full'

            WHEN facility_referral_status = 'STALE_DATA'
                THEN 'Attendance information is stale'

            ELSE 'Facility unavailable'
        END,

        FALSE

    FROM tmp_referral_candidates;

    /* Select first eligible destination, excluding origin */
    SET v_destination_id =
    (
        SELECT facility_id
        FROM tmp_referral_candidates
        WHERE facility_referral_status = 'ELIGIBLE'
          AND facility_id <> p_origin_facility_id
        ORDER BY routing_priority, facility_id
        LIMIT 1
    );

    /* Finalize referral */
    IF v_destination_id IS NOT NULL THEN

        UPDATE referral_request
        SET
            destination_facility_id = v_destination_id,
            status = 'ROUTED'
        WHERE referral_id = v_referral_id;

        UPDATE referral_check
        SET is_selected = TRUE
        WHERE referral_id = v_referral_id
          AND facility_id = v_destination_id;

    END IF;

    /* Return routing result */
    SELECT
        rr.referral_id,
        rr.patient_id,
        rr.requested_union_id,
        s.name AS specialty,
        rr.origin_facility_id,
        rr.destination_facility_id,
        hf.name AS destination_facility,
        rr.status,
        rr.reason,
        rr.requested_at
    FROM referral_request rr

    JOIN specialty s
        ON s.specialty_id = rr.specialty_id

    LEFT JOIN health_facility hf
        ON hf.facility_id = rr.destination_facility_id

    WHERE rr.referral_id = v_referral_id;

    DROP TEMPORARY TABLE IF EXISTS tmp_referral_candidates;

END;;
DROP PROCEDURE IF EXISTS `sp_start_queue_service`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_start_queue_service`(
    IN p_queue_id BIGINT UNSIGNED
)
BEGIN
    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT status
    INTO v_status
    FROM daily_queue
    WHERE queue_id = p_queue_id
    FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Queue entry not found';
    END IF;

    IF v_status <> 'CALLED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Only CALLED queue entries can enter service';
    END IF;

    UPDATE daily_queue
    SET status = 'IN_SERVICE'
    WHERE queue_id = p_queue_id;

    COMMIT;

    SELECT
        queue_id,
        patient_id,
        appointment_id,
        department_id,
        queue_number,
        status,
        called_at
    FROM daily_queue
    WHERE queue_id = p_queue_id;

END;;
DROP PROCEDURE IF EXISTS `sp_update_referral_status`;;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_referral_status`(
    IN p_referral_id BIGINT UNSIGNED,
    IN p_new_status VARCHAR(20)
)
BEGIN
    DECLARE v_current_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT status
    INTO v_current_status
    FROM referral_request
    WHERE referral_id = p_referral_id
    FOR UPDATE;

    IF v_current_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Referral not found';
    END IF;

    IF p_new_status NOT IN
       ('REQUESTED', 'ROUTED', 'ACCEPTED', 'COMPLETED', 'CANCELLED') THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid referral status';

    END IF;

    /* Allowed forward/cancellation transitions */
    IF p_new_status = 'ROUTED'
       AND v_current_status <> 'REQUESTED' THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Referral can be ROUTED only from REQUESTED status';

    ELSEIF p_new_status = 'ACCEPTED'
       AND v_current_status <> 'ROUTED' THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Referral can be ACCEPTED only from ROUTED status';

    ELSEIF p_new_status = 'COMPLETED'
       AND v_current_status <> 'ACCEPTED' THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Referral can be COMPLETED only from ACCEPTED status';

    ELSEIF p_new_status = 'CANCELLED'
       AND v_current_status IN ('COMPLETED', 'CANCELLED') THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Completed or already cancelled referrals cannot be cancelled';

    ELSEIF p_new_status = v_current_status THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Referral already has this status';

    END IF;

    UPDATE referral_request
    SET status = p_new_status
    WHERE referral_id = p_referral_id;

    COMMIT;

    SELECT
        referral_id,
        patient_id,
        origin_facility_id,
        destination_facility_id,
        status,
        reason,
        requested_at
    FROM referral_request
    WHERE referral_id = p_referral_id;

END;;
DELIMITER ;

-- MySQL dump 10.13  Distrib 9.0.1, for macos14.4 (arm64)
--
-- Host: localhost    Database: cyber_threat_intel2
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `affected_products`
--

DROP TABLE IF EXISTS `affected_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `affected_products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) NOT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `product_name` (`product_name`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affected_products`
--

LOCK TABLES `affected_products` WRITE;
/*!40000 ALTER TABLE `affected_products` DISABLE KEYS */;
INSERT INTO `affected_products` VALUES (1,'Windows 10','Microsoft','2024-09-19 18:32:05','2024-09-19 18:32:05'),(2,'Linux Kernel','Linux Foundation','2024-09-19 18:32:05','2024-09-19 18:32:05'),(3,'Apache HTTP Server','Apache Software Foundation','2024-09-19 18:32:05','2024-09-19 18:32:05'),(4,'Adobe Acrobat Reader','Adobe','2024-09-19 18:32:05','2024-09-19 18:32:05'),(5,'Cisco IOS','Cisco','2024-09-19 18:32:05','2024-09-19 18:32:05'),(6,'Oracle Database','Oracle','2024-09-19 18:32:05','2024-09-19 18:32:05'),(7,'AWS EC2','Amazon','2024-09-19 18:32:05','2024-09-19 18:32:05'),(8,'Google Chrome','Google','2024-09-19 18:32:05','2024-09-19 18:32:05'),(9,'VMware vSphere','VMware','2024-09-19 18:32:05','2024-09-19 18:32:05'),(10,'Docker Engine','Docker','2024-09-19 18:32:05','2024-09-19 18:32:05'),(31,'Ivanti Connect Secure','Ivanti','2024-09-26 09:35:17','2024-09-26 09:35:17'),(32,'VMware ESXi','VMware','2024-09-26 09:35:17','2024-09-26 09:35:17'),(33,'Microsoft Exchange','Microsoft','2024-09-26 09:35:17','2024-09-26 09:35:17'),(34,'Honor Magic OS','Honor','2024-09-26 09:35:17','2024-09-26 09:35:17'),(35,'Hitachi Energy RTU500','Hitachi Energy','2024-09-26 09:35:17','2024-09-26 09:35:17'),(36,'Fortinet FortiGate','Fortinet','2024-09-26 09:35:17','2024-09-26 09:35:17'),(37,'Cisco ASA','Cisco','2024-09-26 09:35:17','2024-09-26 09:35:17'),(38,'Palo Alto NextGen Firewall','Palo Alto Networks','2024-09-26 09:35:17','2024-09-26 09:35:17'),(39,'SonicWall Network Security','SonicWall','2024-09-26 09:35:17','2024-09-26 09:35:17');
/*!40000 ALTER TABLE `affected_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attack_vector_categories`
--

DROP TABLE IF EXISTS `attack_vector_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attack_vector_categories` (
  `vector_category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` tinytext,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vector_category_id`),
  UNIQUE KEY `category_name_UNIQUE` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attack_vector_categories`
--

LOCK TABLES `attack_vector_categories` WRITE;
/*!40000 ALTER TABLE `attack_vector_categories` DISABLE KEYS */;
INSERT INTO `attack_vector_categories` VALUES (1,'Web-based Attacks','Attacks targeting web applications and services','2024-09-26 09:29:06','2024-09-26 09:29:06'),(2,'Network Attacks','Attacks exploiting network vulnerabilities','2024-09-26 09:29:06','2024-09-26 09:29:06'),(3,'Email-based Attacks','Phishing and email compromise attacks','2024-09-26 09:29:06','2024-09-26 09:29:06'),(4,'Social Engineering','Attacks exploiting human vulnerabilities','2024-09-26 09:29:06','2024-09-26 09:29:06'),(5,'Supply Chain Attacks','Attacks targeting third-party suppliers','2024-09-26 09:29:06','2024-09-26 09:29:06'),(6,'IoT Exploits','Attacks on Internet of Things devices','2024-09-26 09:29:06','2024-09-26 09:29:06'),(7,'Zero-Day Exploits','Exploits targeting unpatched vulnerabilities','2024-09-26 09:29:06','2024-09-26 09:29:06'),(8,'Privilege Escalation','Gaining elevated access privileges','2024-09-26 09:29:06','2024-09-26 09:29:06'),(9,'Lateral Movement','Moving laterally through networks','2024-09-26 09:29:06','2024-09-26 09:29:06'),(10,'Ransomware','Encrypting data for ransom demands','2024-09-26 09:29:06','2024-09-26 09:29:06'),(32,'Network Intrusion','Unauthorized access to network systems','2024-11-06 10:34:50','2024-11-06 10:34:50'),(33,'Supply Chain Attack','Compromise through third-party vendors','2024-11-06 10:34:50','2024-11-06 10:34:50'),(34,'Software Exploitation','Exploitation of software vulnerabilities','2024-11-06 10:34:50','2024-11-06 10:34:50'),(35,'Phishing','Deceptive attempts to obtain sensitive information','2024-11-06 10:34:50','2024-11-06 10:34:50'),(36,'API Abuse','Exploitation of application programming interfaces','2024-11-06 10:34:50','2024-11-06 10:34:50'),(37,'Data Breach','Unauthorized access to confidential data','2024-11-06 10:34:50','2024-11-06 10:34:50');
/*!40000 ALTER TABLE `attack_vector_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attack_vectors`
--

DROP TABLE IF EXISTS `attack_vectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attack_vectors` (
  `vector_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `vector_category_id` int NOT NULL,
  `severity_level` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `category` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vector_id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `idx_vector_category_id` (`vector_category_id`),
  CONSTRAINT `fk_attack_vectors_category` FOREIGN KEY (`vector_category_id`) REFERENCES `attack_vector_categories` (`vector_category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attack_vectors`
--

LOCK TABLES `attack_vectors` WRITE;
/*!40000 ALTER TABLE `attack_vectors` DISABLE KEYS */;
INSERT INTO `attack_vectors` VALUES (1,'SQL Injection',NULL,1,5,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(2,'Cross-Site Scripting (XSS)',NULL,1,4,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(3,'Phishing',NULL,3,4,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(4,'Spear Phishing',NULL,3,5,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(5,'Man-in-the-Middle',NULL,2,4,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(6,'Password Cracking',NULL,8,5,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(7,'Denial of Service',NULL,2,5,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(8,'Buffer Overflow',NULL,7,5,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(9,'Ransomware',NULL,10,6,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(10,'Web Shell Injections',NULL,1,5,'2024-09-26 09:29:06','2024-09-26 09:29:06',NULL),(32,'Router Exploitation','Exploiting vulnerabilities in network routers',1,5,'2024-11-06 10:35:02','2024-11-06 10:35:02',NULL),(33,'Vendor Software Compromise','Infiltrating systems via compromised vendor software',2,4,'2024-11-06 10:35:02','2024-11-06 10:35:02',NULL),(34,'Browser Vulnerability Exploit','Exploiting vulnerabilities in web browsers',3,5,'2024-11-06 10:35:02','2024-11-06 10:35:02',NULL),(35,'Email Phishing','Deceptive emails to obtain sensitive information',4,3,'2024-11-06 10:35:02','2024-11-06 10:35:02',NULL),(36,'API Exploitation','Abusing APIs to gain unauthorized access',5,4,'2024-11-06 10:35:02','2024-11-06 10:35:02',NULL),(37,'Database Breach','Unauthorized access to database systems',6,5,'2024-11-06 10:35:02','2024-11-06 10:35:02',NULL);
/*!40000 ALTER TABLE `attack_vectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `country_code` char(2) NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`country_code`),
  UNIQUE KEY `country_name_UNIQUE` (`country_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES ('BR','Brazil','2024-09-26 09:29:06','2024-09-26 09:29:06'),('CA','Canada','2024-09-26 09:29:06','2024-09-26 09:29:06'),('CN','China','2024-09-26 09:29:06','2024-09-26 09:29:06'),('DE','Germany','2024-09-26 09:29:06','2024-09-26 09:29:06'),('FR','France','2024-09-26 09:29:06','2024-09-26 09:29:06'),('IN','India','2024-09-26 09:29:06','2024-09-26 09:29:06'),('JP','Japan','2024-09-26 09:29:06','2024-09-26 09:29:06'),('KR','South Korea','2024-09-26 09:29:06','2024-09-26 09:29:06'),('RU','Russia','2024-09-26 09:29:06','2024-09-26 09:29:06'),('US','United States','2024-09-26 09:29:06','2024-09-26 09:29:06');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geolocation_data`
--

DROP TABLE IF EXISTS `geolocation_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geolocation_data` (
  `geolocation_id` bigint NOT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `ip_address` varchar(255) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`geolocation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geolocation_data`
--

LOCK TABLES `geolocation_data` WRITE;
/*!40000 ALTER TABLE `geolocation_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `geolocation_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geolocations`
--

DROP TABLE IF EXISTS `geolocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geolocations` (
  `geolocation_id` bigint NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(16) NOT NULL,
  `country` char(2) NOT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`geolocation_id`),
  UNIQUE KEY `unique_ip` (`ip_address`),
  KEY `idx_country` (`country`),
  KEY `idx_region` (`region`),
  KEY `idx_city` (`city`),
  KEY `idx_country_city` (`country`,`city`),
  CONSTRAINT `fk_geolocations_country` FOREIGN KEY (`country`) REFERENCES `countries` (`country_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geolocations`
--

LOCK TABLES `geolocations` WRITE;
/*!40000 ALTER TABLE `geolocations` DISABLE KEYS */;
INSERT INTO `geolocations` VALUES (11,'','US','California','San Francisco',37.774900,-122.419400,'2024-09-26 09:35:17','2024-09-26 09:35:17');
/*!40000 ALTER TABLE `geolocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `global_threats`
--

DROP TABLE IF EXISTS `global_threats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `global_threats` (
  `threat_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `first_detected` date NOT NULL,
  `last_updated` date DEFAULT NULL,
  `severity_level` int NOT NULL DEFAULT '0',
  `data_retention_until` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`threat_id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `idx_severity_level` (`severity_level`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `global_threats`
--

LOCK TABLES `global_threats` WRITE;
/*!40000 ALTER TABLE `global_threats` DISABLE KEYS */;
INSERT INTO `global_threats` VALUES (1,'APT29','Advanced persistent threat from Russia','2021-01-15',NULL,5,'2026-01-15 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(2,'Emotet','Banking Trojan and malware loader','2020-11-01',NULL,4,'2025-11-01 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(3,'LockBit Ransomware','Ransomware group focusing on extortion','2022-05-01',NULL,5,'2027-05-01 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(4,'BlackCat Ransomware','Ransomware with double extortion tactics','2023-04-15',NULL,6,'2028-04-15 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(5,'Lazarus Group','State-sponsored group from North Korea','2021-09-20',NULL,5,'2026-09-20 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(6,'FIN7','Financially motivated cybercrime group','2021-08-10',NULL,4,'2026-08-10 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(7,'Daixin Team','Ransomware group targeting healthcare','2024-06-21',NULL,5,'2029-06-21 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(8,'APT INC','Rebranded SEXi ransomware group','2024-07-12',NULL,6,'2029-07-12 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(9,'Daggerfly','Espionage group targeting macOS','2023-10-05',NULL,4,'2028-10-05 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(10,'Play Ransomware','Linux ransomware variant targeting ESXi servers','2024-08-01',NULL,6,'2029-08-01 00:00:00','2024-09-26 09:29:06','2024-09-26 09:29:06'),(32,'Salt Typhoon','Advanced persistent threat group linked to Chinese government, targeting U.S. infrastructure','2024-09-25','2024-10-07',5,'2026-09-25 00:00:00','2024-11-06 10:35:05','2024-11-06 10:35:05'),(33,'Black Kite','Russian state-sponsored group conducting cyber espionage','2024-08-15','2024-10-01',4,'2026-08-15 00:00:00','2024-11-06 10:35:05','2024-11-06 10:35:05'),(34,'Pygmy Goat','Custom malware used to backdoor Sophos Firewall devices','2024-11-04','2024-11-04',4,'2026-11-04 00:00:00','2024-11-06 10:35:05','2024-11-06 10:35:05'),(35,'CRON#TRAP','Phishing campaign infecting Windows with backdoored Linux VMs','2024-11-04','2024-11-04',3,'2026-11-04 00:00:00','2024-11-06 10:35:05','2024-11-06 10:35:05');
/*!40000 ALTER TABLE `global_threats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incident_logs`
--

DROP TABLE IF EXISTS `incident_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_logs` (
  `incident_id` bigint NOT NULL AUTO_INCREMENT,
  `actor_id` int NOT NULL,
  `vector_id` int NOT NULL,
  `vulnerability_id` int DEFAULT NULL,
  `geolocation_id` bigint NOT NULL,
  `incident_date` datetime NOT NULL,
  `target` varchar(255) NOT NULL,
  `industry_id` int NOT NULL,
  `impact` varchar(255) DEFAULT NULL,
  `response` varchar(255) DEFAULT NULL,
  `response_date` datetime DEFAULT NULL,
  `data_retention_until` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `industry` varchar(255) DEFAULT NULL,
  `response_time_hours` int GENERATED ALWAYS AS (timestampdiff(HOUR,`incident_date`,`response_date`)) VIRTUAL,
  PRIMARY KEY (`incident_id`),
  KEY `idx_actor_id` (`actor_id`),
  KEY `idx_vector_id` (`vector_id`),
  KEY `idx_vulnerability_id` (`vulnerability_id`),
  KEY `idx_geolocation_id` (`geolocation_id`),
  KEY `idx_industry_id` (`industry_id`),
  KEY `idx_incident_date` (`incident_date`),
  KEY `idx_target` (`target`),
  KEY `idx_actor_incident_industry` (`actor_id`,`incident_date`,`industry_id`),
  KEY `idx_target_prefix` (`target`(20)),
  CONSTRAINT `fk_incident_logs_actor` FOREIGN KEY (`actor_id`) REFERENCES `threat_actors` (`actor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_incident_logs_geolocation` FOREIGN KEY (`geolocation_id`) REFERENCES `geolocations` (`geolocation_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_incident_logs_industry` FOREIGN KEY (`industry_id`) REFERENCES `industries` (`industry_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_incident_logs_vector` FOREIGN KEY (`vector_id`) REFERENCES `attack_vectors` (`vector_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_incident_logs_vulnerability` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`vulnerability_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FKan3r4ytjdq0f1x5qa9r7bfu6u` FOREIGN KEY (`geolocation_id`) REFERENCES `geolocation_data` (`geolocation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_logs`
--

LOCK TABLES `incident_logs` WRITE;
/*!40000 ALTER TABLE `incident_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_logs` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `incident_logs_after_insert` AFTER INSERT ON `incident_logs` FOR EACH ROW BEGIN
    INSERT INTO incident_logs_audit (
        action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id,
        incident_date, target, industry_id, impact, response, response_date,
        data_retention_until, action_timestamp, performed_by
    )
    VALUES (
        'INSERT', NEW.incident_id, NEW.actor_id, NEW.vector_id, NEW.vulnerability_id, NEW.geolocation_id,
        NEW.incident_date, NEW.target, NEW.industry_id, NEW.impact, NEW.response, NEW.response_date,
        NEW.data_retention_until, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `incident_logs_after_update` AFTER UPDATE ON `incident_logs` FOR EACH ROW BEGIN
    INSERT INTO incident_logs_audit (
        action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id,
        incident_date, target, industry_id, impact, response, response_date,
        data_retention_until, action_timestamp, performed_by
    )
    VALUES (
        'UPDATE', OLD.incident_id, OLD.actor_id, OLD.vector_id, OLD.vulnerability_id, OLD.geolocation_id,
        OLD.incident_date, OLD.target, OLD.industry_id, OLD.impact, OLD.response, OLD.response_date,
        OLD.data_retention_until, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `incident_logs_after_delete` AFTER DELETE ON `incident_logs` FOR EACH ROW BEGIN
    INSERT INTO incident_logs_audit (
        action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id,
        incident_date, target, industry_id, impact, response, response_date,
        data_retention_until, action_timestamp, performed_by
    )
    VALUES (
        'DELETE', OLD.incident_id, OLD.actor_id, OLD.vector_id, OLD.vulnerability_id, OLD.geolocation_id,
        OLD.incident_date, OLD.target, OLD.industry_id, OLD.impact, OLD.response, OLD.response_date,
        OLD.data_retention_until, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `incident_logs_audit`
--

DROP TABLE IF EXISTS `incident_logs_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_logs_audit` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `incident_id` bigint DEFAULT NULL,
  `actor_id` int DEFAULT NULL,
  `vector_id` int DEFAULT NULL,
  `vulnerability_id` int DEFAULT NULL,
  `geolocation_id` bigint DEFAULT NULL,
  `incident_date` datetime DEFAULT NULL,
  `target` varchar(255) DEFAULT NULL,
  `industry_id` int DEFAULT NULL,
  `impact` varchar(255) DEFAULT NULL,
  `response` varchar(255) DEFAULT NULL,
  `response_date` datetime DEFAULT NULL,
  `data_retention_until` datetime DEFAULT NULL,
  `action_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `performed_by` varchar(100) DEFAULT 'system',
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_logs_audit`
--

LOCK TABLES `incident_logs_audit` WRITE;
/*!40000 ALTER TABLE `incident_logs_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_logs_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `incident_response_times_by_industry`
--

DROP TABLE IF EXISTS `incident_response_times_by_industry`;
/*!50001 DROP VIEW IF EXISTS `incident_response_times_by_industry`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `incident_response_times_by_industry` AS SELECT 
 1 AS `industry_name`,
 1 AS `avg_response_time_hours`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `industries`
--

DROP TABLE IF EXISTS `industries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `industries` (
  `industry_id` int NOT NULL AUTO_INCREMENT,
  `industry_name` varchar(100) NOT NULL,
  `description` tinytext,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`industry_id`),
  UNIQUE KEY `industry_name_UNIQUE` (`industry_name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `industries`
--

LOCK TABLES `industries` WRITE;
/*!40000 ALTER TABLE `industries` DISABLE KEYS */;
INSERT INTO `industries` VALUES (1,'Finance','Financial Sector','2024-09-27 16:14:03','2024-09-27 16:14:03'),(2,'Healthcare','Healthcare Sector','2024-09-27 16:14:03','2024-09-27 16:14:03'),(3,'Technology','Technology Sector','2024-09-27 16:14:03','2024-09-27 16:14:03'),(4,'Retail','Retail Sector','2024-09-27 16:14:03','2024-09-27 16:14:03'),(5,'Education','Education Sector','2024-09-27 16:14:03','2024-09-27 16:14:03');
/*!40000 ALTER TABLE `industries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `machine_learning_features`
--

DROP TABLE IF EXISTS `machine_learning_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `machine_learning_features` (
  `feature_id` bigint NOT NULL AUTO_INCREMENT,
  `incident_id` bigint NOT NULL,
  `feature_vector` json DEFAULT NULL,
  `feature_name` varchar(255) NOT NULL,
  `feature_value` double NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feature_id`),
  KEY `idx_incident_id` (`incident_id`),
  CONSTRAINT `fk_ml_features_incident` FOREIGN KEY (`incident_id`) REFERENCES `incident_logs` (`incident_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `machine_learning_features`
--

LOCK TABLES `machine_learning_features` WRITE;
/*!40000 ALTER TABLE `machine_learning_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `machine_learning_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `most_exploited_vulnerabilities`
--

DROP TABLE IF EXISTS `most_exploited_vulnerabilities`;
/*!50001 DROP VIEW IF EXISTS `most_exploited_vulnerabilities`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `most_exploited_vulnerabilities` AS SELECT 
 1 AS `cve_id`,
 1 AS `description`,
 1 AS `exploitation_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `most_exploited_vulnerabilities_mat`
--

DROP TABLE IF EXISTS `most_exploited_vulnerabilities_mat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `most_exploited_vulnerabilities_mat` (
  `cve_id` varchar(20) NOT NULL,
  `description` tinytext NOT NULL,
  `exploitation_count` bigint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `most_exploited_vulnerabilities_mat`
--

LOCK TABLES `most_exploited_vulnerabilities_mat` WRITE;
/*!40000 ALTER TABLE `most_exploited_vulnerabilities_mat` DISABLE KEYS */;
/*!40000 ALTER TABLE `most_exploited_vulnerabilities_mat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `privileges`
--

DROP TABLE IF EXISTS `privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `privileges` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
INSERT INTO `privileges` VALUES (3,'ADMIN_PRIVILEGE'),(1,'READ_PRIVILEGE'),(2,'WRITE_PRIVILEGE');
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (2,'ROLE_ADMIN'),(1,'ROLE_USER');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_privileges`
--

DROP TABLE IF EXISTS `roles_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_privileges` (
  `role_id` bigint NOT NULL,
  `privilege_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`,`privilege_id`),
  KEY `privilege_id` (`privilege_id`),
  CONSTRAINT `roles_privileges_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `roles_privileges_ibfk_2` FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_privileges`
--

LOCK TABLES `roles_privileges` WRITE;
/*!40000 ALTER TABLE `roles_privileges` DISABLE KEYS */;
INSERT INTO `roles_privileges` VALUES (1,1),(2,1),(2,2),(2,3);
/*!40000 ALTER TABLE `roles_privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistical_reports`
--

DROP TABLE IF EXISTS `statistical_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistical_reports` (
  `report_id` bigint NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `generated_date` date NOT NULL,
  `report_type` varchar(255) NOT NULL,
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistical_reports`
--

LOCK TABLES `statistical_reports` WRITE;
/*!40000 ALTER TABLE `statistical_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistical_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_actor_attack_vector`
--

DROP TABLE IF EXISTS `threat_actor_attack_vector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threat_actor_attack_vector` (
  `threat_actor_id` int NOT NULL,
  `attack_vector_id` int NOT NULL,
  PRIMARY KEY (`threat_actor_id`,`attack_vector_id`),
  KEY `FKf5x6vp5yv5jfo2ce15eo6kjfy` (`attack_vector_id`),
  CONSTRAINT `FK2hqe73ok61q3ul2icjdt0x9gr` FOREIGN KEY (`threat_actor_id`) REFERENCES `threat_actors` (`actor_id`),
  CONSTRAINT `FKf5x6vp5yv5jfo2ce15eo6kjfy` FOREIGN KEY (`attack_vector_id`) REFERENCES `attack_vectors` (`vector_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_actor_attack_vector`
--

LOCK TABLES `threat_actor_attack_vector` WRITE;
/*!40000 ALTER TABLE `threat_actor_attack_vector` DISABLE KEYS */;
/*!40000 ALTER TABLE `threat_actor_attack_vector` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_actor_types`
--

DROP TABLE IF EXISTS `threat_actor_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threat_actor_types` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(100) NOT NULL,
  `description` tinytext,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `type_name_UNIQUE` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_actor_types`
--

LOCK TABLES `threat_actor_types` WRITE;
/*!40000 ALTER TABLE `threat_actor_types` DISABLE KEYS */;
INSERT INTO `threat_actor_types` VALUES (1,'Cybercrime Group','Groups focused on financially motivated cyberattacks','2024-09-26 09:29:06','2024-09-26 09:29:06'),(2,'State-Sponsored','Nation-state actors conducting cyber espionage and sabotage','2024-09-26 09:29:06','2024-09-26 09:29:06'),(3,'Hacktivists','Activists using hacking to promote political or social agendas','2024-09-26 09:29:06','2024-09-26 09:29:06'),(4,'Insider Threats','Individuals within an organization who intentionally harm it','2024-09-26 09:29:06','2024-09-26 09:29:06'),(5,'Ransomware-as-a-Service','Groups providing ransomware tools for hire','2024-09-26 09:29:06','2024-09-26 09:29:06'),(6,'Terrorist Organizations','Groups using cyberattacks for terror purposes','2024-09-26 09:29:06','2024-09-26 09:29:06'),(7,'Script Kiddies','Unskilled individuals using pre-built tools for attacks','2024-09-26 09:29:06','2024-09-26 09:29:06'),(8,'Organized Crime Syndicates','Criminal organizations engaged in cyber extortion','2024-09-26 09:29:06','2024-09-26 09:29:06'),(9,'Industrial Espionage','Actors focused on stealing trade secrets and intellectual property','2024-09-26 09:29:06','2024-09-26 09:29:06'),(10,'Independent Hackers','Skilled individuals working independently or for hire','2024-09-26 09:29:06','2024-09-26 09:29:06');
/*!40000 ALTER TABLE `threat_actor_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_actors`
--

DROP TABLE IF EXISTS `threat_actors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threat_actors` (
  `actor_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type_id` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `origin_country` char(2) NOT NULL,
  `first_observed` date NOT NULL,
  `last_activity` date DEFAULT NULL,
  `category_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`actor_id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `idx_origin_country` (`origin_country`),
  KEY `idx_type_id` (`type_id`),
  KEY `idx_category_id` (`category_id`),
  CONSTRAINT `fk_threat_actors_category` FOREIGN KEY (`category_id`) REFERENCES `threat_categories` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_threat_actors_country` FOREIGN KEY (`origin_country`) REFERENCES `countries` (`country_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_threat_actors_type` FOREIGN KEY (`type_id`) REFERENCES `threat_actor_types` (`type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_actors`
--

LOCK TABLES `threat_actors` WRITE;
/*!40000 ALTER TABLE `threat_actors` DISABLE KEYS */;
INSERT INTO `threat_actors` VALUES (1,'Fancy Bear',2,NULL,'RU','2020-12-01',NULL,5,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(2,'Lazarus Group',2,NULL,'CN','2021-02-10',NULL,5,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(3,'Daixin Team',1,NULL,'CN','2024-06-21',NULL,2,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(4,'APT INC',1,NULL,'US','2024-07-12',NULL,2,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(5,'FIN7',1,NULL,'RU','2021-08-10',NULL,1,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(6,'Daggerfly',2,NULL,'CN','2023-10-05',NULL,6,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(7,'Emotet',1,NULL,'US','2020-11-01',NULL,1,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(8,'APT29',2,NULL,'RU','2021-01-15',NULL,5,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(9,'Play Ransomware',1,NULL,'US','2024-08-01',NULL,2,'2024-09-26 09:35:17','2024-09-26 09:35:17',''),(10,'BlackCat',1,NULL,'CN','2023-04-15',NULL,2,'2024-09-26 09:35:17','2024-09-26 09:35:17','');
/*!40000 ALTER TABLE `threat_actors` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `threat_actors_after_insert` AFTER INSERT ON `threat_actors` FOR EACH ROW BEGIN
    INSERT INTO threat_actors_audit (
        action_type, actor_id, name, type_id, description, origin_country,
        first_observed, last_activity, category_id, action_timestamp, performed_by
    )
    VALUES (
        'INSERT', NEW.actor_id, NEW.name, NEW.type_id, NEW.description, NEW.origin_country,
        NEW.first_observed, NEW.last_activity, NEW.category_id, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `threat_actors_after_update` AFTER UPDATE ON `threat_actors` FOR EACH ROW BEGIN
    INSERT INTO threat_actors_audit (
        action_type, actor_id, name, type_id, description, origin_country,
        first_observed, last_activity, category_id, action_timestamp, performed_by
    )
    VALUES (
        'UPDATE', OLD.actor_id, OLD.name, OLD.type_id, OLD.description, OLD.origin_country,
        OLD.first_observed, OLD.last_activity, OLD.category_id, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `threat_actors_after_delete` AFTER DELETE ON `threat_actors` FOR EACH ROW BEGIN
    INSERT INTO threat_actors_audit (
        action_type, actor_id, name, type_id, description, origin_country,
        first_observed, last_activity, category_id, action_timestamp, performed_by
    )
    VALUES (
        'DELETE', OLD.actor_id, OLD.name, OLD.type_id, OLD.description, OLD.origin_country,
        OLD.first_observed, OLD.last_activity, OLD.category_id, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `threat_actors_audit`
--

DROP TABLE IF EXISTS `threat_actors_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threat_actors_audit` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `actor_id` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type_id` int DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `origin_country` char(2) DEFAULT NULL,
  `first_observed` date DEFAULT NULL,
  `last_activity` date DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `action_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `performed_by` varchar(100) DEFAULT 'system',
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_actors_audit`
--

LOCK TABLES `threat_actors_audit` WRITE;
/*!40000 ALTER TABLE `threat_actors_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `threat_actors_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_categories`
--

DROP TABLE IF EXISTS `threat_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threat_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name_UNIQUE` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_categories`
--

LOCK TABLES `threat_categories` WRITE;
/*!40000 ALTER TABLE `threat_categories` DISABLE KEYS */;
INSERT INTO `threat_categories` VALUES (1,'Malware','Software designed to disrupt or damage a system','2024-09-26 09:29:06','2024-09-26 09:29:06'),(2,'Ransomware','Software that encrypts data and demands ransom','2024-09-26 09:29:06','2024-09-26 09:29:06'),(3,'Phishing','Social engineering attacks that steal credentials or data','2024-09-26 09:29:06','2024-09-26 09:29:06'),(4,'Denial of Service','Attacks that overwhelm a system with traffic','2024-09-26 09:29:06','2024-09-26 09:29:06'),(5,'Advanced Persistent Threats','Stealthy attacks carried out over long periods','2024-09-26 09:29:06','2024-09-26 09:29:06'),(6,'Zero-Day Exploits','Attacks using previously unknown vulnerabilities','2024-09-26 09:29:06','2024-09-26 09:29:06'),(7,'Supply Chain Attacks','Attacks targeting third-party suppliers','2024-09-26 09:29:06','2024-09-26 09:29:06'),(8,'IoT Exploits','Attacks targeting Internet of Things devices','2024-09-26 09:29:06','2024-09-26 09:29:06'),(9,'Privilege Escalation','Gaining unauthorized elevated access','2024-09-26 09:29:06','2024-09-26 09:29:06'),(10,'Insider Threats','Attacks from within an organization','2024-09-26 09:29:06','2024-09-26 09:29:06'),(32,'Cyber Espionage','Unauthorized access to confidential information','2024-11-06 10:35:05','2024-11-06 10:35:05'),(33,'Financial Theft','Illicit acquisition of financial assets','2024-11-06 10:35:05','2024-11-06 10:35:05'),(34,'Disruption','Activities aimed at disrupting normal operations','2024-11-06 10:35:05','2024-11-06 10:35:05'),(35,'Data Theft','Unauthorized extraction of sensitive data','2024-11-06 10:35:05','2024-11-06 10:35:05');
/*!40000 ALTER TABLE `threat_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threat_predictions`
--

DROP TABLE IF EXISTS `threat_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threat_predictions` (
  `prediction_id` bigint NOT NULL AUTO_INCREMENT,
  `prediction_date` date NOT NULL,
  `threat_id` int NOT NULL,
  `probability` double NOT NULL,
  `predicted_impact` varchar(255) DEFAULT NULL,
  `data_retention_until` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`prediction_id`),
  KEY `idx_prediction_date` (`prediction_date`),
  KEY `idx_threat_id` (`threat_id`),
  KEY `idx_threat_prediction_date` (`threat_id`,`prediction_date`),
  CONSTRAINT `fk_threat_predictions_threat` FOREIGN KEY (`threat_id`) REFERENCES `global_threats` (`threat_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threat_predictions`
--

LOCK TABLES `threat_predictions` WRITE;
/*!40000 ALTER TABLE `threat_predictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `threat_predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_series_analytics`
--

DROP TABLE IF EXISTS `time_series_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_series_analytics` (
  `time_series_id` bigint NOT NULL,
  `analysis_date` date NOT NULL,
  `metric` varchar(255) NOT NULL,
  `value` double NOT NULL,
  `incident_id` bigint NOT NULL,
  PRIMARY KEY (`time_series_id`),
  KEY `FK3ccjv365hi2e3tvm93a374k3o` (`incident_id`),
  CONSTRAINT `FK3ccjv365hi2e3tvm93a374k3o` FOREIGN KEY (`incident_id`) REFERENCES `incident_logs` (`incident_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_series_analytics`
--

LOCK TABLES `time_series_analytics` WRITE;
/*!40000 ALTER TABLE `time_series_analytics` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_series_analytics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `top_threats_by_region`
--

DROP TABLE IF EXISTS `top_threats_by_region`;
/*!50001 DROP VIEW IF EXISTS `top_threats_by_region`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `top_threats_by_region` AS SELECT 
 1 AS `country_name`,
 1 AS `incident_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint NOT NULL,
  `role` varchar(255) DEFAULT NULL,
  `role_id` bigint NOT NULL,
  `id` bigint NOT NULL,
  KEY `FKhfh9dx7w3ubf1co1vdev94g3f` (`user_id`),
  CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,'ROLE_USER',0,0),(2,'ROLE_USER',0,0);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `consent_to_data_usage` bit(1) NOT NULL,
  `email` varchar(255) NOT NULL,
  `enabled` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'$2a$10$0BJRrdZslT9Gm815eGuOSulY1lxnT5unZ9pTFT6BapNN1hU38sJ2O','user',_binary '\0','',_binary '\0'),(2,'$2a$10$56b8JRH.qjYJcD78ivlRz.TiCYOr6Alu6rPVZFXVlWJ55amFBd4sK','Simon',_binary '\0','',_binary '\0'),(4,'$2a$10$b5t5/caBDuTNyKeqive2reDg0sJGW94v7IHOZmaN7BaPnTVPQD/i6','admin_user',_binary '','simonorskov@gmail.com',_binary ''),(5,'$2a$10$xYZU.KZU6MIPAIPt04oqEebYAiXbDIGCmzSAeUTDTOf1SdAXgIsRy','testuser',_binary '','testuser@example.com',_binary '\0');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vulnerabilities`
--

DROP TABLE IF EXISTS `vulnerabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vulnerabilities` (
  `vulnerability_id` int NOT NULL AUTO_INCREMENT,
  `cve_id` varchar(20) NOT NULL,
  `description` tinytext NOT NULL,
  `published_date` date NOT NULL,
  `severity_score` decimal(4,1) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vulnerability_id`),
  UNIQUE KEY `cve_id` (`cve_id`),
  KEY `idx_cve_id` (`cve_id`),
  KEY `idx_severity_score` (`severity_score`),
  KEY `idx_published_date` (`published_date`),
  CONSTRAINT `vulnerabilities_chk_1` CHECK ((`severity_score` between 0.0 and 10.0))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vulnerabilities`
--

LOCK TABLES `vulnerabilities` WRITE;
/*!40000 ALTER TABLE `vulnerabilities` DISABLE KEYS */;
INSERT INTO `vulnerabilities` VALUES (1,'CVE-2023-12345','Buffer overflow in XYZ component allowing remote code execution','2023-05-10',9.8,'2024-09-19 18:40:13','2024-09-19 18:40:13'),(2,'CVE-2024-54321','SQL injection vulnerability in ABC application','2024-02-20',8.6,'2024-09-19 18:40:13','2024-09-19 18:40:13'),(3,'CVE-2023-67890','Cross-site scripting in DEF web service','2023-07-15',7.5,'2024-09-19 18:40:13','2024-09-19 18:40:13'),(4,'CVE-2024-09876','Privilege escalation in GHI operating system','2024-03-05',9.0,'2024-09-19 18:40:13','2024-09-19 18:40:13'),(5,'CVE-2023-11223','Denial of service in JKL network protocol','2023-08-22',6.4,'2024-09-19 18:40:13','2024-09-19 18:40:13'),(7,'CVE-2024-21888','Privilege escalation in Ivanti Connect Secure','2024-01-05',9.1,'2024-09-26 09:29:06','2024-09-26 09:29:06'),(8,'CVE-2023-51434','Buffer overflow in Honor Magic UI','2023-12-29',7.8,'2024-09-26 09:29:06','2024-09-26 09:29:06'),(9,'CVE-2024-0456','Remote code execution in VMware ESXi','2024-02-11',9.0,'2024-09-26 09:29:06','2024-09-26 09:29:06'),(17,'CVE-2024-12345','Vulnerability in Cisco router firmware allowing remote code execution','2024-09-20',7.5,'2024-11-06 10:35:05','2024-11-06 10:35:05'),(18,'CVE-2024-47575','Critical FortiManager API vulnerability exploited in zero-day attacks','2024-10-23',9.8,'2024-11-06 10:35:05','2024-11-06 10:35:05'),(19,'CVE-2024-4947','Type confusion in V8 in Google Chrome allowing remote code execution','2024-05-20',8.8,'2024-11-06 10:35:05','2024-11-06 10:35:05'),(20,'CVE-2024-43573','Spoofing vulnerability in Windows MSHTML Platform exploited in the wild','2024-10-10',6.5,'2024-11-06 10:35:05','2024-11-06 10:35:05'),(21,'CVE-2024-56789','Buffer overflow in Sophos Firewall leading to remote code execution','2024-11-04',8.5,'2024-11-06 10:35:05','2024-11-06 10:35:05');
/*!40000 ALTER TABLE `vulnerabilities` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `vulnerabilities_after_insert` AFTER INSERT ON `vulnerabilities` FOR EACH ROW BEGIN
    INSERT INTO vulnerabilities_audit (
        action_type, vulnerability_id, cve_id, description, published_date,
        severity_score, action_timestamp, performed_by
    )
    VALUES (
        'INSERT', NEW.vulnerability_id, NEW.cve_id, NEW.description, NEW.published_date,
        NEW.severity_score, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `vulnerabilities_after_update` AFTER UPDATE ON `vulnerabilities` FOR EACH ROW BEGIN
    INSERT INTO vulnerabilities_audit (
        action_type, vulnerability_id, cve_id, description, published_date,
        severity_score, action_timestamp, performed_by
    )
    VALUES (
        'UPDATE', OLD.vulnerability_id, OLD.cve_id, OLD.description, OLD.published_date,
        OLD.severity_score, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `vulnerabilities_after_delete` AFTER DELETE ON `vulnerabilities` FOR EACH ROW BEGIN
    INSERT INTO vulnerabilities_audit (
        action_type, vulnerability_id, cve_id, description, published_date,
        severity_score, action_timestamp, performed_by
    )
    VALUES (
        'DELETE', OLD.vulnerability_id, OLD.cve_id, OLD.description, OLD.published_date,
        OLD.severity_score, NOW(), 'system'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `vulnerabilities_audit`
--

DROP TABLE IF EXISTS `vulnerabilities_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vulnerabilities_audit` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `vulnerability_id` int DEFAULT NULL,
  `cve_id` varchar(20) DEFAULT NULL,
  `description` tinytext,
  `published_date` date DEFAULT NULL,
  `severity_score` decimal(4,1) DEFAULT NULL,
  `action_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `performed_by` varchar(100) DEFAULT 'system',
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vulnerabilities_audit`
--

LOCK TABLES `vulnerabilities_audit` WRITE;
/*!40000 ALTER TABLE `vulnerabilities_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `vulnerabilities_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vulnerability_product_association`
--

DROP TABLE IF EXISTS `vulnerability_product_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vulnerability_product_association` (
  `vulnerability_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`vulnerability_id`,`product_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `vulnerability_product_association_ibfk_1` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`vulnerability_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vulnerability_product_association_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `affected_products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vulnerability_product_association`
--

LOCK TABLES `vulnerability_product_association` WRITE;
/*!40000 ALTER TABLE `vulnerability_product_association` DISABLE KEYS */;
INSERT INTO `vulnerability_product_association` VALUES (1,1),(4,1),(5,5),(2,6),(3,8),(7,31),(9,32);
/*!40000 ALTER TABLE `vulnerability_product_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `incident_response_times_by_industry`
--

/*!50001 DROP VIEW IF EXISTS `incident_response_times_by_industry`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `incident_response_times_by_industry` AS select `ind`.`industry_name` AS `industry_name`,avg(`il`.`response_time_hours`) AS `avg_response_time_hours` from (`incident_logs` `il` join `industries` `ind` on((`il`.`industry_id` = `ind`.`industry_id`))) where (`il`.`response_date` is not null) group by `ind`.`industry_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `most_exploited_vulnerabilities`
--

/*!50001 DROP VIEW IF EXISTS `most_exploited_vulnerabilities`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `most_exploited_vulnerabilities` AS select `v`.`cve_id` AS `cve_id`,`v`.`description` AS `description`,count(`il`.`incident_id`) AS `exploitation_count` from (`incident_logs` `il` join `vulnerabilities` `v` on((`il`.`vulnerability_id` = `v`.`vulnerability_id`))) group by `v`.`cve_id`,`v`.`description` order by `exploitation_count` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `top_threats_by_region`
--

/*!50001 DROP VIEW IF EXISTS `top_threats_by_region`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `top_threats_by_region` AS select `c`.`country_name` AS `country_name`,count(`il`.`incident_id`) AS `incident_count` from ((`incident_logs` `il` join `geolocations` `g` on((`il`.`geolocation_id` = `g`.`geolocation_id`))) join `countries` `c` on((`g`.`country` = `c`.`country_code`))) group by `c`.`country_name` order by `incident_count` desc */;
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

-- Dump completed on 2024-11-08 16:47:16

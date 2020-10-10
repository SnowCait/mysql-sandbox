-- MySQL dump 10.13  Distrib 5.7.31, for Linux (x86_64)
--
-- Host: localhost    Database: sandbox
-- ------------------------------------------------------
-- Server version	5.7.31-0ubuntu0.18.04.1

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
-- Table structure for table `friendships`
--

DROP TABLE IF EXISTS `friendships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friendships` (
  `following` bigint(20) unsigned NOT NULL,
  `followed` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`following`,`followed`),
  KEY `following` (`following`,`created_at`),
  KEY `followed` (`followed`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friendships`
--

LOCK TABLES `friendships` WRITE;
/*!40000 ALTER TABLE `friendships` DISABLE KEYS */;
INSERT INTO `friendships` VALUES (1,2,'2020-10-10 08:21:48'),(1,3,'2020-10-10 08:21:48'),(2,1,'2020-10-10 08:21:48');
/*!40000 ALTER TABLE `friendships` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `logging_friendships_inserted`
  AFTER INSERT ON `friendships`
  FOR EACH ROW
  BEGIN
    INSERT INTO `log_friendships` (`following`, `followed`, `action`)
      VALUES (NEW.`following`, NEW.`followed`, 1);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `logging_friendships_deleted`
  AFTER DELETE ON `friendships`
  FOR EACH ROW
  BEGIN
    INSERT INTO `log_friendships` (`following`, `followed`, `action`)
      VALUES (OLD.`following`, OLD.`followed`, 2);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `line_accounts`
--

DROP TABLE IF EXISTS `line_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `line_accounts` (
  `id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `line_accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `line_accounts`
--

LOCK TABLES `line_accounts` WRITE;
/*!40000 ALTER TABLE `line_accounts` DISABLE KEYS */;
INSERT INTO `line_accounts` VALUES (456,2,'2020-10-10 08:21:48','2020-10-10 08:21:48');
/*!40000 ALTER TABLE `line_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_friendships`
--

DROP TABLE IF EXISTS `log_friendships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_friendships` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `following` bigint(20) unsigned NOT NULL,
  `followed` bigint(20) unsigned NOT NULL,
  `action` tinyint(3) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`created_at`),
  KEY `followed` (`followed`,`following`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8
/*!50500 PARTITION BY RANGE  COLUMNS(created_at)
(PARTITION p202001 VALUES LESS THAN ('2019-02-01') ENGINE = InnoDB,
 PARTITION p202002 VALUES LESS THAN ('2019-03-01') ENGINE = InnoDB,
 PARTITION p202003 VALUES LESS THAN ('2020-04-01') ENGINE = InnoDB,
 PARTITION pmax VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_friendships`
--

LOCK TABLES `log_friendships` WRITE;
/*!40000 ALTER TABLE `log_friendships` DISABLE KEYS */;
INSERT INTO `log_friendships` VALUES (1,1,2,1,'2020-10-10 08:21:48'),(2,2,1,1,'2020-10-10 08:21:48'),(3,1,3,1,'2020-10-10 08:21:48');
/*!40000 ALTER TABLE `log_friendships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_player_names`
--

DROP TABLE IF EXISTS `log_player_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_player_names` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `name` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`created_at`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8
/*!50500 PARTITION BY RANGE  COLUMNS(created_at)
(PARTITION p2020 VALUES LESS THAN ('2021-01-01') ENGINE = InnoDB,
 PARTITION p2021 VALUES LESS THAN ('2022-01-01') ENGINE = InnoDB,
 PARTITION p2022 VALUES LESS THAN ('2023-01-01') ENGINE = InnoDB,
 PARTITION p2023 VALUES LESS THAN ('2024-01-01') COMMENT = '2020-05' ENGINE = InnoDB,
 PARTITION p2024 VALUES LESS THAN ('2025-01-01') COMMENT = '2020-06' ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_player_names`
--

LOCK TABLES `log_player_names` WRITE;
/*!40000 ALTER TABLE `log_player_names` DISABLE KEYS */;
INSERT INTO `log_player_names` VALUES (1,1,'user1_from_twitter','2020-10-10 08:21:48'),(2,2,'user2_by_line','2020-10-10 08:21:48'),(3,2,'user2_from_line','2020-10-10 08:21:48'),(4,3,'user3_from_twitter','2020-10-10 08:21:48');
/*!40000 ALTER TABLE `log_player_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tweets`
--

DROP TABLE IF EXISTS `tweets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tweets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `body` json NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tweets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tweets`
--

LOCK TABLES `tweets` WRITE;
/*!40000 ALTER TABLE `tweets` DISABLE KEYS */;
INSERT INTO `tweets` VALUES (1,1,'{\"text\": \"user1-tweet1\"}','2020-10-10 08:21:48'),(2,1,'{\"text\": \"user1-tweet2\"}','2020-10-10 08:21:48'),(3,1,'{\"text\": \"user1-tweet3\"}','2020-10-10 08:21:48'),(4,2,'{\"text\": \"user2-tweet1\"}','2020-10-10 08:21:48'),(5,2,'{\"text\": \"user2-tweet2\"}','2020-10-10 08:21:48'),(6,2,'{\"text\": \"user2-tweet3\"}','2020-10-10 08:21:48'),(7,3,'{\"text\": \"user3-tweet1\"}','2020-10-10 08:21:48'),(8,3,'{\"text\": \"user3-tweet2\"}','2020-10-10 08:21:48'),(9,3,'{\"text\": \"user3-tweet3\"}','2020-10-10 08:21:48');
/*!40000 ALTER TABLE `tweets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `twitter_accounts`
--

DROP TABLE IF EXISTS `twitter_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `twitter_accounts` (
  `id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `twitter_accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twitter_accounts`
--

LOCK TABLES `twitter_accounts` WRITE;
/*!40000 ALTER TABLE `twitter_accounts` DISABLE KEYS */;
INSERT INTO `twitter_accounts` VALUES (123,1,'2020-10-10 08:21:48','2020-10-10 08:21:48'),(789,3,'2020-10-10 08:21:48','2020-10-10 08:21:48');
/*!40000 ALTER TABLE `twitter_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user1_from_twitter','2020-10-10 08:21:48','2020-10-10 08:21:48'),(2,'user2_from_line','2020-10-10 08:21:48','2020-10-10 08:21:48'),(3,'user3_from_twitter','2020-10-10 08:21:48','2020-10-10 08:21:48');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-10  8:21:49

-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: bookstore
-- ------------------------------------------------------
-- Server version	5.5.62

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
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `AuthorName` varchar(45) NOT NULL,
  `Country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AuthorName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES ('Agatha Christie',NULL),('Hans Christian Andersen',NULL);
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `basket`
--

DROP TABLE IF EXISTS `basket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `basket` (
  `UserName` varchar(45) NOT NULL,
  `BookName` varchar(45) NOT NULL,
  `CreateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`UserName`,`BookName`,`CreateTime`),
  KEY `Basket_fk_1_idx` (`UserName`),
  KEY `Basket_fk_2_idx` (`BookName`),
  CONSTRAINT `Basket_fk_1` FOREIGN KEY (`UserName`) REFERENCES `user` (`UserName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Basket_fk_2` FOREIGN KEY (`BookName`) REFERENCES `book` (`BookName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basket`
--

LOCK TABLES `basket` WRITE;
/*!40000 ALTER TABLE `basket` DISABLE KEYS */;
/*!40000 ALTER TABLE `basket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `BookName` varchar(45) NOT NULL,
  `ISBN` varchar(45) DEFAULT NULL,
  `PublisherName` varchar(45) DEFAULT NULL,
  `NumberOfPage` int(11) DEFAULT NULL,
  `Price` float DEFAULT NULL,
  `TransferPercentage` float DEFAULT NULL,
  `Stock` int(11) DEFAULT '20',
  `Placed` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`BookName`),
  KEY `Book_fk_1_idx` (`PublisherName`),
  CONSTRAINT `Book_fk_1` FOREIGN KEY (`PublisherName`) REFERENCES `publisher` (`PublisherName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('Faltal Book','123','Pearson',200,50,0.6,9,1),('Murder on the Orient Express','abc-123-000','Pearson',305,30,0.5,19,0),('The Emperors New Clothes','abc-123-001','Penguin Random House',120,8,0.3,20,0),('The Ugly Duckling','abc-123-002','Penguin Random House',110,9,0.3,20,0);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booktype`
--

DROP TABLE IF EXISTS `booktype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booktype` (
  `BookName` varchar(45) NOT NULL,
  `GenreNumber` varchar(45) NOT NULL,
  PRIMARY KEY (`BookName`,`GenreNumber`),
  KEY `BookType_fk_1_idx` (`BookName`),
  KEY `BookType_fk_2_idx` (`GenreNumber`),
  CONSTRAINT `BookType_fk_1` FOREIGN KEY (`BookName`) REFERENCES `book` (`BookName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BookType_fk_2` FOREIGN KEY (`GenreNumber`) REFERENCES `genre` (`GenreNumber`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booktype`
--

LOCK TABLES `booktype` WRITE;
/*!40000 ALTER TABLE `booktype` DISABLE KEYS */;
INSERT INTO `booktype` VALUES ('Faltal Book','g1'),('Faltal Book','g2'),('Murder on the Orient Express','g1'),('The Emperors New Clothes','g2'),('The Ugly Duckling','g1'),('The Ugly Duckling','g2');
/*!40000 ALTER TABLE `booktype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookwrite`
--

DROP TABLE IF EXISTS `bookwrite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookwrite` (
  `BookName` varchar(45) NOT NULL,
  `AuthorName` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`BookName`,`AuthorName`),
  KEY `BookWrite_fk_1_idx` (`BookName`),
  KEY `BookWrite_fk_2_idx` (`AuthorName`),
  CONSTRAINT `BookWrite_fk_1` FOREIGN KEY (`BookName`) REFERENCES `book` (`BookName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BookWrite_fk_2` FOREIGN KEY (`AuthorName`) REFERENCES `author` (`AuthorName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookwrite`
--

LOCK TABLES `bookwrite` WRITE;
/*!40000 ALTER TABLE `bookwrite` DISABLE KEYS */;
INSERT INTO `bookwrite` VALUES ('Faltal Book','Agatha Christie'),('Faltal Book','Hans Christian Andersen'),('Murder on the Orient Express','Agatha Christie'),('The Emperors New Clothes','Hans Christian Andersen'),('The Ugly Duckling','Agatha Christie'),('The Ugly Duckling','Hans Christian Andersen');
/*!40000 ALTER TABLE `bookwrite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `GenreNumber` varchar(45) NOT NULL,
  `GenreName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`GenreNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES ('g1','detective novel',NULL),('g2','fairy tale book',NULL);
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owner`
--

DROP TABLE IF EXISTS `owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owner` (
  `OwnerName` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  PRIMARY KEY (`OwnerName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES ('Monica','123456');
/*!40000 ALTER TABLE `owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ownerorder`
--

DROP TABLE IF EXISTS `ownerorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ownerorder` (
  `OwnerOrderNumber` int(11) NOT NULL AUTO_INCREMENT,
  `PublisherName` varchar(45) NOT NULL,
  `BookName` varchar(45) NOT NULL,
  `BookCount` int(11) DEFAULT NULL,
  `EmailContent` varchar(100) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`OwnerOrderNumber`),
  KEY `OwnerOrder_fk_1_idx` (`PublisherName`),
  KEY `OwnerOrder_fk_2_idx` (`BookName`),
  CONSTRAINT `OwnerOrder_fk_1` FOREIGN KEY (`PublisherName`) REFERENCES `publisher` (`PublisherName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `OwnerOrder_fk_2` FOREIGN KEY (`BookName`) REFERENCES `book` (`BookName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ownerorder`
--

LOCK TABLES `ownerorder` WRITE;
/*!40000 ALTER TABLE `ownerorder` DISABLE KEYS */;
INSERT INTO `ownerorder` VALUES (1,'Pearson','Faltal Book',11,'Please send me 11 Faltal Book books.','2020-04-11 16:32:59');
/*!40000 ALTER TABLE `ownerorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `PublisherName` varchar(45) NOT NULL,
  `Address` varchar(100) DEFAULT NULL,
  `EmailAddress` varchar(45) DEFAULT NULL,
  `PhoneNumber` varchar(45) DEFAULT NULL,
  `BankingAccount` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`PublisherName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES ('Pearson','France','pearson@gmail.com','100002','1000000000002'),('Penguin Random House','America','penguin@gmai.com','100001','1000000000001');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trackinfo`
--

DROP TABLE IF EXISTS `trackinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trackinfo` (
  `TrackInfoNumber` int(11) NOT NULL AUTO_INCREMENT,
  `UserOrderNumber` varchar(45) NOT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TrackInfoNumber`),
  KEY `TrackInfo_fk_1_idx` (`UserOrderNumber`),
  CONSTRAINT `TrackInfo_fk_1` FOREIGN KEY (`UserOrderNumber`) REFERENCES `userorder` (`UserOrderNumber`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackinfo`
--

LOCK TABLES `trackinfo` WRITE;
/*!40000 ALTER TABLE `trackinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `trackinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `UserName` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `CreditCard` varchar(45) NOT NULL,
  PRIMARY KEY (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('Bob','123456','666666666'),('Chandler','123456','888888888'),('Joey','123456','999999999'),('Rose','123456','777777777');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userorder`
--

DROP TABLE IF EXISTS `userorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userorder` (
  `UserOrderNumber` varchar(45) NOT NULL,
  `UserName` varchar(45) NOT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `CreditCard` varchar(45) DEFAULT NULL,
  `PhoneNumber` varchar(45) DEFAULT NULL,
  `Address` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`UserOrderNumber`),
  KEY `UserOrder_fk_1_idx` (`UserName`),
  CONSTRAINT `UserOrder_fk_1` FOREIGN KEY (`UserName`) REFERENCES `user` (`UserName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userorder`
--

LOCK TABLES `userorder` WRITE;
/*!40000 ALTER TABLE `userorder` DISABLE KEYS */;
INSERT INTO `userorder` VALUES ('Bob20200411163052','Bob','2020-04-11 16:30:52','111','222','333');
/*!40000 ALTER TABLE `userorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userorderitem`
--

DROP TABLE IF EXISTS `userorderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userorderitem` (
  `UserOrderItemNumber` int(11) NOT NULL AUTO_INCREMENT,
  `UserOrderNumber` varchar(45) NOT NULL,
  `BookName` varchar(45) NOT NULL,
  PRIMARY KEY (`UserOrderItemNumber`),
  KEY `UserOrderItem_fk_1_idx` (`UserOrderNumber`),
  KEY `UserOrderItem_fk_2_idx` (`BookName`),
  CONSTRAINT `UserOrderItem_fk_1` FOREIGN KEY (`UserOrderNumber`) REFERENCES `userorder` (`UserOrderNumber`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `UserOrderItem_fk_2` FOREIGN KEY (`BookName`) REFERENCES `book` (`BookName`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userorderitem`
--

LOCK TABLES `userorderitem` WRITE;
/*!40000 ALTER TABLE `userorderitem` DISABLE KEYS */;
INSERT INTO `userorderitem` VALUES (5,'Bob20200411163052','Faltal Book'),(6,'Bob20200411163052','Faltal Book'),(7,'Bob20200411163052','Faltal Book'),(8,'Bob20200411163052','Faltal Book'),(9,'Bob20200411163052','Faltal Book'),(10,'Bob20200411163052','Faltal Book'),(11,'Bob20200411163052','Faltal Book'),(12,'Bob20200411163052','Faltal Book'),(13,'Bob20200411163052','Faltal Book'),(14,'Bob20200411163052','Faltal Book'),(15,'Bob20200411163052','Faltal Book'),(16,'Bob20200411163052','Murder on the Orient Express');
/*!40000 ALTER TABLE `userorderitem` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-04-11 21:30:24

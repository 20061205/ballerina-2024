CREATE DATABASE  IF NOT EXISTS `juice_shop` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `juice_shop`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: juice_shop
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `customer_orders`
--

DROP TABLE IF EXISTS `customer_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `ordered_date` date DEFAULT NULL,
  `ordered_time` time DEFAULT NULL,
  `dilivary_time` time DEFAULT NULL,
  `total_price` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `status_id` (`status_id`),
  KEY `user_id` (`user_id`),
  KEY `Key` (`dilivary_time`),
  CONSTRAINT `customer_orders_ibfk_1` FOREIGN KEY (`status_id`) REFERENCES `order_status` (`status_id`),
  CONSTRAINT `customer_orders_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_orders`
--

LOCK TABLES `customer_orders` WRITE;
/*!40000 ALTER TABLE `customer_orders` DISABLE KEYS */;
INSERT INTO `customer_orders` VALUES (2,2,3,'2024-10-07','11:45:00','00:00:00',NULL),(4,2,5,'2024-10-18','07:16:02','07:46:02',NULL),(17,10,1,'2024-10-18','22:39:00','22:39:00',10.97),(18,1,1,'2024-10-25','06:48:00','06:48:00',14.96),(20,16,2,'2024-10-22','07:21:00','08:06:00',11.46),(21,16,2,'2024-10-24','08:41:00','09:26:00',15.96);
/*!40000 ALTER TABLE `customer_orders` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `set_ordered_date_time_defaults` BEFORE INSERT ON `customer_orders` FOR EACH ROW BEGIN
    -- Set ordered_date to current date if not provided
    IF NEW.ordered_date IS NULL THEN
        SET NEW.ordered_date = CURDATE();
    END IF;

    -- Set ordered_time to current time if not provided
    IF NEW.ordered_time IS NULL THEN
        SET NEW.ordered_time = CURTIME();
    END IF;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_order_delete` BEFORE DELETE ON `customer_orders` FOR EACH ROW BEGIN
    -- Delete corresponding records from order_items when an order is deleted
    DELETE FROM order_items WHERE order_items.order_id = OLD.order_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `customer_orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (3,2,2,3),(4,2,4,1),(29,17,1,1),(30,17,3,2),(31,18,1,1),(32,18,3,3),(35,20,1,3),(36,20,2,1),(37,21,2,1),(38,21,4,1),(39,21,10,2);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_total_price_after_insert` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
    -- Update the total_price in the customer_orders table
    UPDATE customer_orders
    SET total_price = (
        SELECT SUM(p.unit_price * oi.quantity)
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_ID
        WHERE oi.order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `order_status`
--

DROP TABLE IF EXISTS `order_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `Status` varchar(20) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_status`
--

LOCK TABLES `order_status` WRITE;
/*!40000 ALTER TABLE `order_status` DISABLE KEYS */;
INSERT INTO `order_status` VALUES (1,'Pending','Order has been placed but not processed'),(2,'Processing','Order is being prepared'),(3,'Shipped','Order has been shipped'),(4,'Delivered','Order has been delivered to the customer'),(5,'Cancelled','Order has been cancelled');
/*!40000 ALTER TABLE `order_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_ID` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(50) DEFAULT NULL,
  `unit_price` decimal(6,2) DEFAULT NULL,
  `availability` tinyint(1) DEFAULT NULL,
  `image` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Orange Juice',2.99,1,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_k3dmXxGhAIYtpo1VDWy8SJi30wQqJ5J9Ig&s'),(2,'Apple Juice',2.49,1,'https://images.freeimages.com/images/large-previews/ade/apple-juice-1-1321109.jpg'),(3,'Mango Smoothie',3.99,1,'https://media.istockphoto.com/id/1056675358/photo/healthy-mango-smoothie.jpg?s=612x612&w=0&k=20&c=-6wKcUf2trNP1wHOoCnEJxNPcK7cqQ8dPQdqAnOJEoU='),(4,'Green Detox',4.49,1,'https://media.gettyimages.com/id/485131020/photo/green-vegetable-juice-on-rustic-wood-table.jpg?s=612x612&w=gi&k=20&c=G0xj5UEgXYfOC8yigyvxZITf67SIT7w52Kislax9xj4='),(5,'Berry Blast',3.79,1,'https://st5.depositphotos.com/14497066/62110/i/450/depositphotos_621103364-stock-photo-berry-fruit-smoothie-glass-jar.jpg'),(6,'Tropical Smoothie',5.99,1,'https://flavorthemoments.com/wp-content/uploads/2022/02/tropical-smoothie-recipe-1.jpg'),(8,'Green Goddess Juice',6.99,1,'https://happyfoodhealthylife.com/wp-content/uploads/2013/01/GREEN-GODDESS-SMOOTHIE-8-500x433.jpg'),(10,'Minty Melon',4.49,1,'https://img.freepik.com/premium-photo/fresh-watermelon-mint-watermelon-juice_221128-20022.jpg');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_ID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `phone_number` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`user_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'John','Doe','johndoe','password123','john.doe@example.com','customer','1234567890'),(2,'Jane','Smith','janesmith','securepass','jane.smith@example.com','customer','9876543210'),(3,'Admin','User','adminuser','admin123','admin@juiceshop.com','admin','5555555555'),(4,'Johne','Doee','johndoeee','password123','john.doeee@example.com','customer','1234567890'),(5,'enfinseidfn','Doe','dsihFij','password123','john.doe@example.com','customer','1234567890'),(6,'John','Doe','johndoe111','password123','john.doe@example.com','customer','1234567890'),(9,'John','Doe','johnafasffdoe','password123','john.doe@example.com','customer','1234567890'),(10,'hansi','lakmali','hansi','12344','hihijsjjj@gmail.com','ty','089763'),(11,'hansi','lakmali','hanej,cesi','12344','hihijsjjj@gmail.com','ty','089763'),(12,'hansi','lakmali','hansijkiui','12345','teamnandj@gmail.com','customer','089765467'),(13,'jack','Smith','jacks','123456','teamnandj@gmail.com','customer','08976346'),(14,'dulakshi','chamodya','dul','12345','hihijsjjj@gmail.com','customer','08976346'),(16,'Dulakshi','Abeynayake ','dulak','DUL','duln@gmail.comK','customer','0123456789'),(19,'janodi','Savindya','janodi','12345','hihijsjjj@gmail.com','customer','08976346'),(20,'janu','Savindya','janu','12345','janodijayathunga@gmail.com','admin','08976346');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'juice_shop'
--

--
-- Dumping routines for database 'juice_shop'
--
/*!50003 DROP FUNCTION IF EXISTS `InsertCustomerOrderAndReturnID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `InsertCustomerOrderAndReturnID`(
    p_user_id INT,
    p_status_id INT,
    p_ordered_date DATE,
    p_ordered_time TIME,
    p_dilivary_time TIME
) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_order_id INT;

    -- Insert the new order into the customer_orders table
    INSERT INTO customer_orders (user_id, status_id, ordered_date, ordered_time, dilivary_time,total_price)
    VALUES (p_user_id, p_status_id, p_ordered_date, p_ordered_time, p_dilivary_time,0);

    -- Get the last inserted order_id
    SET v_order_id = LAST_INSERT_ID();

    -- Return the order_id
    RETURN v_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertOrder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertOrder`(
    IN p_user_id INT,
    IN p_order_date DATE,
    IN p_order_time TIME,
    IN p_products JSON
)
BEGIN
    -- Declare all variables at the beginning
    DECLARE v_order_id INT;
    DECLARE i INT DEFAULT 0;
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_length INT;

    -- Error handling block must also be declared at the top
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Return an error message
        SELECT 'An error occurred while submitting the order' AS error_message;
    END;

    -- Start the transaction
    START TRANSACTION;

    -- Insert into customer_order table
    INSERT INTO customer_order (user_id, order_date, dilivary_time)
    VALUES (p_user_id, p_order_date, p_order_time);

    -- Get the last inserted order ID
    SET v_order_id = LAST_INSERT_ID();

    -- Calculate the number of products in the JSON array
    SET v_length = JSON_LENGTH(p_products);

    -- Insert into order_item table by iterating over the products
    WHILE i < v_length DO
        SET v_product_id = JSON_UNQUOTE(JSON_EXTRACT(p_products, CONCAT('$[', i, '].product_ID')));
        SET v_quantity = JSON_UNQUOTE(JSON_EXTRACT(p_products, CONCAT('$[', i, '].quantity')));
        
        -- Insert each product into the order_item table
        INSERT INTO order_item (order_id, product_id, quantity)
        VALUES (v_order_id, v_product_id, v_quantity);

        -- Increment the counter
        SET i = i + 1;
    END WHILE;

    -- Commit the transaction if all inserts succeed
    COMMIT;

    -- Signal success
    SELECT 'Order submitted successfully' AS message;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-20 11:25:33

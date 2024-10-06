create database juice_shop;
use juice_shop;
CREATE TABLE `user` (
  `user_ID` INT auto_increment,
  `first_name` varchar(20),
  `last_name` varchar(20),
  `username` varchar(20),
  `password` varchar(64),
  `email` varchar(50),
  `user_type` varchar(20),
  `phone_number` varchar(10),
  PRIMARY KEY (`user_ID`)
);

CREATE TABLE `products` (
  `product_ID` INT auto_increment,
  `product_name` varchar(50),
  `unit_price` numeric(6,2),
  `availability` boolean,
  `image` varchar(50),
  PRIMARY KEY (`product_ID`)
);

CREATE TABLE `order_status` (
  `status_id` int auto_increment,
  `Status` varchar(20),
  `description` varchar(50),
  PRIMARY KEY (`status_id`)
);

CREATE TABLE `order` (
  `order_id` int auto_increment,
  `user_id` int,
  `status_id` int,
  `ordered_date` date,
  `ordered_time` time,
  `expriory_date` time,
  PRIMARY KEY (`order_id`),
  FOREIGN KEY (`status_id`) REFERENCES `order_status`(`status_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`user_ID`),
  KEY `Key` (`expriory_date`)
);

CREATE TABLE `order -item` (
  `order_item_id` int auto_increment,
  `order_id` int,
  `product_id` int,
  `quantity` int,
  PRIMARY KEY (`order_item_id`),
  FOREIGN KEY (`order_id`) REFERENCES `order`(`order_id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`product_ID`)
);



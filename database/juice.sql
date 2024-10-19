create database juice_shop;
use juice_shop;
CREATE TABLE `users` (
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
  `ordered_time` time ,
  `dilivary_time` time,
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



DELIMITER //

CREATE PROCEDURE InsertOrder(
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
    INSERT INTO customer_order (user_id, order_date, order_time)
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

END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER set_ordered_date_time_defaults
BEFORE INSERT ON customer_order
FOR EACH ROW
BEGIN
    -- Set ordered_date to current date if not provided
    IF NEW.ordered_date IS NULL THEN
        SET NEW.ordered_date = CURDATE();
    END IF;

    -- Set ordered_time to current time if not provided
    IF NEW.ordered_time IS NULL THEN
        SET NEW.ordered_time = CURTIME();
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_order_delete
before DELETE ON customer_orders
FOR EACH ROW
BEGIN
    -- Delete corresponding records from order_items when an order is deleted
    DELETE FROM order_items WHERE order_items.order_id = OLD.order_id;
END//

DELIMITER ;
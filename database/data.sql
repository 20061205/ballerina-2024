use juice_shop;
-- Inserting sample users
INSERT INTO `user` (first_name, last_name, username, password, email, user_type, phone_number)
VALUES 
('John', 'Doe', 'johndoe', 'password123', 'john.doe@example.com', 'customer', '1234567890'),
('Jane', 'Smith', 'janesmith', 'securepass', 'jane.smith@example.com', 'customer', '9876543210'),
('Admin', 'User', 'adminuser', 'admin123', 'admin@juiceshop.com', 'admin', '5555555555');

-- Inserting sample products
INSERT INTO `products` (product_name, unit_price, availability, image)
VALUES 
('Orange Juice', 2.99, true, 'orange_juice.jpg'),
('Apple Juice', 2.49, true, 'apple_juice.jpg'),
('Mango Smoothie', 3.99, true, 'mango_smoothie.jpg'),
('Green Detox', 4.49, true, 'green_detox.jpg'),
('Berry Blast', 3.79, true, 'berry_blast.jpg');

-- Inserting sample order statuses
INSERT INTO `order_status` (Status, description)
VALUES 
('Pending', 'Order has been placed but not processed'),
('Processing', 'Order is being prepared'),
('Shipped', 'Order has been shipped'),
('Delivered', 'Order has been delivered to the customer'),
('Cancelled', 'Order has been cancelled');

-- Inserting sample orders
INSERT INTO `order` (user_id, status_id, ordered_date, ordered_time, expriory_date)
VALUES 
(1, 1, '2024-10-07', '10:30:00', '2024-10-14 10:30:00'),
(2, 2, '2024-10-07', '11:45:00', '2024-10-14 11:45:00'),
(1, 3, '2024-10-06', '09:15:00', '2024-10-13 09:15:00');

-- Inserting sample order items
INSERT INTO `order -item` (order_id, product_id, quantity)
VALUES 
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(2, 4, 1),
(3, 5, 2),
(3, 1, 1);
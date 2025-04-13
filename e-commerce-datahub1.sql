 
CREATE DATABASE ecommerce_datahub; USE ecommerce_datahub;
#-- Customer Data
 CREATE TABLE customer_data ( customer_id INT AUTO_INCREMENT PRIMARY KEY, 
 first_name VARCHAR(50),
 last_name VARCHAR(50), email VARCHAR(100), city VARCHAR(100) );
 #-- Product Catalog
 CREATE TABLE product_catalog ( product_id INT AUTO_INCREMENT PRIMARY KEY, 
 product_name VARCHAR(100), description TEXT, price DECIMAL(10, 2), stock_quantity INT );
 #-- Order Records
 CREATE TABLE order_records ( order_id INT AUTO_INCREMENT PRIMARY KEY, 
 customer_id INT NOT NULL, order_date DATE, total_amount DECIMAL(10,2), 
 status VARCHAR(20), FOREIGN KEY (customer_id) REFERENCES customer_data(customer_id) );
 #####################################################################################
 #-- Order Line Items 
 CREATE TABLE order_line_items ( order_item_id INT AUTO_INCREMENT PRIMARY KEY,
 order_id INT NOT NULL, product_id INT NOT NULL, quantity INT, price DECIMAL(10,2), 
 FOREIGN KEY (order_id) REFERENCES order_records(order_id), 
 FOREIGN KEY (product_id) REFERENCES product_catalog(product_id) );
 #####################################################################################
# -- Payment Info
 CREATE TABLE payment_info ( payment_id INT AUTO_INCREMENT PRIMARY KEY,
 order_id INT NOT NULL, payment_date DATE, amount DECIMAL(10,2),
 payment_method VARCHAR(50), 
 FOREIGN KEY (order_id) REFERENCES order_records(order_id) );
 
 ###################################################################################
 -- Insert Customers
 INSERT INTO customer_data (first_name, last_name, email, city) 
 VALUES ('Alice', 'Smith', 'alice@example.com', 'New York'), 
 ('Bob', 'Brown', 'bob@example.com', 'Los Angeles'),
 ('Carol', 'Davis', 'carol@example.com', 'Chicago'),
 ('David', 'Wilson', 'david@example.com', 'Houston'), 
 ('Emma', 'Johnson', 'emma@example.com', 'Phoenix'), 
 ('Frank', 'Taylor', 'frank@example.com', 'San Diego'), 
 ('Grace', 'Moore', 'grace@example.com', 'Dallas'),
 ('Hank', 'Miller', 'hank@example.com', 'Austin'), 
 ('Ivy', 'Anderson', 'ivy@example.com', 'San Jose'),
 ('Jack', 'Thomas', 'jack@example.com', 'San Francisco');
 #####################################################################################
 -- Insert Products 
 INSERT INTO product_catalog (product_name, description, price, stock_quantity) 
 VALUES ('Laptop', 'High performance laptop', 1000.00, 10), 
 ('Phone', 'Latest smartphone', 700.00, 15),
 ('Mouse', 'Wireless mouse', 30.00, 40), 
 ('Keyboard', 'Mechanical keyboard', 80.00, 25), 
 ('Monitor', '24-inch LED monitor', 200.00, 20), 
 ('Printer', 'Laser printer', 150.00, 12), 
 ('Tablet', '10-inch Android tablet', 300.00, 18),
 ('Headphones', 'Noise-cancelling headphones', 120.00, 30),
 ('Webcam', 'HD webcam', 60.00, 22),
 ('Speaker', 'Bluetooth speaker', 90.00, 17);
 ####################################################################################
 -- Insert Orders 
 INSERT INTO order_records (customer_id, order_date, total_amount, status) 
 VALUES (1, '2024-04-01', 1030.00, 'Shipped'),
 (2, '2024-04-02', 730.00, 'Delivered'),
 (3, '2024-04-03', 60.00, 'Processing'), 
 (4, '2024-04-04', 1280.00, 'Delivered'),
 (5, '2024-04-05', 400.00, 'Shipped'),
 (6, '2024-04-06', 120.00, 'Shipped'), 
 (7, '2024-04-07', 300.00, 'Delivered'),
 (8, '2024-04-08', 290.00, 'Processing'), 
 (9, '2024-04-09', 150.00, 'Processing'), 
 (10, '2024-04-10', 1090.00, 'Delivered');
 #####################################################################################
 -- Insert Order Line Items 
 INSERT INTO order_line_items (order_id, product_id, quantity, price)
 VALUES (1, 1, 1, 1000.00), (1, 3, 1, 30.00), (2, 2, 1, 700.00), (2, 3, 1, 30.00),
 (3, 9, 1, 60.00), (4, 1, 1, 1000.00), (4, 4, 1, 80.00), (4, 5, 1, 200.00),
 (5, 7, 1, 300.00), (5, 8, 1, 100.00), (6, 8, 1, 120.00), (7, 7, 1, 300.00),
 (8, 10, 2, 180.00), (9, 6, 1, 150.00), (10, 1, 1, 1000.00), (10, 4, 1, 90.00);
 ####################################################################################
 -- Insert Payments
 INSERT INTO payment_info (order_id, payment_date, amount, payment_method)
 VALUES (1, '2024-04-01', 1030.00, 'Credit Card'), (2, '2024-04-02', 730.00, 'PayPal'),
 (3, '2024-04-03', 60.00, 'Debit Card'), (4, '2024-04-04', 1280.00, 'Credit Card'),
 (5, '2024-04-05', 400.00, 'UPI'), (6, '2024-04-06', 120.00, 'Credit Card'),
 (7, '2024-04-07', 300.00, 'PayPal'), (8, '2024-04-08', 290.00, 'Debit Card'),
 (9, '2024-04-09', 150.00, 'Credit Card'), (10, '2024-04-10', 1090.00, 'UPI');
 
 select * from customer_data;
##################################################################################### 
 #1. Retrieve a list of customers along with the total number of orders they placed and the total amount they spent.
SELECT c.customer_id, c.first_name, c.last_name, 
       COUNT(o.order_id) AS total_orders, 
       SUM(o.total_amount) AS total_spent
FROM customer_data c
JOIN order_records o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 0
ORDER BY total_spent DESC;
######################################################################################
#2. For each product, calculate the total quantity sold and the total revenue generated.

SELECT p.product_id, p.product_name, 
       SUM(oli.quantity) AS total_quantity_sold, 
       SUM(oli.quantity * oli.price) AS total_revenue
FROM product_catalog p
JOIN order_line_items oli ON p.product_id = oli.product_id
GROUP BY p.product_id, p.product_name
HAVING total_quantity_sold > 0
ORDER BY total_revenue DESC;
######################################################################################
 #3. List all orders along with customer names, payment methods, and payment amounts.

SELECT o.order_id, c.first_name, c.last_name, 
       p.payment_method, p.amount
FROM order_records o
JOIN customer_data c ON o.customer_id = c.customer_id
JOIN payment_info p ON o.order_id = p.order_id
WHERE p.payment_method = 'Credit Card';
######################################################################################
 #4. Find the top 5 customers who have placed the highest number of orders.
SELECT c.customer_id, 
       CONCAT(c.first_name, ' ', c.last_name) AS full_name, 
       COUNT(o.order_id) AS num_orders
FROM customer_data c
JOIN order_records o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, full_name
ORDER BY num_orders DESC
LIMIT 5;
#####################################################################################
 #5. Create a view that shows details of all products with low stock (less than 20 units in stock).

CREATE VIEW low_stock_products AS
SELECT product_id, product_name, stock_quantity
FROM product_catalog
WHERE stock_quantity < 20;
##################################################################################### 
# 6. Create a report of total revenue generated per city.

SELECT c.city, SUM(o.total_amount) AS city_revenue
FROM order_records o
JOIN customer_data c ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING city_revenue > 1000
ORDER BY city_revenue DESC;
 ####################################################################################
 #7. Use a subquery to list all customers who have placed orders with an average value greater than $500.
SELECT customer_id, AVG(total_amount) AS avg_order_value
FROM order_records
GROUP BY customer_id
HAVING AVG(total_amount) > 500;
###############################################################################################
#8 Performance of queries filtering orders by status by creating an index on the status column of the order_records table.

CREATE INDEX idx_order_status ON order_records(status);


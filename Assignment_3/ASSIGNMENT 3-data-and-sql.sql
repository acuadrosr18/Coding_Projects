-- ASSIGNMENT 3: Data and MySQL

CREATE DATABASE ecommerce_sales;

USE ecommerce_sales;

-- Creation of Tables

CREATE TABLE products ( 
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
	stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    age INT NOT NULL CHECK (age >=18),
    location VARCHAR(100)
);

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    location VARCHAR(100)
);

-- Add supplier_id column to Products table
ALTER TABLE products
ADD supplier_id INT;

-- Set supplier_id as a forigen key referencing the suppliers table
ALTER TABLE products
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id);

CREATE TABLE transactions (
	transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL, 
    quantity INT NOT NULL CHECK (quantity > 0),
    total_price DECIMAL(10, 2) NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insertion of data into tables

INSERT INTO products (name, category, price, stock)
VALUES
("Laptop","Electronics",2100.00,5),
("Headphones","Electronics",500.00,50),
("Gaming Chair","Furniture",300.00,10),
("Standing Desk","Furniture",400.00,8),
("Smartphone","Electronics",1000.00,52),
("Monitor","Electronics",300.00,10),
("Mouse","Electronics",55.00,75),
("Keyboard","Electronics",70.00,30),
("Tablet","Electronics",400.00,35),
("iPad","Electronics",1500.00,15),
("Gaming Console","Gaming",800.00,15),
("Bookshelf","Furniture",300.00,15),
("Desk Lamp","Furniture",20.00,25),
("TV","Electronics",1500.00,10),
("Speakers","Electronics",320.00,20),
("Apple Watch","Electronics",500.00,15),
("Fitness Tracker","Electronics",300.00,15),
("Air Conditioner","Appliances",180.00,25),
("Mini Refrigerator","Appliances",500.00,15),
("Blender","Appliances",120.00,30),
("Microwave","Appliances",250.00,20),
("Air Fryer","Appliances",350.00,50);


INSERT INTO customers (name, email, age, location)
VALUES
("Alejandra Cuadros","acuadrosr18@gmail.com",27,"Budapest"),
("Camila Cuadros","camilarcv21@gmail.com",23,"Arequipa"),
("Christopher Brown","cbrown@hotmail.com",43,"New York"),
("Jose Paz","japp05@gmail.com",29,"Melbourne"),
("Magd Charaawi","magdchaa@gmail.com",27,"Cairo"),
("Dmitriy Konyakin","dmitry@hotmail.com",23,"Moscow"),
("Yang Xu","xuyang@yahoo.com",27,"Wuhan"),
("Shaan Hossain","shaaanhooos@gmail.com",28,"Dhaka"),
("Petra Haraszti","PetraHara@hotmail.co,",26,"Budapest"),
("Saul Gomez","saulgomez@gmail.com",27,"Monterrey"),
("Imane El-Abiad","imaneelabiad@gmail.com",24,"Rabat"),
("Bence Császár","Bencecsazar@gmail.com",32,"Budapest"),
("Fernanda Hincho","frebeccahincho@gmail.com",27,"Madrid"),
("Vugar Babashli","vugababashlir@gmail.com",24,"Baku"),
("Zyad Elhessy","zyadawad@gmail.com",32,"Cairo"),
("Nene Abayateye","nenisimo@hotmail.com",37,"Accra"),
("Altynyemal Taganova","altyntaganova@hotmail.com",24,"Ashgabat"),
("Sarai Gonzales","saraigonzgonz@gmail.com",27,"MexicoDF"),
("Aaqid Farooq","aaqid@gmail.com",26,"New Delhi");


INSERT INTO suppliers (supplier_name, contact_email, phone_number, location)
VALUES
("Elite", "sales@elite.com", "123-456-789", "London"),
("Quick Supply", "sales@quicktech.com", "890-123-467", "Ashgabat"),
("Luxury Electronics", "sales@luxuryelectronics.com", "012-345-6789", "Dubai"),
("TechWorld", "sales@techworld.com", "123-456-780", "Paris"),
("FurniCorp", "sales@furnicorp.com", "234-567-801", "Rome"),
("Appliance ProMart", "sales@appliancepromart.com", "345-678-902", "Vienna"),
("GameHouse Distributors", "sales@gamehouse.com", "456-789-123", "Prague"),
("SmartTech", "sales@smarttech.com", "567-890-134", "Berlin"),
("Home Essentials", "sales@homeessentials.com", "678-901-235", "Budapest"),
("Gadget World", "sales@gadgetworld.com", "456-789-023", "Cairo");

-- Update Products table to assign supplier_id to products based on their supplier
UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "Elite")
WHERE name IN ("Laptop", "Headphones");

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "Quick Supply")
WHERE name IN ("Gaming Chair", "Monitor");

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "Luxury Electronics")
WHERE name IN ("Apple Watch", "Speakers", "Fitness Tracker");

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "TechWorld")
WHERE name IN ("Smartphone", "iPad", "Tablet","TV");

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "FurniCorp")
WHERE name IN ("Bookshelf", "Standing Desk", "Desk Lamp");

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "Appliance ProMart")
WHERE category = "Appliances";

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "GameHouse Distributors")
WHERE category = "Gaming";

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "SmartTech")
WHERE name IN ("Mouse", "Keyboard");

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "Home Essentials")
WHERE name = "Desk Lamp";

UPDATE products
SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = "Gadget World")
WHERE name = "Gaming Console";

-- Verify the tables so far
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM suppliers;
SELECT * FROM transactions;

-- Retrieve product details with supplier details
SELECT 
    products.name AS product_name, 
    suppliers.supplier_name, 
    products.price, 
    products.stock, 
    suppliers.location AS supplier_location
FROM 
    products
JOIN 
    suppliers ON products.supplier_id = suppliers.supplier_id
ORDER BY 
    products.name;

SELECT * FROM products;

-- Insert data into Transactions table
INSERT INTO transactions (product_id, customer_id, quantity, total_price)
VALUES
(10, 10, 1, (SELECT price FROM products WHERE product_id = 10) * 1), -- Saul bought 1 iPad
(2, 2, 2, (SELECT price FROM Products WHERE product_id = 2) * 2),  -- Camila bought 2 Headphones
(5, 5, 1, (SELECT price FROM Products WHERE product_id = 5) * 1),  -- Magd bought 1 Smartphone
(1, 1, 1, (SELECT price FROM Products WHERE product_id = 1) * 1),  -- Alejandra bought 1 Laptop
(4, 4, 1, (SELECT price FROM Products WHERE product_id = 4) * 1),  -- Jose bought 1 Standing Desk
(7, 7, 3, (SELECT price FROM Products WHERE product_id = 7) * 3),  -- Yang bought 3 Mice
(9, 9, 1, (SELECT price FROM Products WHERE product_id = 9) * 1),  -- Petra bought 1 Tablet
(3, 3, 1, (SELECT price FROM Products WHERE product_id = 3) * 1),  -- Christopher bought 1 Gaming Chair
(6, 6, 2, (SELECT price FROM Products WHERE product_id = 6) * 2),  -- Dmitriy bought 2 Monitors
(22, 1, 1, (SELECT price FROM Products WHERE product_id = 1) * 1),  -- Alejandra bought 1 Air Fryer
(8, 8, 1, (SELECT price FROM Products WHERE product_id = 8) * 1);  -- Shaan bought 1 Keyboard

-- Verify transactions table
-- Retrieve transaction details to verify total_price calculation
SELECT 
    transactions.transaction_id,
    products.name AS product_name,
    customers.name AS customer_name,
    transactions.quantity,
    transactions.total_price,
    transactions.purchase_date
FROM 
    transactions
JOIN 
    products ON transactions.product_id = products.product_id
JOIN 
    customers ON transactions.customer_id = customers.customer_id
ORDER BY 
    transactions.purchase_date DESC;


-- Calculate total sales per product
SELECT 
    products.name AS product_name,
    SUM(transactions.total_price) AS total_sales
FROM 
    transactions
JOIN 
    products ON transactions.product_id = products.product_id
GROUP BY 
    products.name
ORDER BY 
    total_sales DESC;


-- Calculate the total quantity sold for each product
SELECT 
    products.name AS product_name,
    SUM(transactions.quantity) AS total_quantity_sold
FROM 
    transactions
JOIN 
    products ON transactions.product_id = products.product_id
GROUP BY 
    products.name
ORDER BY 
    total_quantity_sold DESC;
    
SELECT * FROM transactions;

-- Camila Cuadros called and canceled her order for 2 Headphones
-- Lets find her transactions first

-- Find Camila Cuadros' transactions
SELECT 
    transactions.transaction_id,
    customers.name AS customer_name,
    products.name AS product_name,
    transactions.quantity,
    transactions.total_price,
    transactions.purchase_date
FROM 
    transactions
JOIN 
    customers ON transactions.customer_id = customers.customer_id
JOIN 
    products ON transactions.product_id = products.product_id
WHERE 
    customers.name = 'Camila Cuadros';

-- Now lets delete her transactions
DELETE FROM transactions 
WHERE transaction_id = 2; 

-- The store discontinues the "Desk Lamp" product
DELETE FROM products 
WHERE name = 'Desk Lamp';

SELECT * FROM products;

-- Show customer contact information by concatenating name and email
SELECT 
    CONCAT(customers.name, ' <', customers.email, '>') AS customer_contact_info
FROM 
    customers;

-- Count the number of transactions for each customer
SELECT 
    customers.name AS customer_name, 
    COUNT(transactions.transaction_id) AS total_transactions
FROM 
    transactions
JOIN 
    customers ON transactions.customer_id = customers.customer_id
GROUP BY 
    customers.name;

-- There are new transactions
-- Insert new transactions
INSERT INTO transactions (product_id, customer_id, quantity, total_price)
VALUES
-- Vugar Babashli buys 1 TV
(14, 14, 1, (SELECT price FROM products WHERE product_id = 14) * 1),

-- Aaqid Farooq buys 3 Fitness Trackers
(16, 19, 3, (SELECT price FROM products WHERE product_id = 16) * 3),

-- Fernanda Hincho buys 2 Air Fryers
(21, 13, 2, (SELECT price FROM products WHERE product_id = 21) * 2);

INSERT INTO transactions (product_id, customer_id, quantity, total_price)
VALUES
-- Fernanda Hincho buys 1 Fitness Tracker
(16, 13, 1, (SELECT price FROM products WHERE product_id = 16) * 1);

-- Analyze total sales per year
SELECT 
    YEAR(transactions.purchase_date) AS sales_year, 
    SUM(transactions.total_price) AS total_sales
FROM 
    transactions
GROUP BY 
    sales_year
ORDER BY 
    sales_year DESC;


-- Stored Procedure or Function to achieve a goal

-- Let's create a procedure to insert a transaction and update product stock
DELIMITER $$ 
CREATE PROCEDURE InsertTransactionAndUpdateStock(
    IN p_product_id INT, 
    IN p_customer_id INT, 
    IN p_quantity INT
)
BEGIN
    DECLARE product_price DECIMAL(10, 2);
    DECLARE available_stock INT;

    -- #1: Get the price and available stock of the product
    SELECT price, stock INTO product_price, available_stock 
    FROM products 
    WHERE product_id = p_product_id;

    -- #2: Check if the available stock is sufficient
    IF available_stock >= p_quantity THEN
        -- #3: Insert the transaction into the transactions table
        INSERT INTO transactions (product_id, customer_id, quantity, total_price)
        VALUES (p_product_id, p_customer_id, p_quantity, product_price * p_quantity);
        
        -- #4: Update the stock of the product by subtracting the purchased quantity
        UPDATE products 
        SET stock = stock - p_quantity 
        WHERE product_id = p_product_id;
    ELSE
        -- #5: Return a message if there isn't enough stock
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
END $$ 
DELIMITER ;

-- Transaction for 2 Laptops (id = 1) purchased by Alejandra Cuadros (customer_id = 1)
CALL InsertTransactionAndUpdateStock(1, 1, 2);

-- Transaction for 1 Smartphone (id = 5) purchased by Camila Cuadros (customer_id = 2)
CALL InsertTransactionAndUpdateStock(5, 2, 1); 


SELECT * FROM products;  

-- Check the transactions table to verify the new transaction
SELECT 
    transactions.transaction_id,
    products.name AS product_name,
    customers.name AS customer_name,
    transactions.quantity,
    transactions.total_price,
    transactions.purchase_date
FROM 
    transactions
JOIN 
    products ON transactions.product_id = products.product_id
JOIN 
    customers ON transactions.customer_id = customers.customer_id
ORDER BY 
    transactions.purchase_date DESC;

-- This should trigger an error if the stock is insufficient
CALL InsertTransactionAndUpdateStock(1, 1, 5); 

-- Check current stock levels for all products
SELECT 
    name AS product_name, 
    stock AS current_stock 
FROM 
    products;


-- Let's check if  the initial transactions were recorded 
SELECT 
    transactions.transaction_id,
    products.name AS product_name,
    customers.name AS customer_name,
    transactions.quantity,
    transactions.total_price,
    transactions.purchase_date
FROM 
    transactions
JOIN 
    products ON transactions.product_id = products.product_id
JOIN 
    customers ON transactions.customer_id = customers.customer_id
ORDER BY 
    transaction_id DESC;

-- They were

-- Let's check if the stock was updated
-- Check the current stock levels for all products
SELECT 
    name AS product_name, 
    stock AS current_stock 
FROM 
    products;

-- The initial transactions were recorded but the stock was not updated cause we did not
-- querie it, now we will delete the first transactions and record them again with the
-- "InsertTransactionAndUpdateStock" procedure

-- Delete all transactions (cause they didn't update stock)
DELETE FROM transactions;
ALTER TABLE transactions AUTO_INCREMENT = 1;
-- Reinsert transactions using the stored procedure to ensure stock updates
-- Saul bought 1 iPad
CALL InsertTransactionAndUpdateStock(10, 10, 1);
-- Camila bought 2 headphones
CALL InsertTransactionAndUpdateStock(2, 2, 2);
-- Magd bought 1 smartphone
CALL InsertTransactionAndUpdateStock(5, 5, 1);
-- Alejandra bought 1 laptop
CALL InsertTransactionAndUpdateStock(1, 1, 1);
-- Jose bought 1 standing desk
CALL InsertTransactionAndUpdateStock(4, 4, 1);
-- Yang bought 3 mice
CALL InsertTransactionAndUpdateStock(7, 7, 3);
-- Petra bought 1 tablet
CALL InsertTransactionAndUpdateStock(9, 9, 1);
-- Christopher bought 1 gaming chair
CALL InsertTransactionAndUpdateStock(3, 3, 1);
-- Dmitriy bought 2 monitors
CALL InsertTransactionAndUpdateStock(6, 6, 2);
-- Shaan bought 1 keyboard
CALL InsertTransactionAndUpdateStock(8, 8, 1);
-- Alejandra bought 1 airfryer
CALL InsertTransactionAndUpdateStock(22,1,1);
-- Alejandra bought 1 laptop
CALL InsertTransactionAndUpdateStock(1, 1, 2);
-- Alejandra bought 1 smartphone
CALL InsertTransactionAndUpdateStock(5, 2, 1); 
-- Vugar bought 1 TV
CALL InsertTransactionAndUpdateStock(14,14,1); 
-- Aaqid buys 3 Fitness Trackers
CALL InsertTransactionAndUpdateStock(16,19,3); 
-- Fernanda buys 2 Air Fryers
CALL InsertTransactionAndUpdateStock(21,13,2); 
-- Fernanda buys 2 Fitness Tracker
CALL InsertTransactionAndUpdateStock(16,13,2);


-- Check the current stock levels for all products to ensure they were updated
SELECT 
    name AS product_name, 
    stock AS current_stock 
FROM 
    products;


-- Adding an index on frequently queried columns
CREATE INDEX idx_purchase_date ON transactions (purchase_date);
CREATE INDEX idx_customer_id ON transactions (customer_id);


SELECT DATE(purchase_date) AS sale_date, SUM(total_price) AS daily_total
FROM transactions
GROUP BY sale_date
ORDER BY sale_date;

-- Join transactions with customers to get customer details
SELECT customers.name, transactions.*
FROM transactions
JOIN customers ON transactions.customer_id = customers.customer_id;


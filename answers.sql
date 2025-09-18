-- ================================================================
-- Database Design and Normalization Assignment - answers.sql
-- ================================================================

- Question 1: Achieving 1NF (First Normal Form)

-- Problem: The ProductDetail table violates 1NF because the Products column 
-- contains multiple values (comma-separated products in a single cell).
-- 
-- Original table structure:
-- OrderID | CustomerName | Products
-- 101     | John Doe     | Laptop, Mouse
-- 102     | Jane Smith   | Tablet, Keyboard, Mouse
-- 103     | Emily Clark  | Phone


--   Original table to demonstrate the transformation
CREATE TABLE ProductDetail_Original (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Inserting Original data
INSERT INTO ProductDetail_Original (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Create the normalized table in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);

-- Transform data to 1NF - each product gets its own row
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query to display the 1NF result
SELECT * FROM ProductDetail_1NF ORDER BY OrderID, Product;

-- ================================================================
-- Question 2: Achieving 2NF (Second Normal Form)
-- ================================================================

-- Problem: The OrderDetails table is in 1NF but violates 2NF because:
-- - CustomerName depends only on OrderID (partial dependency)
-- - The composite primary key is (OrderID, Product)
-- - CustomerName should depend on the entire primary key, not just part of it

-- Original table structure (already in 1NF):
-- OrderID | CustomerName | Product  | Quantity
-- 101     | John Doe     | Laptop   | 2
-- 101     | John Doe     | Mouse    | 1
-- 102     | Jane Smith   | Tablet   | 3
-- 102     | Jane Smith   | Keyboard | 1
-- 102     | Jane Smith   | Mouse    | 2
-- 103     | Emily Clark  | Phone    | 1

-- First, i created the original 1NF table
CREATE TABLE OrderDetails_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Inserting the original data
INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Solution: Split into two tables to achieve 2NF

-- Table 1: Orders (contains OrderID and CustomerName)
-- This removes the partial dependency of CustomerName on OrderID
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table 2: OrderItems (contains OrderID, Product, and Quantity)
-- This table focuses on the many-to-many relationship between orders and products
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the Orders table (removing duplicates)
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert data into the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Query to verify the 2NF structure by joining the tables
SELECT 
    o.OrderID,
    o.CustomerName,
    oi.Product,
    oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;


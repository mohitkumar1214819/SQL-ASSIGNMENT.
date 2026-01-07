-- Q6. Create a database named ECommerceDB and perform the following--

CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- 1. Create the following tables with appropriate data types and constraints:
-- ● Categories
-- ○ CategoryID (INT, PRIMARY KEY)
-- ○ CategoryName (VARCHAR(50), NOT NULL, UNIQUE)

CREATE TABLE Categories(
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(50) NOT NULL UNIQUE
);

-- ● Products
-- ○ ProductID (INT, PRIMARY KEY)
-- ○ ProductName (VARCHAR(100), NOT NULL, UNIQUE)
-- ○ CategoryID (INT, FOREIGN KEY → Categories)
-- ○ Price (DECIMAL(10,2), NOT NULL)
-- ○ StockQuantity (INT)

CREATE TABLE Products(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL UNIQUE,
CategoryID INT,
Price DECIMAL(10,2) NOT NULL,
StockQuantity INT,
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- ● Customers
-- ○ CustomerID (INT, PRIMARY KEY)
-- ○ CustomerName (VARCHAR(100), NOT NULL)
-- ○ Email (VARCHAR(100), UNIQUE)
-- ○ JoinDate (DATE)


CREATE TABLE Customer(
CustomerID INT PRIMARY KEY,
CustomerName VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE,
JoinDate DATE
);

-- ● Orders
-- ○ OrderID (INT, PRIMARY KEY)
-- ○ CustomerID (INT, FOREIGN KEY → Customers)
-- ○ OrderDate (DATE, NOT NULL)
-- ○ TotalAmount (DECIMAL(10,2))


CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
CustomerID INT ,
OrderDate DATE,
TotalAmount DECIMAL(10,2),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- 2. Insert the following records into each table
-- ● Categories
-- CategoryID Category Name
-- 1 Electronics
-- 2 Books
-- 3 Home Goods
-- 4 Apparel

INSERT INTO Categories
(CategoryID, CategoryName)
VALUES
(1, "Electronics"),
(2, "Books"),
(3, "Home Goods"),
(4, "Apparel");

-- ● Products
-- ProductID ProductName CategoryID Price StockQuantity
-- 101 Laptop Pro 1 1200.00 50
-- 102 SQL
-- Handbook
-- 2 45.50 200
-- 103 Smart Speaker 1 99.99 150
-- 104 Coffee Maker 3 75.00 80
-- 105 Novel : The
-- Great SQL
-- 2 25.00 120
-- 106 Wireless
-- Earbuds
-- 1 150.00 100
-- 107 Blender X 3 120.00 60
-- 108 T-Shirt Casual 4 20.00 300

INSERT INTO Products
(ProductID, ProductName, CategoryID, Price, StockQuantity)
VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook',2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel :The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

-- ● Customers
-- CustomerID CustomerName Email Joining Date
-- 1 Alice Wonderland alice@example.com 2023-01-10
-- 2 Bob the Builder bob@example.com 2022-11-25
-- 3 Charlie Chaplin charlie@example.com 2023-03-01
-- 4 Diana Prince diana@example.com 2021-04-26

INSERT INTO Customer 
(CustomerID, CustomerName, Email, JoinDate) 
VALUES
(1, "Alice Wonderland", "alice@example.com", '2023-01-10'),
(2, "Bob the Builder", "bob@example.com", '2022-11-25'),
(3, "Charlie Chaplin", "charlie@example.com", '2023-03-01'),
(4, "Diana Prince", "diana@example.com", '2021-04-26');

-- ● Orders
-- OrderID CustomerID OrderDate TotalAmount
-- 1001 1 2023-04-26 1245.50
-- 1002 2 2023-10-12 99.99
-- 1003 1 2023-07-01 145.00
-- 1004 3 2023-01-14 150.00
-- 1005 2 2023-09-24 120.00
-- 1006 1 2023-06-19 20.00

INSERT INTO Orders
(OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);

 
SELECT * FROM Customer;
SELECT * FROM Categories;
SELECT * FROM Orders;
SELECT * FROM Products;

#### Q7. Generate a report showing CustomerName, Email, and the
#### TotalNumberofOrders for each customer. Include customers who have not placed
### any orders, in which case their TotalNumberofOrders should be 0. Order the results
### by CustomerName

SELECT 
    C.customerName,
    C.Email,
    COALESCE(COUNT(O.OrderID), 0) AS TotalNumberofOrders
FROM
    customer AS c
LEFT JOIN
    Orders AS o ON C.CustomerID = O.CustomerID    
GROUP BY
    c.CustomerID, c.CustomerName, c.Email
ORDER BY
   c.CustomerName;    
   
   
-- Q8.Retrieve Product Information with Category: Write a SQL query to
-- display the ProductName, Price, StockQuantity, and CategoryName for all
-- products. Order the results by CategoryName and then ProductName alphabetically. 

SELECT
P.ProductName,
P.Price,
P.StockQuantity,
C.CategoryName
FROM 
Products AS P
JOIN
   Categories AS C ON P.CategoryID = C.CategoryID
ORDER BY
    C.CategoryName,
    P.ProductName;


-- Q9.Write a SQL query that uses a Common Table Expression (CTE) and a
-- Window Function (specifically ROW_NUMBER() or RANK()) to display the
-- CategoryName, ProductName, and Price for the top 2 most expensive products in
-- each CategoryName.

WITH RankedProducts AS (
	SELECT
       CategoryName,
       ProductName,
       Price,
       RANK() OVER (PARTITION BY CategoryName ORDER BY Price DESC) AS productRank
     FROM
        Products
)        
SELECT
   CategoryName,
   ProductName,
   Price
FROM 
    RankedProducts
WHERE 
	productRank <= 2;  
    
    
-- Q10 You are hired as a data analyst by Sakila Video Rentals, a global movie
-- rental company. The management team is looking to improve decision-making by
-- analyzing existing customer, rental, and inventory data.
-- Using the Sakila database, answer the following business questions to support key strategic
-- initiatives.
-- Tasks & Questions:
-- 1. Identify the top 5 customers based on the total amount they’ve spent. Include customer
-- name, email, and total amount spent.
-- 2. Which 3 movie categories have the highest rental counts? Display the category name
-- and number of times movies from that category were rented.
-- 3. Calculate how many films are available at each store and how many of those have
-- never been rented.
-- 4. Show the total revenue per month for the year 2023 to analyze business seasonality.
-- 5. Identify customers who have rented more than 10 times in the last 6 months.    

-- 1 Identify the top 5 customers based on the total amount they’ve spent. Include customer
-- name, email, and total amount spent.--

SELECT
    c.first_name,
    c.last_name,
    c.email,
    SUM(p.amount) AS total_spent
FROM
    customer AS c
JOIN 
   payment AS p ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email
ORDER BY
    total_spent DESC
LIMIT 5;

-- 2. Which 3 movie categories have the highest rental counts? Display the category name
-- and number of times movies from that category were rented.-- 

SELECT
    cat.name AS category_name,
    COUNT(r.rental_id) AS rental_count
FROM
    category AS cat
JOIN
   film_category AS fc ON cat.category_id = fc.category_id
JOIN
   inventory AS i ON fc.film_id = i.film_id
JOIN
   rental AS r ON i.inventory_id = r.inventory_id   
GROUP BY
   cat.category_id, cat.name
ORDER By
    rental_count DESC 
LIMIT 3;

-- 3 Calculate how many films are available at each store and how many of those have
-- never been rented. --

SELECT
     s.store_id,
     COUNT(DISTINCT i.film_id) AS total_films_available,
     SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS never_rented_films
FROM
   store AS s
JOIN 
   inventory AS i ON s.store_id = i.store_id
LEFT JOIN
   rental AS r ON i.inventory_id = r.inventory_id
GROUP BY
    s.store_id;
    
-- 4 Show the total revenue per month for the year 2023 to analyze business seasonality. --

SELECT
    EXTRACT(MONTH FROM payment_date) AS rental_month,
    SUM(amount) AS total_revenue
FROM
   payment
WHERE 
   EXTRACT(YEAR FROM payment_date) = 2023
GROUP BY
    rental_month
ORDER BY
   rental_month;    

-- 5 Identify customers who have rented more than 10 times in the last 6 months. --

SELECT
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM 
   customer AS c
JOIN 
   rental AS r ON c.customer_id = r.customer_id
WHERE 
   r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY
    c.customer_id, c.first_name, c.last_name
HAVING
    COUNT(r.rental_id) > 10;    













    



























SELECT * FROM Product;


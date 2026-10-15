CREATE DATABASE IF NOT EXISTS E_commerce;
USE E_commerce;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT
);


CREATE TABLE Seller (
    seller_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    seller_address VARCHAR(100)
);


CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(200)
);


CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INT,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id)
        REFERENCES Category(category_id)
        ON DELETE CASCADE
);


CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    method VARCHAR(50)
);


CREATE TABLE Delivery_Address (
    address_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10)
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(10,2) NOT NULL,
    seller_id INT,
    customer_id INT NOT NULL,
    payment_id INT,
    address_id INT,

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE CASCADE,

    FOREIGN KEY (seller_id)
        REFERENCES Seller(seller_id),

    FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id)
        ON DELETE SET NULL,

    FOREIGN KEY (address_id)
        REFERENCES Delivery_Address(address_id)
        ON DELETE SET NULL
);


INSERT INTO Customer VALUES
(1, 'Rahul', 'rahul@gmail.com', 21),
(2, 'Aman', 'aman@gmail.com', 22),
(3, 'Om', 'om@gmail.com', 23);


INSERT INTO Seller VALUES
(1, 'Tech', 'Delhi'),
(2, 'Fashion Hub', 'Mumbai'),
(3, 'Gadget Zone', 'Bangalore');


INSERT INTO Category VALUES
(1, 'Electronics', 'Electronic Products'),
(2, 'Clothing', 'Clothes and Fashion'),
(3, 'Home', 'Home Appliances');


INSERT INTO Product VALUES
(101, 'Laptop', 10, 55000.00, 1),
(102, 'T-Shirt', 27, 799.00, 2),
(103, 'DBMS Book', 20, 350.00, 3);


INSERT INTO Payment VALUES
(201, 55000.00, '2026-09-01', 'UPI'),
(202, 799.00, '2026-09-02', 'UPI'),
(203, 350.00, '2026-09-03', 'Net Banking');


INSERT INTO Delivery_Address VALUES
(301, 'Gurgaon', 'Haryana', '122001'),
(302, 'Mumbai', 'Maharashtra', '400001'),
(303, 'Jaipur', 'Rajasthan', '302001');

INSERT INTO Orders VALUES
(401, '2026-09-01', 55000.00, 1, 1, 201, 301),
(402, '2026-09-02', 799.00, 2, 2, 202, 302),
(403, '2026-09-03', 350.00, 3, 3, 203, 303);

-- DISPLAY TABLE DATA

SELECT * FROM Customer;
SELECT * FROM Seller;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Payment;
SELECT * FROM Delivery_Address;
SELECT * FROM Orders;

INSERT INTO Orders VALUES
(404, '2026-09-04', 1000.00, 1, 1, 201, 301);

INSERT INTO Orders VALUES
(405, '2026-09-05', 500.00, 1, 99, 201, 301);

DELETE FROM Payment WHERE payment_id = 203;
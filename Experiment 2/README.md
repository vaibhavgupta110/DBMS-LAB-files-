# Experiment 2: E-Commerce Database — Relational Schema and Referential Integrity

## Aim
Convert the e-commerce ER diagram into a relational schema using SQL `CREATE TABLE` statements. Apply primary-key, foreign-key, `NOT NULL`, `UNIQUE`, `DEFAULT`, and `ON DELETE CASCADE` constraints where appropriate, insert sample data, and demonstrate referential integrity.

## Software Required
- MySQL Server
- MySQL Workbench or another MySQL-compatible SQL editor

## Database
The experiment uses a database named `e_commerce`.

## Tables
1. **Customer** — customer ID, name, email, and age.
2. **Seller** — seller ID, name, and seller address.
3. **Category** — category ID, name, and description.
4. **Product** — product ID, name, quantity, price, and category ID.
5. **Payment** — payment ID, amount, date, and method.
6. **Delivery** — delivery address ID, city, state, and pincode.
7. **Orders** — order ID, order date, amount, customer, seller, payment, and delivery address.

## SQL Implementation

> The following is a cleaned-up MySQL version of the experiment. It keeps the entities and relationships shown in the handwritten record while using consistent column names and valid SQL syntax.

```sql
CREATE DATABASE IF NOT EXISTS e_commerce;
USE e_commerce;

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
    name VARCHAR(100) NOT NULL,
    description VARCHAR(150)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 0,
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

CREATE TABLE Delivery (
    address_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(10,2),
    customer_id INT,
    seller_id INT,
    payment_id INT,
    address_id INT,
    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE CASCADE,
    FOREIGN KEY (seller_id)
        REFERENCES Seller(seller_id),
    FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id),
    FOREIGN KEY (address_id)
        REFERENCES Delivery(address_id)
);
```

## Insert Sample Data

Insert parent-table records before inserting records that reference them.

```sql
INSERT INTO Customer VALUES
(1, 'Rahul', 'rahul@gmail.com', 21),
(2, 'Aman', 'aman@gmail.com', 22),
(3, 'Om', 'om@gmail.com', 23);

INSERT INTO Seller VALUES
(1, 'Tech', 'Delhi'),
(2, 'Fashion Hub', 'Mumbai'),
(3, 'Gadget Zone', 'Bangalore');

INSERT INTO Category VALUES
(1, 'Electronics', 'Electronic products'),
(2, 'Clothing', 'Clothes and fashion'),
(3, 'Home', 'Home appliances');

INSERT INTO Product VALUES
(101, 'Laptop', 10, 55000.00, 1),
(102, 'T-shirt', 15, 799.00, 2),
(103, 'DBMS Book', 20, 650.00, 3);

INSERT INTO Payment VALUES
(201, 55000.00, '2026-09-01', 'UPI'),
(202, 799.00, '2026-09-02', 'UPI'),
(203, 650.00, '2026-09-03', 'Net Banking');

INSERT INTO Delivery VALUES
(301, 'Gurgaon', 'Haryana', '122001'),
(302, 'Mumbai', 'Maharashtra', '400001'),
(303, 'Pune', 'Maharashtra', '411016');

INSERT INTO Orders VALUES
(401, '2026-09-01', 55000.00, 1, 1, 201, 301),
(402, '2026-09-02', 799.00, 2, 2, 202, 302),
(403, '2026-09-03', 650.00, 3, 3, 203, 303);
```

## View the Results

```sql
SELECT * FROM Customer;
SELECT * FROM Seller;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Payment;
SELECT * FROM Delivery;
SELECT * FROM Orders;
```

To see order information together with related customer and seller details:

```sql
SELECT
    o.order_id,
    o.order_date,
    o.amount,
    c.name AS customer_name,
    s.name AS seller_name,
    p.method AS payment_method,
    d.city,
    d.state
FROM Orders AS o
JOIN Customer AS c ON o.customer_id = c.customer_id
JOIN Seller AS s ON o.seller_id = s.seller_id
JOIN Payment AS p ON o.payment_id = p.payment_id
JOIN Delivery AS d ON o.address_id = d.address_id;
```

## Constraints Demonstrated
- **PRIMARY KEY:** uniquely identifies each row in a table.
- **FOREIGN KEY:** ensures a referenced customer, seller, category, payment, or delivery address exists.
- **NOT NULL:** requires a value for designated columns.
- **UNIQUE:** prevents duplicate customer email addresses.
- **DEFAULT:** assigns a default quantity of `0` when no quantity is supplied.
- **ON DELETE CASCADE:** deleting a category deletes its related products; deleting a customer deletes that customer's orders in this schema.

## Referential Integrity Check
A foreign-key value must refer to an existing row in its parent table. For example, a product's `category_id` must exist in `Category`. Try inserting a product with a category ID that does not exist to see MySQL reject the row.

```sql
-- Example test (expected to fail if category_id 999 does not exist):
-- INSERT INTO Product
-- VALUES (104, 'Test Product', 1, 100.00, 999);
```

## Result
The e-commerce relational schema is created, sample records are inserted, and SQL constraints are used to maintain data consistency and referential integrity.

## Notes
- The handwritten experiment has a few inconsistent or unclear entries in the sample tables. The sample data above is normalized for consistency and uses valid foreign-key references.
- The schema shown here models one payment and one delivery address per order. A different ER diagram may require a separate order-item table if one order can contain multiple products.

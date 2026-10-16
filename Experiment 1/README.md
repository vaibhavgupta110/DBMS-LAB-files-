# E-Commerce Database — ER Diagram

## Overview

This experiment presents an Entity–Relationship (ER) diagram for a basic e-commerce system. It models customers placing orders, products offered by sellers, product categories, and the payment and delivery processes associated with orders.

## Entities and Attributes

The following entities and attributes are identified from the supplied diagram. Attribute names are transcribed from the handwritten drawing, so spelling or naming may need to be finalized when converting the ER model into tables.

| Entity | Attributes shown in the diagram |
|---|---|
| **Customer** | ID, Name, Email, Phone, DOB, Address |
| **Order** | ID, Order Date, Total Amount |
| **Seller** | ID, Phone, Email |
| **Category** | ID, Category Name |
| **Product** | ID, Name, Price, Description, Specification |
| **Order Item** | Order ID, Product ID (shown as related identifiers) |
| **Payment** | ID, Amount, Payment Mode, Date, Status |
| **Delivery** | ID, Date, Status, Tracking Number |

The diagram also shows product types such as **Books**, **Clothing**, and **Toys**.

## Relationships

- **Customer — Places — Order:** a customer places orders.
- **Order — Contains — Order Item:** an order is represented through its order-item entries.
- **Order Item — References — Product:** order items connect orders with the products purchased.
- **Seller — Sells — Product:** a seller sells products.
- **Product — Belongs To — Category:** products are grouped into categories.
- **Order — Payment:** an order is associated with payment information.
- **Order — Delivery:** an order is associated with delivery information.

## Suggested Relational Design

When implementing this ER model as a relational database, a possible table structure is:

- `Customer` — customer details, with `customer_id` as the primary key.
- `Seller` — seller contact details, with `seller_id` as the primary key.
- `Category` — category details, with `category_id` as the primary key.
- `Product` — product details and foreign keys referencing `Seller` and `Category`.
- `Orders` — order details and a foreign key referencing `Customer`.
- `OrderItem` — a junction table containing `order_id`, `product_id`, quantity, and item price (the last two fields are suggested additions, not shown in the diagram).
- `Payment` — payment details linked to an order.
- `Delivery` — delivery and tracking details linked to an order.

These table and key names are recommendations for implementation; the supplied drawing does not specify all primary keys, foreign keys, cardinalities, or constraints explicitly. Confirm those details before creating the database schema.

## Objective

To represent the main data entities and relationships required for a simple online shopping database and provide a starting point for converting an ER diagram into relational tables.

## Scope

This README documents the ER diagram supplied for the experiment. It does not claim that SQL tables, application code, or database operations have already been implemented.

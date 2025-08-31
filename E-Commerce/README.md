# E-Commerce Sales Analysis (SQL Project)

This project demonstrates how to design a small **E-Commerce Database** and perform **business analysis using SQL**.  
It covers everything from schema design, sample data insertion, and analytical queries that answer real-world business questions.

## Project Structure

1. Schema.sql   # Database schema (customers, products, orders)
2. Data.sql     # Sample dataset (customers, products, orders)
3. Queries.sql  # SQL queries & solutions (business insights)
4. README.md    # Project documentation


## Schema Overview

- **Customers Table**  
  Stores customer details including name, city, and membership type.

- **Products Table**  
  Contains product information such as category and price.

- **Orders Table**  
  Links customers with products, recording purchase date, quantity, and total amount.


## Sample Analysis Questions

The project includes queries for different levels:

### Basic Queries
- List all customers and their orders.
- Find all orders made in March 2024.

### Aggregate Queries
- Find the top 3 customers by total purchase amount.
- Calculate the average order value per customer.

### Window Functions
- Rank customers based on total spending.
- Calculate the average gap (in days) between consecutive orders.

### Business Insights
- Identify churned customers (no orders after March 2024).
- Find customers who purchased from **both Electronics and Fashion**.
- Determine the highest revenue product category.
- Show top 3 customers in each city based on spending.

## Usage
Run the files in this order:
1. `Schema.sql`
2. `Data.sql`
3. `Queries.sql`

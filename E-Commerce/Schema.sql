
create database `E-Commerce Sales Analysis`;
Use `E-Commerce Sales Analysis`;

create table customers
(customer_id  int primary key,
customer_name varchar(50),
city varchar(50),
membership varchar(50)
);

create table products
(product_id int primary key,
product_name  varchar(50),
category varchar(50),
price float
);

create table orders
(order_id int primary key,
customer_id INT,
product_id INT,
order_date  date,
quantity int,
amount int,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (product_id) REFERENCES products(product_id));

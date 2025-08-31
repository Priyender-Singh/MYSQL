
/* __________________________________________________ Stage 1: Basics __________________________________________________ */

/** Show all orders made by Alice. */
Select
o.customer_id as customer_id,
c.customer_name,
p.product_name
from customers c
Join orders o
On c.customer_id=o.customer_id
Join products p
On o.product_id=p.product_id
where c.customer_name="Alice";

/* List unique product categories purchased so far. */
select
distinct (p.category)
from products p
Join orders o
On p.product_id=o.product_id;

/* Get all customers who made orders in March 2024. */
select
o.customer_id,
c.customer_name,
o.order_date
from orders o
Join customers c
ON c.customer_id=o.customer_id
where Month(o.order_date)=3;

/* __________________________________________________ Stage 2: Joins & Aggregations __________________________________________________ */

/* Show each customer’s total spending. */
select
c.customer_id,
c.customer_name,
sum(o.amount) as total_spending
from customers c
Join orders o
On c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;

/* Find the most expensive product purchased by each customer. */
with customer_most_expensive_product as
(select
c.customer_id,
c.customer_name,
p.product_name,
p.price,
row_number() over (partition by c.customer_id order by p.price desc) as most_expensive_product
from customers c 
Join orders o ON c.customer_id=o.customer_id
Join products p ON o.product_id=p.product_id)
select
customer_id,
customer_name,
product_name,
price
from customer_most_expensive_product
where most_expensive_product=1;

/* List the top 3 customers by total purchase amount. */
select
c.customer_id,
c.customer_name,
sum(o.amount) as total_purchase_amount
from customers c
Join orders o ON c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
order by sum(o.amount) desc
limit 3;

/* __________________________________________________ Stage 3: Analytics & Window Functions __________________________________________________ */

/** Rank customers based on total spending (overall). */
select
c.customer_id,
c.customer_name,
sum(o.amount) as total_purchase_amount,
dense_rank() over (order by sum(o.amount) desc) as ranked_spending
from customers c
Join orders o ON c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;

/* For each city, show the top spender customer. */
with customer_total_spending as
(select
c.customer_id,
c.customer_name,
c.city,
sum(o.amount) as total_spending
from customers c
Join orders o ON c.customer_id=o.customer_id
group by c.customer_id,c.customer_name,c.city),
ranked_buyers as
(SELECT *,
RANK() OVER (partition by city order BY total_spending DESC) AS rnk
FROM customer_total_spending)
select *
from ranked_buyers
where rnk=1;

/** Find customers who spent more than the average spending across all customers. */
select
c.customer_id,
c.customer_name,
(select avg(amount) from orders) as avg_sales,
avg(o.amount) as customer_avg_sales
from customers c
Join orders o ON c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
having avg(o.amount)>(select avg(amount) from orders);

/* __________________________________________________ Stage 4: Real-World Business Insights __________________________________________________ */

/* Which product category brought in the highest revenue? */
select
p.category,
sum(o.amount) as total_spending
from orders o
Join products p ON o.product_id=p.product_id
group by p.category
order by sum(o.amount) desc
limit 1;

/* Find customers who purchased from both Electronics and Fashion categories. */
select
c.customer_id,
c.customer_name,
count(distinct p.category)
from customers c
Join orders o ON c.customer_id=o.customer_id
Join products p ON o.product_id=p.product_id
group by c.customer_id,c.customer_name
having count(distinct p.category)=2;

/* Identify customers who made at least 2 purchases in different months. */

/*  Interpretation 1 :- Atleast 2 orders but in but not in 1 month. */
select 
c.customer_id,
c.customer_name,
count(distinct Month(o.order_date)) as total_months
from customers c
Join orders o ON c.customer_id=o.customer_id
group by customer_id,customer_name
having count(distinct Month(o.order_date))>=2;


/* Interpretation 2 :-  if minimum 2 order in different month - in at least 2 different months */
with monthly_orders as (
select 
c.customer_id,
c.customer_name,
Month(o.order_date) as month_num,
count(o.order_id) as orders_in_month
from customers c
join orders o ON c.customer_id = o.customer_id
group by c.customer_id, c.customer_name, Month(o.order_date)
having count(o.order_id) >= 2   -- at least 2 purchases in that month
)
select 
    customer_id,
    customer_name
from monthly_orders
group by customer_id, customer_name
having count(distinct month_num) >= 2;  

/* Calculate the average gap in days between orders for each customer. */
with previous_order as
(select
c.customer_id,
c.customer_name,
o.order_date,
timestampdiff(day,Lag(o.order_date) over (partition by c.customer_id order by o.order_date),o.order_date) as gap_days
from customers c
join orders o ON c.customer_id = o.customer_id)
select
customer_id,
customer_name,
round(avg(gap_days),2) avg_gap_days
from previous_order
where gap_days is not null
group by customer_id,customer_name;

/** Find churned customers: those who didn’t order after March 2024. */
select
c.customer_id,
c.customer_name,
max(o.order_date) as last_order
from customers c
join orders o ON c.customer_id = o.customer_id
group by c.customer_id,c.customer_name
having last_order<="2024-03-31";

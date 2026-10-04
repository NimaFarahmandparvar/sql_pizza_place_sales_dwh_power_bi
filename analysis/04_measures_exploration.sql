/*
===================================================================
Measures Exploration
===================================================================
Purpose:
	This query explores 'product' dimension and 'fact' sales to 
	identify the overall trends using aggregated metrics (e.g. 
	total, average).
===================================================================
*/
-- How many pizzas are provided in different categories and sizes?
select
count(pizza_id) as total_pizzas
from gold.dim_product

-- What is the average price of pizzas?
select
	cast(avg(price) as decimal (10, 2)) as avg_price
from gold.dim_product

-- What is the total number of pizzas sold?
select
	sum(quantity) as total_pizzas_sold
from gold.fact_sales

-- What is the total number of orders?
select
	count(distinct order_id) as total_orders
from gold.fact_sales

-- How much is the total sales?
select
	sum(sales_amount) as total_sales
from gold.fact_sales

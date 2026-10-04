/*
===================================================================
Magnitude Analysis
===================================================================
Purpose:
	This query analyzes key measures across product dimensions.

Analysis:
	To analyze quantits, prices and sales of pizzas by their categories
	and sizes.
===================================================================
*/
-- How many pizzas does each category provide?
select
	category,
	count(pizza_id) as total_pizzas
from gold.dim_product
group by category
order by total_pizzas desc

-- What is the average price by each category?
select
	category,
	cast(avg(price) as decimal(10, 2)) as average_price
from gold.dim_product
group by category
order by average_price desc

-- What is the average price by each size?
select
	size,
	cast(avg(price) as decimal(10, 2)) as average_price
from gold.dim_product
group by size
order by average_price desc

-- what is the total number of pizzas sold by category?
select
	d.category,
	sum(quantity) as total_pizzas_sold
from gold.fact_sales as f
left join gold.dim_product as d
on d.pizza_key = f.pizza_key
group by category
order by total_pizzas_sold desc

-- what is the total number of pizzas sold by size?
select
	d.size,
	sum(quantity) as total_pizzas_sold
from gold.fact_sales as f
left join gold.dim_product as d
on d.pizza_key = f.pizza_key
group by size
order by total_pizzas_sold desc

-- what is the total number of pizzas sold by category and size?
select
	d.category,
	d.size,
	sum(quantity) as total_pizzas_sold
from gold.fact_sales as f
left join gold.dim_product as d
on d.pizza_key = f.pizza_key
group by category, size
order by total_pizzas_sold desc

-- what is the total sales of pizzas by category?
select
	d.category,
	sum(sales_amount) as total_sales
from gold.fact_sales as f
left join gold.dim_product as d
on d.pizza_key = f.pizza_key
group by category
order by total_sales desc

-- what is the total sales of pizzas by category and size ?
select
	d.category,
	d.size,
	sum(sales_amount) as total_sales
from gold.fact_sales as f
left join gold.dim_product as d
on d.pizza_key = f.pizza_key
group by category, size
order by total_sales desc

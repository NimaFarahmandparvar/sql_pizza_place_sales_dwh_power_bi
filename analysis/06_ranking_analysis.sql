/*
===================================================================
Ranking Analysis
===================================================================
Purpose:
	To identify and rank the pizzas and the categories by their 
	sales, prices and quantites sold.
===================================================================
*/
-- What are the top pizza categories in quantities sold?
select 
	category,
	sum(quantity) as total_pizzas,
	row_number() over(order by sum(quantity) desc) quantity_rank
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by category

-- Which pizzas are in top 5 sales?
select
	name,
	total_sales,
	top_sales_rank
from(
	select
		name,
		sum(sales_amount) as total_sales,
		row_number() over(order by sum(sales_amount) desc) as top_sales_rank
	from gold.fact_sales as f
	join gold.dim_product as d
	on f.pizza_key = d.pizza_key
	group by name
)u
where top_sales_rank <= 5

-- Which pizzas are in bottom 5 sales?
select
	name,
	total_sales,
	bottom_sales_rank
from(
	select
		name,
		sum(sales_amount) as total_sales,
		row_number() over(order by sum(sales_amount) asc) as bottom_sales_rank
	from gold.fact_sales as f
	join gold.dim_product as d
	on f.pizza_key = d.pizza_key
	group by name
)u
where bottom_sales_rank <= 5

-- Which pizzas are in top 10 expensive pizzas?
select
	name,
	category,
	size,
	price,
	high_price_rank
from(
	select
		name,
		category,
		size,
		price,
		dense_rank() over(order by price desc) as high_price_rank
	from gold.dim_product
)t
where high_price_rank <= 10

-- Which pizzas are in top 10 cheap pizzas?
select
	name,
	category,
	size,
	price,
	low_price_rank
from(
	select
		name,
		category,
		size,
		price,
		dense_rank() over(order by price asc) as low_price_rank
	from gold.dim_product
)t
where low_price_rank <= 10

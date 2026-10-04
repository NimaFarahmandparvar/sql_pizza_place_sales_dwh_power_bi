/*
===============================================================================
Part-to-whole Analysis
===============================================================================
Purpose:
    - To analyze the controbution of pizza categories to total sales and quantity.
===============================================================================
*/

-- To analyze each pizza category's contribution to total sales.
with total_analysis as (
select
 d.category,
 sum(f.sales_amount) as total_sales,
 sum(f.quantity) as total_quantity,
 avg(d.price) as average_price
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by d.category
)

select 
	category,
	total_sales,
	sum(total_sales) over() as all_categories_sales,
	cast(total_sales * 100 / sum(total_sales) over() as decimal(10, 2)) as sales_percentage
from total_analysis
order by total_sales desc;
go

-- To analyze each pizza category's contribution to total quantity.
with total_analysis as (
select
 d.category,
 sum(f.sales_amount) as total_sales,
 sum(f.quantity) as total_quantity,
 avg(d.price) as average_price
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by d.category
)

select
	category,
	total_quantity,
	sum(total_quantity) over() as all_categories_quantity,
	cast(cast(total_quantity as decimal(10, 2)) * 100 / sum(total_quantity) over() as decimal(10, 2)) as quantity_percentage
from total_analysis
order by total_quantity desc;
go


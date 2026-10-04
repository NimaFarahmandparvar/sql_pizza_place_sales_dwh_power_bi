/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This query creates a report about products as a view in the 'gold' layer
	  which calculates key product indexes.
	- To calculate metrics such as:
		1. Total and monthly quantities sold by product category.
		2. Total and monthly sales by product category.
		3. Total and monthly quantities sold by product name.
		4. Total and monthly sales by product name.
		5. Total and monthly quantities sold by product name and size.
		6. Total and monthly sales by product name and size.
===============================================================================
*/

if object_id ('gold.report_product', 'V') is not null
drop view gold.report_product;
go

create view report_product as

with product_analysis as (
	select
		f.date,
		d.name,
		d.category,
		d.size,
		f.unit_price,
		f.quantity,
		f.sales_amount
	from gold.fact_sales as f
	join gold.dim_product as d
	on f.pizza_key = d.pizza_key
)

, product_aggregation as (
	select
		month(date) as month,
		name,
		category,
		size,
		quantity,
		unit_price,

		sum(quantity) over(partition by category) as total_category_quantity,
		sum(sales_amount) over(partition by category) as total_category_sales,

		sum(quantity) over(partition by name) as total_name_quantity,
		sum(sales_amount) over(partition by name) as total_name_sales,

		sum(quantity) over(partition by name, size) as total_name_size_quantity,
		sum(sales_amount) over(partition by name, size) as total_name_size_sales,

		sales_amount
	from product_analysis
)

select
		month,
		name,
		category,
		size,
		unit_price,

		total_category_quantity,
		sum(quantity) over(partition by category, month) as monthly_category_quantity,
		total_category_sales,
		sum(sales_amount) over(partition by category, month) as monthly_category_sales,

		total_name_quantity,
		sum(quantity) over(partition by name, month) as monthly_name_quantity,
		total_name_sales,
		sum(sales_amount) over(partition by name, month) as monthly_name_sales,

		total_name_size_quantity,
		sum(quantity) over(partition by name, size, month) as monthly_name_size_quantity,
		total_name_size_sales,
		sum(sales_amount) over(partition by name, size, month) as monthly_name_size_sales
from product_aggregation


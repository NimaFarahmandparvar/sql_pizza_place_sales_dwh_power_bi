/*
===================================================================
Change-over-time Analysis
===================================================================
Purpose:
	This query analyzes key metrics over time in order to track
	trends, growth and changes over time.
===================================================================
*/
-- To analyze sales performance over time.
select
	datetrunc(month, date) as month,
	count(distinct order_id) as total_orders,
	sum(quantity) as total_quantity,
	sum(sales_amount) as total_sales
from gold.fact_sales
group by datetrunc(month, date)
order by datetrunc(month, date)

-- Monthly average of sales and quantity sold.
select
	avg(total_orders) as monthly_average_order,
	avg(total_quantity) as monthly_average_quantity,
	cast(avg(total_sales) as decimal(10, 2)) as monthly_average_sales
from(
	select
		datetrunc(month, date) as month,
		count(distinct order_id) as total_orders,
		sum(quantity) as total_quantity,
		sum(sales_amount) as total_sales
	from gold.fact_sales
	group by datetrunc(month, date)
)t

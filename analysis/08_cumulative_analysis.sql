/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running total and running average for sales.
    - To track performance over time cumulatively.
===============================================================================
*/

-- Calculating running total and running average sales per month.
select
	month,
	total_sales,
	sum(total_sales) over(order by month rows between unbounded preceding and current row) as running_total,
	cast(avg(total_sales) over(order by month rows between unbounded preceding and current row) as decimal(10, 2)) as running_average
from(
	select
		datetrunc(month, date) as month,
		sum(sales_amount) as total_sales
	from gold.fact_sales
	group by datetrunc(month, date)
)t
group by month, total_sales

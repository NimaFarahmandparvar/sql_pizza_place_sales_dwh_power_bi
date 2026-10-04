/*
===================================================================
Date Range Exploration
===================================================================
Purpose:
	This query explores the date range of 'sales' fact to identify
	the first and the last orders in date and time.

Analysis:
	-- To identify the earliest and the latest date of orders.
	-- To identify the earliest and the latest time of orders.
	-- To identify the date and time of the first and the last orders.
===================================================================
*/

-- What is the first and the last order date?
select
	min(date) as first_order_date,
	max(date) as last_order_date
from gold.fact_sales

-- What is the first and the last order time?
select
	cast(min(time) as time(0)) as first_order_time,
	cast(max(time) as time(0)) as last_order_time
from gold.fact_sales


-- what is the date and time of the first and the last orders?
select
	min(cast(concat(date, ' ', time) as datetime2(0))) as first_order_datetime,
	max(cast(concat(date, ' ', time) as datetime2(0))) as last_order_datetime
from gold.fact_sales

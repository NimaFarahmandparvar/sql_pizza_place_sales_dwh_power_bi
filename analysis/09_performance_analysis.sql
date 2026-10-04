/*
===============================================================================
Performance Analysis
===============================================================================
Purpose:
    - To measure the performance of pizzas month-over-month with and without 
	  size.
    - To track monthly trends and growth in terms of sales and quantity.
===============================================================================
*/

/*
-------------------------------------------------------------------------------
Pizzas' Performance Analysis In Terms of Sales
-------------------------------------------------------------------------------
*/
-- To analyze each pizza's month-over-month performance in terms of sales with their size.
with monthly_sales as (
select
	month(date) as month,
	d.name,
	d.category,
	d.size,
	sum(f.quantity) as current_month_quantity,
	sum(f.sales_amount) as current_month_sales
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by month(date),
         name,
		 category,
		 size
)

select
	month, 
	name, 
	category, 
	size,
	current_month_sales,
	lag(current_month_sales) over(partition by name, category, size order by month) as previous_month_sales,

	case when current_month_sales - lag(current_month_sales) over(partition by name, category, size order by month) < 0 then 'Decrease'
	     when current_month_sales - lag(current_month_sales) over(partition by name, category, size order by month) > 0 then 'Increase'
		 else 'No Change'
	end as monthly_sales_change,

	cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) as monthly_average_sales,
	current_month_sales - cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) as average_sales_difference,
	case when current_month_sales - cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) < 0 then 'Below Average'
		 when current_month_sales - cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) > 0 then 'Above Average'
		 else 'Average'
	end as average_sales_change
from monthly_sales
order by  name, category, size, month; 
go


-- To analyze each pizza's month-over-month performance in terms of sales without their size.
with monthly_sales as (
select
	month(date) as month,
	d.name,
	d.category,
	sum(f.quantity) as current_month_quantity,
	sum(f.sales_amount) as current_month_sales
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by month(date),
         name,
		 category
)

select
	month, 
	name, 
	category,
	current_month_sales,
	lag(current_month_sales) over(partition by name, category order by month) as previous_month_sales,

	case when current_month_sales - lag(current_month_sales) over(partition by name, category order by month) < 0 then 'Decrease'
	     when current_month_sales - lag(current_month_sales) over(partition by name, category order by month) > 0 then 'Increase'
		 else 'No Change'
	end as monthly_sales_change,

	cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) as monthly_average_sales,
	current_month_sales - cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) as average_sales_difference,
	case when current_month_sales - cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) < 0 then 'Below Average'
		 when current_month_sales - cast(avg(current_month_sales) over(partition by name, category) as decimal(10, 2)) > 0 then 'Above Average'
		 else 'Average'
	end as average_sales_change
from monthly_sales
order by  name, category, month; 
go

/*
-------------------------------------------------------------------------------
Pizzas' Performance Analysis In Terms of Quantity
-------------------------------------------------------------------------------
*/
-- To Analyze pizzas' performance in terms of quantity with their size.
with monthly_sales as (
select
	month(date) as month,
	d.name,
	d.category,
	d.size,
	sum(f.quantity) as current_month_quantity,
	sum(f.sales_amount) as current_month_sales
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by month(date),
         name,
		 category,
		 size
)

select
	month, 
	name, 
	category, 
	size,
	current_month_quantity,
	lag(current_month_quantity) over(partition by name, category, size order by month) as previous_month_quantity,
	current_month_quantity - lag(current_month_quantity) over(partition by name, category, size order by month) as monthly_quantity_difference,

	case when current_month_quantity - lag(current_month_quantity) over(partition by name, category, size order by month) < 0 then 'Decrease'
	     when current_month_quantity - lag(current_month_quantity) over(partition by name, category, size order by month) > 0 then 'Increase'
		 else 'No Change'
	end as monthly_quantity_change,

	avg(current_month_quantity) over(partition by name, category) as monthly_average_quantity,
	current_month_quantity - avg(current_month_quantity) over(partition by name) as average_quantity_difference,

	case when current_month_quantity - avg(current_month_quantity) over(partition by name, category, size) < 0 then 'Below Average'
	     when current_month_quantity - avg(current_month_quantity) over(partition by name, category, size) > 0 then 'Above Average'
		 else 'Average'
	end as average_quantity_change
from monthly_sales
order by name, category, size, month;
go

-- To Analyze pizzas' performance in terms of quantity without their size.
with monthly_sales as (
select
	month(date) as month,
	d.name,
	d.category,
	sum(f.quantity) as current_month_quantity,
	sum(f.sales_amount) as current_month_sales
from gold.fact_sales as f
join gold.dim_product as d
on f.pizza_key = d.pizza_key
group by month(date),
         name,
		 category
		 
)

select
	month, 
	name, 
	category,
	current_month_quantity,
	lag(current_month_quantity) over(partition by name, category order by month) as previous_month_quantity,
	current_month_quantity - lag(current_month_quantity) over(partition by name, category order by month) as monthly_quantity_difference,

	case when current_month_quantity - lag(current_month_quantity) over(partition by name, category order by month) < 0 then 'Decrease'
	     when current_month_quantity - lag(current_month_quantity) over(partition by name, category order by month) > 0 then 'Increase'
		 else 'No Change'
	end as monthly_quantity_change,

	avg(current_month_quantity) over(partition by name, category) as monthly_average_quantity,
	current_month_quantity - avg(current_month_quantity) over(partition by name, category) as average_quantity_difference,

	case when current_month_quantity - avg(current_month_quantity) over(partition by name, category) < 0 then 'Below Average'
	     when current_month_quantity - avg(current_month_quantity) over(partition by name, category) > 0 then 'Above Average'
		 else 'Average'
	end as average_quantity_change
from monthly_sales
order by name, category, month

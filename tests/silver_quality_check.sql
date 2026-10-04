/*
==========================================================
-- Silver Tables Quality Checks
==========================================================
*/

-- Checking Tables Rows

with silver_tables_rows as (
	select
		'product_pizza_types' as table_name,
		count(*) as total_rows
	from silver.product_pizza_types 

	union all

	select
		'product_pizzas',
		count(*) 
	from silver.product_pizzas

	union all

	select
		'sales_orders',
		count(*)
	from silver.sales_orders

	union all

	select
		'sales_order_details',
		count(*)
	from silver.sales_order_details
)

,bronze_tables_rows as (
	select
		'product_pizza_types' as table_name,
		count(*) as total_rows
	from bronze.product_pizza_types
	

	union all

	select
		'product_pizzas',
		count(*)
	from bronze.product_pizzas

	union all

	select
		'sales_orders',
		count(*)
	from bronze.sales_orders

	union all

	select
		'sales_order_details',
		count(*) 
	from bronze.sales_order_details
)

select
	sr.table_name,
	br.total_rows as bronze_tables_rows,
	sr.total_rows as silver_tables_rows,
	sr.total_rows - br.total_rows as rows_difference,
	case
		when sr.total_rows = br.total_rows
			then 'Pass'
		else 'Check'
	end as quality_check
from bronze_tables_rows br
join silver_tables_rows sr
on sr.table_name = br.table_name;
go

----------------------------------------------------------
-- Checking Unwanted Spaces
-- Expectation: No Results
select
	pizza_type_id,
	name,
	category,
	ingredients
from silver.product_pizza_types
where pizza_type_id != trim(pizza_type_id)
   or name != trim(name)
   or category != trim(category)
   or ingredients != trim(ingredients);

select 
	pizza_id,
	pizza_type_id,
	size
from silver.product_pizzas
where pizza_id != trim(pizza_id)
   or pizza_type_id != trim(pizza_type_id)
   or size != trim(size);

select
	pizza_id
from silver.sales_order_details
where pizza_id != trim(pizza_id);
go

----------------------------------------------------------

-- Checking for Nulls and Duplicates
-- Expectation: No Results
select
	pizza_type_id,
	count(*) as duplicate_or_null
from silver.product_pizza_types
group by pizza_type_id
having count(*) != 1 or count(*) is null;

select
	pizza_id,
	count(*) as duplicate_or_null
from silver.product_pizzas
group by pizza_id
having count(*) != 1 or count(*) is null;

select
	order_id,
	count(*) as duplicate_or_null
from silver.sales_orders
group by order_id
having count(*) != 1 or count(*) is null;

select
	order_details_id,
	count(*) as duplicate_or_null
from silver.sales_order_details
group by order_details_id
having count(*) != 1 or count(*) is null;
go

----------------------------------------------------------
-- Check Numeric Values
-- Expectation: No Results
select
	price
from silver.product_pizzas
where price is null or price <= 0;

select
	quantity
from silver.sales_order_details
where quantity is null or quantity <= 0;
go

----------------------------------------------------------
-- Data Standardization and Normalization
-- Expectation: No Results
select
	name,
	category,
	ingredients
from silver.product_pizza_types
where name like '%+%' 
   or name like '%;%'
   or category like '%Veggie%'
   or ingredients like '%;%'
   or ingredients like '%æNduja%';

select 
	size
from silver.product_pizzas
where size not in (
	'Small',
	'Medium',
	'Large',
	'Extra Large',
	'Double Extra Large'
);

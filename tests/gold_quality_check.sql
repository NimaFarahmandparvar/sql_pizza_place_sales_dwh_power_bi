/*
==========================================================
-- Gold Tables Quality Checks
==========================================================
*/

-- Checking Unwanted Spaces
-- Expectation: No Results
select
	pizza_id,
	pizza_type_id,
	name,
	category,
	size,
	ingredients
from gold.dim_product
where pizza_id != trim(pizza_id)
   or pizza_type_id != trim(pizza_type_id)
   or name != trim(name)
   or category != trim(category)
   or ingredients != trim(ingredients);

select
	pizza_id,
	pizza_type_id
from gold.fact_sales
where pizza_id != trim(pizza_id)
   or pizza_type_id != trim(pizza_type_id);
go

----------------------------------------------------------
-- Checking for Nulls and Duplicates
-- Expectation: No Results
select
	pizza_key,
	count(*) as duplicates_or_nulls
from gold.dim_product
group by pizza_key
having count(*) != 1 or count(*) is null;
go

----------------------------------------------------------
-- Check Numeric Values
-- Expectation: No Results
select
	price
from gold.dim_product
where price is null or price <= 0;

select
	quantity
from gold.fact_sales
where quantity is null or quantity <= 0;
go

----------------------------------------------------------
-- Data Standardization and Normalization
-- Expectation: No Results
select
	name,
	category,
	ingredients
from gold.dim_product
where name like '%+%' 
   or name like '%;%'
   or category like '%Veggie%'
   or ingredients like '%;%'
   or ingredients like '%æNduja%';

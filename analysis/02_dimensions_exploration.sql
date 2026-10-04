/*
===================================================================
Dimensions Exploration
===================================================================
Purpose:
	This query explores the 'product' dimention to identify the 
	types, categories and sizes of pizzas.
===================================================================
*/

-- What pizzas are provided and what categories do they belong to?
select
	name,
	category
from gold.dim_product
group by category, name

-- What are the categories of pizzas?
select distinct
	category
from gold.dim_product

-- In which sizes are pizzas provided?
select distinct
	size
from gold.dim_product

-- What sizes does each category provide?
select
	category,
	size
from gold.dim_product
group by category, size
order by category, size

-- Which ingredients does each pizza have?
select
	name,
	ingredients
from gold.dim_product
group by name, ingredients

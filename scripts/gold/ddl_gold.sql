/*
==========================================================
-- Creating Gold Tables
==========================================================
-- Script Purpose:
	This script checks whether these tables exist, and if
	they exist, it will drop them. Then, recreates the 
	tables.

--Note:
	Drop order:
		gold.fact_sales (child table)
		gold.dim_product (parent table)

	Create order:
		gold.dim_product (parent table)
		gold.fact_sales (child table)
-----------------------------------------------------------
*/

if object_id('gold.fact_sales', 'U') is not null
drop table gold.fact_sales;
go

if object_id('gold.dim_product', 'U') is not null
drop table gold.dim_product;
go


create table gold.dim_product (
	pizza_key int identity(1, 1) not null,
	pizza_id nvarchar(50),
	pizza_type_id nvarchar(50),
	name nvarchar(50),
	category nvarchar(50),
	size nvarchar(50),
	price decimal(10, 2),
	ingredients nvarchar(1000)

	constraint PK_dim_product
		primary key(pizza_key)
);
go


create table gold.fact_sales (
	sales_key int identity(1, 1) not null,
	pizza_key int,
	order_details_id int,
	order_id int,
	pizza_id nvarchar(50),
	pizza_type_id nvarchar(50),
	date date,
	time time,
	quantity int,
	unit_price decimal(10, 2),
	sales_amount decimal(10, 2)
	
	constraint PK_fact_sales_sales_key
		primary key (sales_key)

	constraint FK_fact_sales_dim_product
		foreign key (pizza_key)
		references gold.dim_product(pizza_key),
);
go

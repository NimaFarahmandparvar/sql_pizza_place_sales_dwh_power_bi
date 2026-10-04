/*
=============================================================
DDL Script: Creating Silver Tables
=============================================================
Script Purpose:
	This script creates tables in the 'silver' schema after 
	it ensures there is not the same table and if there is 
	a table, it will drop it.

Note:
	If you already have these tables and intend to recreate 
	the 'silver' schema tables, you must drop child tables
	(tables with foreign keys) then drop parent tables
	(tables with columns which are referenced as foreign keys 
	in the child tables). For creating tables you must create
	the parent tables first and then create the child tables.
	Drop and craete tables in this order:
		Drop Order:
			silver.sales_order_details (child table)
			silver.product_pizzas (child table)
			silver.sales_orders (parent table)
			silver.product_pizza_types (parent table)

		Create Order:
			silver.product_pizza_types (parent table)
			silver.product_pizzas (parent table)
			silver.sales_orders (parent table)
			silver.sales_order_details (parent table)
=============================================================
*/
-------------------------------------------------------------
-- Drop Tables
-------------------------------------------------------------
if object_id('silver.sales_order_details', 'U') is not null
drop table silver.sales_order_details;
go

if object_id('silver.product_pizzas', 'U') is not null
drop table silver.product_pizzas;
go

if object_id('silver.sales_orders', 'U') is not null
drop table silver.sales_orders;
go

if object_id('silver.product_pizza_types', 'U') is not null
drop table silver.product_pizza_types;
go

-------------------------------------------------------------
-- Create Tables
-------------------------------------------------------------
create table silver.product_pizza_types (
	pizza_type_id nvarchar(50),
	name nvarchar(50),
	category nvarchar(50),
	ingredients nvarchar(1000),
	dwh_create_date datetime2 default getdate()

	constraint PK_product_pizza_type primary key (pizza_type_id)
);
go

create table silver.product_pizzas (
	pizza_id nvarchar(50),
	pizza_type_id nvarchar(50),
	size nvarchar(50),
	price decimal(10, 2),
	dwh_create_date datetime2 default getdate()

	constraint PK_product_pizza primary key(pizza_id)

	constraint FK_product_pizza_type
		foreign key(pizza_type_id)
		references silver.product_pizza_types(pizza_type_id)
);
go

create table silver.sales_orders (
	order_id int,
	date date,
	time time,
	dwh_create_date datetime2 default getdate()

	constraint PK_sales_order primary key(order_id)
);
go

create table silver.sales_order_details (
	order_details_id int,
	order_id int,
	pizza_id nvarchar(50) ,
	quantity int,
	dwh_create_date datetime2 default getdate()
	
	constraint PK_sales_order_details primary key(order_details_id)

	constraint FK_sales_order
		foreign key (order_id)
		references silver.sales_orders(order_id),
	constraint FK_product_pizzas
		foreign key (pizza_id)
		references silver.product_pizzas(pizza_id)
);
go

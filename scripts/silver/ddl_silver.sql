/*
=============================================================
DDL Script: Creating Silver Tables
=============================================================
Script Purpose:
	This script creates tables in the 'silver' schema after 
	it ensures there is not the same table and if there is 
	a table, it will drop it.
=============================================================
*/

if object_id('silver.product_pizza_types', 'U') is not null
drop table silver.product_pizza_types;
go
create table silver.product_pizza_types (
	pizza_type_id nvarchar(50),
	name nvarchar(50),
	category nvarchar(50),
	ingredients nvarchar(1000),
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.product_pizzas', 'U') is not null
drop table silver.product_pizzas;
go
create table silver.product_pizzas (
	pizza_id nvarchar(50),
	pizza_type_id nvarchar(50),
	size nvarchar(50),
	price decimal(10, 2),
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.sales_orders', 'U') is not null
drop table silver.sales_orders;
go
create table silver.sales_orders (
	order_id int,
	date date,
	time time,
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.sales_order_details', 'U') is not null
drop table silver.sales_order_details;
go
create table silver.sales_order_details (
	order_details_id int,
	order_id int,
	pizza_id nvarchar(50) ,
	quantity int,
	dwh_create_date datetime2 default getdate()
);
go

/*
=============================================================
DDL Script: Creating Bronze Tables
=============================================================
Script Purpose:
	This scripts creates the tables of the bronze layer after
	checking whether the same tables exist.
=============================================================
*/
-------------------------------------------------------------
--Creating 'pizza_types' Table from the 'product' source.
-------------------------------------------------------------
if object_id('bronze.product_pizza_types', 'U') is not null
drop table bronze.product_pizza_types;
go

create table bronze.product_pizza_types (
	pizza_type_id nvarchar(50),
	name nvarchar(50),
	category nvarchar(50),
	ingredients nvarchar(1000)
);
go

-------------------------------------------------------
--Creating 'pizza' Table from the 'product' source.
-------------------------------------------------------
if object_id('bronze.product_pizzas', 'U') is not null
drop table bronze.product_pizzas;
go

create table bronze.product_pizzas (
	pizza_id nvarchar(50),
	pizza_type_id nvarchar(50),
	size nvarchar(50),
	price nvarchar(50)
);
go

-------------------------------------------------------
--Creating 'orders' Table from the 'sales' source.
-------------------------------------------------------
if object_id('bronze.sales_orders', 'U') is not null
drop table bronze.sales_orders;
go

create table bronze.sales_orders (
	order_id int,
	date nvarchar(50),
	time nvarchar(50)
);
go

---------------------------------------------------------------
--Creating 'order_details' Table from the 'sales' source.
---------------------------------------------------------------
if object_id('bronze.sales_order_details', 'U') is not null
drop table bronze.sales_order_details;
go

create table bronze.sales_order_details (
	order_details_id int,
	order_id int,
	pizza_id nvarchar(50),
	quantity int
);
go

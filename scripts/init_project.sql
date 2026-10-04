/*
====================================================================
Creating Database and Schemas
====================================================================
Script Purpose:
	This script first checks whether the database'PizzaSalesDW' 
	already exists, drops it if it does and then creates the 
	database anew. Afterwards, it creates three schemas named 
	'bronze', 'silver' and 'gold'.

Warning:
	Running this script will delete permanently the entire 
	'PizzaSalesDW' database if it exists. In case you already have 
	a database named 'PizzaSalesDW', please ensure you have a backup
	of it.
*/

use master;
go 

if exists(select 1 from sys.databases where name = 'PizzaSalesDW')
begin
	alter database PizzaSalesDW set single_user with rollback immediate;
	drop database PizzaSalesDW;
end;
go

create database PizzaSalesDW;
go

use PizzaSalesDW;
go

create schema bronze;
go

create schema silver;
go

create schema gold;
go

/*
===================================================================
Database Exploration
===================================================================
Purpose:
	This query explores the PizzaSalesDW database to understand
	the 'gold' schema and its tables and their columns.

Analysis:
	-- Identify the 'gold' schema and their tables.
	-- Identify the columns of tables.
===================================================================
*/

select
*
from INFORMATION_SCHEMA.TABLES
where table_schema = 'gold'

select
	TABLE_CATALOG,
	TABLE_SCHEMA,
	TABLE_NAME,
	COLUMN_NAME,
	ORDINAL_POSITION,
	DATA_TYPE
from INFORMATION_SCHEMA.columns
where table_schema = 'gold'
 

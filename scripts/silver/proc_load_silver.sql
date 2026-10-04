/*
=================================================================
Stored Procedure: Loading The Silver Layer
=================================================================
Scrip Purpose:
	This script includes one stored procedure which performs
	ETL (Exract, Transform, Load) process to populate
	'silver' schema tables from the 'bronze' schema. 
	Furthermore, it calculates the duration of tables 
	truncation and insertion.

Parameters: 
	None.
		This stored procedure does not accept any parameters or 
		return any values.

Usage Example:
	Exec silver.load_silver
=================================================================
*/

create or alter procedure silver.load_silver as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		set @start_time = getdate();

		print '==================================================';
		print '>> Loading The Silver layer';
		print '==================================================';

		print '--------------------------------------------------';
		print '>> Truncating Tables';
		print '--------------------------------------------------';

		truncate table silver.sales_order_details;
		truncate table silver.product_pizzas;
		truncate table silver.sales_orders;
		truncate table silver.product_pizza_types;

		set @end_time = getdate();
		print '>> Truncating Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';

		set @start_time = getdate();
		print '--------------------------------------------------';
		print '>> Inserting Data Into Tables';
		print '--------------------------------------------------';
		
		insert into silver.product_pizza_types (
			pizza_type_id,
			name,
			category,
			ingredients
		)
		select
			pizza_type_id,
			replace(replace(name, '+', 'and'), ';', ',') as name,
			replace(category, 'Veggie', 'Vegetable') as category,
			replace(replace(ingredients, ';', ','), 'æNduja', 'Nduja')
		from bronze.product_pizza_types;
		

		insert into silver.product_pizzas (
			pizza_id,
			pizza_type_id,
			size,
			price
		)
		select
			pizza_id,
			pizza_type_id,
			case
				when upper(trim(size)) = 'S' then 'Small'
				when upper(trim(size)) = 'M' then 'Medium'
				when upper(trim(size)) = 'L' then 'Large'
				when upper(trim(size)) = 'XL' then 'Extra Large'
				when upper(trim(size)) = 'XXL' then 'Double Extra Large'
				else upper(trim(size))
			end as size,
			price
		from bronze.product_pizzas;
		

		insert into silver.sales_orders (
			order_id,
			date,
			time
		)
		select 
			order_id,
			date,
			time
		from bronze.sales_orders;
		

		insert into silver.sales_order_details (
			order_details_id,
			order_id,
			pizza_id,
			quantity
		)
		select
			order_details_id,
			order_id,
			pizza_id,
			quantity
		from bronze.sales_order_details;

		set @end_time = getdate();
		print '>> Inserting Data Into Tables Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';
		set @batch_end_time = getdate();
		print '--------------------------------------------------';
		print '>> Loading The Silver layer Completed';
		print '>> Loading The Silver layer Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
	end try
	begin catch
		print '==================================================';
		print 'AN ERROR HAS ECCURED';
		print 'ERROR MESSAGE: ' + error_message();
		print 'ERROR LINE: ' + error_line();
		print 'ERROR NUMBER: ' + cast(error_number() as nvarchar);
		print '==================================================';
	end catch
end
		
		


	
		

	

/*
=================================================================
Stored Procedure: Loading The Bronze Layer
=================================================================
Scrip Purpose:
	This script includes one stored procedure which bulk inserts
	data from external CSV files into the Bronze schema tables. 
	Furthermore, it calculates the duration of each table 
	truncation and insertion.

Parameters: 
	None.
		This stored procedure does not accept any parameters or 
		return any values.

Usage Example:
	Exec bronze.load_bronze
=================================================================
*/

create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		set @start_time = getdate();

		print '==================================================';
		print '>> Loading The Bronze layer';
		print '==================================================';

		print '--------------------------------------------------';
		print '>> Loading Product Tables';
		print '--------------------------------------------------';

		print '>> Truncating Table: product_pizza_types';
		truncate table bronze.product_pizza_types;
		print '>> Inserting Data Into: product_pizza_types';
		bulk insert bronze.product_pizza_types 
			from 'D:\NarmAfzar\Microsoft SQL Server 2022\Projects\Pizza Restaurant\dataset\pizza_sales\product\pizza_types.csv'
			with (
				FirstRow = 2,
				FieldTerminator = ',',
				tablock
		);
		set @end_time = getdate();
		print '>> Loading Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';

		set @start_time = getdate();
		print '>> Truncating Table: product_pizzas';
		truncate table bronze.product_pizzas;
		print '>> Inserting Data Into: product_pizzas';
		bulk insert bronze.product_pizzas 
			from 'D:\NarmAfzar\Microsoft SQL Server 2022\Projects\Pizza Restaurant\dataset\pizza_sales\product\pizzas.csv'
			with (
				FirstRow = 2,
				FieldTerminator = ',',
				tablock
		);
		set @end_time = getdate();
		print '>> Loading Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';

		set @start_time = getdate();
		print '--------------------------------------------------';
		print '>> Loading Product Tables';
		print '--------------------------------------------------';
		print '>> Truncating Table: sales_order_details';
		truncate table bronze.sales_order_details;
		print '>> Inserting Data Into: sales_order_details';
		bulk insert bronze.sales_order_details 
			from 'D:\NarmAfzar\Microsoft SQL Server 2022\Projects\Pizza Restaurant\dataset\pizza_sales\sales\order_details.csv'
			with (
				FirstRow = 2,
				FieldTerminator = ',',
				tablock
		);
		set @end_time = getdate();
		print '>> Loading Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';

		set @start_time = getdate();
		print '>> Truncating Table: sales_orders';
		truncate table bronze.sales_orders;
		print '>> Inserting Data Into: sales_orders';
		bulk insert bronze.sales_orders 
			from 'D:\NarmAfzar\Microsoft SQL Server 2022\Projects\Pizza Restaurant\dataset\pizza_sales\sales\orders.csv'
			with (
				FirstRow = 2,
				FieldTerminator = ',',
				tablock
		);
		set @end_time = getdate();
		print '>> Loading Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';
		set @batch_end_time = getdate();
		print '--------------------------------------------------';
		print '>> Loading The Bronze layer Completed';
		print '>> Loading The Bronze layer Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
	end try

	begin catch
		print '==================================================';
		print 'AN ERROR HAS ECCURED';
		print 'ERROR MESSAGE: ' + error_message();
		print 'ERROR NUMBER: ' + cast(error_number() as nvarchar);
		print '==================================================';
	end catch
end

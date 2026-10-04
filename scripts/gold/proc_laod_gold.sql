/*
=================================================================
Stored Procedure: Loading The Gold Layer
=================================================================
Scrip Purpose:
	This script includes one stored procedure which deletes the
	existing dimesional and fact tables, then recreates them
	using the silver tables and aggregated columns. Furthermore,
	it calculates the duration of tables truncation and insertion.

Parameters: 
	None.
		This stored procedure does not accept any parameters or 
		return any values.

Usage Example:
	Exec gold.load_gold
=================================================================
*/
create or alter procedure gold.load_gold as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		set @start_time = getdate();

		print '==================================================';
		print '>> Loading The Gold layer';
		print '==================================================';

		print '--------------------------------------------------';
		print '>> Deleting Tables';
		print '--------------------------------------------------';

		delete from gold.fact_sales;
		delete from gold.dim_product;

		set @end_time = getdate();
		print '>> Deleting Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';

		set @start_time = getdate();
		print '--------------------------------------------------';
		print '>> Inserting Data Into Tables';
		print '--------------------------------------------------';
		

		insert into gold.dim_product (
			pizza_id,
			pizza_type_id,
			name,
			category,
			size,
			price,
			ingredients
		)

		select
			pp.pizza_id,
			pt.pizza_type_id,
			pt.name,
			pt.category,
			pp.size,
			pp.price,
			pt.ingredients
		from silver.product_pizzas pp
		left join silver.product_pizza_types pt
		on pp.pizza_type_id = pt.pizza_type_id

		insert into gold.fact_sales (
			pizza_key,
			order_details_id,
			order_id,
			pizza_id,
			pizza_type_id,
			date,
			time,
			quantity,
			unit_price,
			sales_amount
		)
		select
			dp.pizza_key,
			od.order_details_id,
			so.order_id,
			dp.pizza_id,
			dp.pizza_type_id,
			so.date,
			so.time,
			od.quantity,
			price as unit_price,
			quantity * price as sales_amount
		from silver.sales_order_details od
		left join silver.sales_orders so
		on od.order_id = so.order_id
		left join gold.dim_product dp
		on od.pizza_id = dp.pizza_id

		set @end_time = getdate();
		print '>> Inserting Data Into Tables Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '--------------------------------------------------';
		set @batch_end_time = getdate();
		print '--------------------------------------------------';
		print '>> Loading The Gold layer Completed';
		print '>> Loading The Gold layer Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
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

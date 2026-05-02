-- Finding Total Sales

select 
	SUM(fs.sales_amount) as total_sales
from fact_sales fs 


-- Finding how many items are sold

select
	SUM(fs.quantity) as total_qty_sold
from fact_sales fs 


-- Finding avg Selling Price

select
	ROUND(AVG(fs.price),2) as avg_selling_price
from fact_sales fs 


-- Finding the total number of orders

select
	COUNT(DISTINCT fs.order_number ) as total_orders -- Eliminates duplicates orders as one order can have multiple qty of other items which will each have a different row.
from fact_sales fs 


-- Finding the total number of products

select
	COUNT(dp.product_id ) as total_products
from dim_products dp  


-- Finding the total number of customers

select
	COUNT(dc.customer_key ) as total_customers
from dim_customers dc   



-- Finding the total number of customers that has placed an order


select
	COUNT(distinct fs.customer_key ) as converted_customers
from fact_sales fs 


-- Generating a report for all the key metrics of the business

select
	'Total Sales' as measure_name, SUM(fs.sales_amount) as measure_value from fact_sales fs
union all
select	
	'Total Quantity' as measure_name, SUM(fs.quantity) as measure_value from fact_sales fs 
union all
select 
	'Average Price' as measure_name,	ROUND(AVG(fs.price),2) as measure_value from fact_sales fs 
union all
select	
	'Total Orders' as measure_name, COUNT(DISTINCT fs.order_number ) from fact_sales fs 
union all
select	
	'Total Products' as measure_name, COUNT(dp.product_id ) as measure_value from dim_products dp 
union all
select	
	'Total Customers' as measure_name, COUNT(dc.customer_key) as measure_value from dim_customers dc 
union all
select	
	'Total Converted Customers' as measure_name, COUNT(distinct fs.customer_key ) as measure_value from fact_sales fs 












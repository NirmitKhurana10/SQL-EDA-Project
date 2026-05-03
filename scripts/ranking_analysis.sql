-- Which 5 products generate the highest revenue

select 
	* 
from 
(
	select 
		ROW_NUMBER() over (order by SUM(fs.sales_amount) DESC) as rank_products,
		dp.product_name,
		SUM(fs.sales_amount) as total_revenue
	from fact_sales fs 
	left join dim_products dp 
	on dp.product_key = fs.product_key 
	group by dp.product_name 
	order by total_revenue desc
)t
where t.rank_products < 6



-- What are the 5 worst-performing products in terms of sales? 


select 
	* 
from 
(
	select 
		ROW_NUMBER() over (order by SUM(fs.sales_amount) DESC) as rank_products,
		dp.product_name,
		SUM(fs.sales_amount) as total_revenue
	from fact_sales fs 
	left join dim_products dp 
	on dp.product_key = fs.product_key 
	group by dp.product_name 
	order by total_revenue desc
)t
where t.rank_products > 5



-- Find the top 10 customers who have generated the highest revenue

select
	dc.customer_key,	
	dc.first_name ,
	dc.last_name,
	SUM(fs.sales_amount) as total_revenue
from fact_sales fs 
left join dim_customers dc 
on dc.customer_key = fs.customer_key 
group by dc.customer_key , dc.first_name , dc.last_name 
order by total_revenue desc
limit 5



-- Find the 3 customers with the fewest orders placed

select
	dc.customer_key,	
	dc.first_name ,
	dc.last_name,
	COUNT(DISTINCT fs.order_number) as total_orders
from fact_sales fs 
left join dim_customers dc 
on dc.customer_key = fs.customer_key 
group by dc.customer_key , dc.first_name , dc.last_name 
order by total_orders asc, customer_key asc
LIMIT 3

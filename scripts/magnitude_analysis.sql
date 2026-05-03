-- Finding total customers by country

select 
	dc.country, 
	COUNT(dc.customer_key) as total_customers
from dim_customers dc 
group by dc.country 
order by total_customers desc

-- Finding total customers by gender

select 
	dc.gender, 
	COUNT(dc.customer_key) as total_customers
from dim_customers dc 
group by dc.gender  
order by total_customers desc



-- Finding total products by category

select 
	dp.category ,
	COUNT(dp.product_key) as total_products
from dim_products dp  
group by dp.category   
order by total_products desc




-- The average cost in each category


select 
	dp.category,
	ROUND(AVG(dp.product_cost),2) as avg_cost
from dim_products dp  
group by dp.category   
order by avg_cost desc


-- Total Revenue generated for each category


select 
	dp.category,
	SUM(fs.sales_amount) as total_revenue
from fact_sales fs
left join dim_products dp  
on dp.product_key = fs.product_key 
group by dp.category   
order by total_revenue  desc




-- Total Revenue generated for each customer


select 
	dc.customer_key,
	dc.first_name, 
	dc.last_name,
	SUM(fs.sales_amount) as total_revenue
from fact_sales fs
left join dim_customers dc   
on dc.customer_key = fs.customer_key
group by 
	dc.customer_key,
	dc.first_name,
	dc.last_name 
order by total_revenue  desc



-- Distribution of sold items across countries


select 
	dc.country,
	count(fs.quantity) as total_sold_items
from fact_sales fs 
left JOIN dim_customers dc  
on fs.customer_key = dc.customer_key 
group BY dc.country 
order by total_sold_items desc
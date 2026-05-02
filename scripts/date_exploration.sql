-- Finding boundaries of the dates of sales (first order date and last order date)
-- Number of years, months between the sales dates (first order date and last order date)


select 
	MIN(fs.order_date) as first_order_date,
	max(fs.order_date) as last_order_date,
	TIMESTAMPDIFF(YEAR, MIN(fs.order_date), max(fs.order_date)) as years,
	TIMESTAMPDIFF(MONTH, MIN(fs.order_date), max(fs.order_date)) as months
from fact_sales fs 


-- Finding the youngest and odlest customer

select 
	min(dc.birth_date) as oldest_bdate,
	TIMESTAMPDIFF(YEAR,min(dc.birth_date),CURDATE()) as oldest_age,
	max(dc.birth_date) as youngest_bdate,
	TIMESTAMPDIFF(YEAR,max(dc.birth_date),CURDATE()) as youngest_age
from dim_customers dc 
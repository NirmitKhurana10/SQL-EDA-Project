-- Exploring Dimensions

-- Country

select 
	DISTINCT dc.country 
from dim_customers dc 

-- Categories

SELECT 
	Distinct dp.product_line, dp.category , dp.sub_category, dp.product_name 
from dim_products dp 
order by 1,2,3,4
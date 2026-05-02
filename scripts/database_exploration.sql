-- Explore all objects in the database

select * from information_schema.TABLES t
where t.TABLE_SCHEMA like '%silver%' 
or t.TABLE_SCHEMA like '%gold%'
or t.TABLE_SCHEMA like '%bronze%';


-- Explore all columns in the database

select * from information_schema.`COLUMNS` c 
where c.TABLE_NAME = 'dim_products'

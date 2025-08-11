-- SQL REATAIL SALES ANALYSIS--

--  CREATING DATABASE-- 
CREATE DATABASE SQL_PROJECT_P1;

-- CREATING TABLES
USE sql_project_p1;
CREATE TABLE retial_sales(
  
  transaction_id INTEGER PRIMARY KEY ,
  sale_date DATE,
  sale_time TIME,
  customer_id INTEGER,
  gender VARCHAR(15),
  age INTEGER,
  category VARCHAR(15),
  quantity INTEGER,
  price_per_ INTEGER,
  cogs INTEGER,
  total_sales INTEGER
  
) ;
SELECT * FROM retial_sales;

SELECT COUNT(*) FROM retial_sales;


--  checking for NULL values in dataset // DATA CLEANING

SELECT * FROM retial_sales
WHERE
transaction_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR 
customer_id IS NULL
OR   
gender IS NULL
OR 
age IS NULL
OR
category IS NULL
OR 
quantity IS  NULL
OR 
price_per_ IS NULL
or
cogs IS NULL
or
total_sales IS NULL
;
--  NO NULL VALUE FIND

-- DATA EXPLORATION PROCESS

-- how many distinct sales we have?
SELECT COUNT(*) FROM retial_sales;   -- 1987

-- how many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retial_sales;

-- how many unique category we have?
SELECT  distinct category from retial_sales;


-- data analysis and key business problems

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * from retial_sales where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retial_sales where category='Clothing' AND quantity > 4 AND year(sale_date) ='2022' AND month(sale_date)='11';

-- 3.  Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category , sum(total_sales) as total_sales  , count(*) as total_orders from retial_sales group by category ;


-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT avg(age) as avg_age from retial_sales where category = 'Beauty' ;


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * from retial_sales where total_sales >1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category , gender, count(transaction_id) as total_transaction from retial_sales  group by category , gender  order by category;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date)   AS sale_year,
        MONTH(sale_date)  AS sale_month,
        AVG(total_sales)  AS avg_sales
    FROM retial_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT sale_year, sale_month, avg_sales
FROM (
    SELECT 
        sale_year,
        sale_month,
        avg_sales,
        ROW_NUMBER() OVER (PARTITION BY sale_year ORDER BY avg_sales DESC) AS rn
    FROM monthly_sales
) ranked
WHERE rn = 1;


-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id , sum(total_sales) as total_sale from retial_sales group by customer_id order by total_sale desc limit 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retial_sales
GROUP BY category;

-- 10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retial_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;







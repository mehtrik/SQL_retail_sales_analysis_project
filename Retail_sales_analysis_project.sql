-- SQL Retail SAles Analysis ProjectEATE DATABASE SQL_retail_sales;
CREATE DATABASE sql_retail_sales

-- Create TABLE
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy	INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

-- Correcting spelling mistake in column name in csv file
ALTER TABLE  retail_sales
RENAME COLUMN quantiy TO quantity;

-- Check for NULL values/data cleaning
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Data exploration
 
-- How many sales we have?
SELECT COUNT(*) as total_sale
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_unique_customer
FROM retail_sales;

-- How many distinct categories?
SELECT DISTINCT category
FROM retail_sales;

-- Data analysis/key bussiness problems

-- Q.1 Retrieve all rows for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = "2022-11-05";

-- Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT
*
FROM retail_sales
WHERE category = 'Clothing'
	AND quantity > 3
	AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
    
-- Q.3 Calculate the net sale for each category and the total orders for each category

SELECT
	category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Find the average age of customers who purchased items from the 'Beauty' category

SELECT
	ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Find how many transactions where the total_sale is greater than 1000

SELECT COUNT(*)
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Find the total number of transactions made by each each gender in each category

SELECT
	category,
    gender,
    COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 
	category,
    gender
ORDER BY gender ASC;

-- Q.7 Calculate the average sale for each month. Find out the best selling month in each year.

WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS _rank_
    FROM monthly_sales
) ranked
WHERE _rank_ = 1
ORDER BY year, avg_sale DESC;
	
-- Q.8 FInd the top 5 customers based on the highest otal sales

SELECT
	customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP by customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Find the number of unique customers who purchased items from each category

SELECT
    category,
    COUNT(DISTINCT(customer_id)) as unique_customer
FROM retail_sales
GROUP BY category;
    
-- Create each shift and number of orders (Morning < 12, Afternoon 12 & 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
        ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
Limit 10;

-- End of project

    
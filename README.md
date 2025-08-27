# SQL Retail Sales Analysis Project

This project demonstrates a comprehensive SQL analysis on retail sales data. The analysis includes database creation, table creation, data cleaning, data exploration, and solving key business problems using SQL queries.

---

## 1. Database Creation

-- Create a database for the retail sales analysis
```sql
CREATE DATABASE sql_retail_sales;
```
---

## 2. Table Creation

-- The retail_sales table is created with all required columns to store transaction data
```sql
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```
---

## 3. Data Cleaning

### 3.1 Correcting column name typo
```sql
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;
```
### 3.2 Checking for NULL values in critical columns
```sql
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
```
---

## 4. Data Exploration

### 4.1 Total number of sales
```sql
SELECT COUNT(*) as total_sale
FROM retail_sales;
```
### 4.2 Total number of unique customers
```sql
SELECT COUNT(DISTINCT customer_id) as total_unique_customer
FROM retail_sales;
```
### 4.3 Distinct product categories
```sql
SELECT DISTINCT category
FROM retail_sales;
```
---

## 5. Data Analysis / Key Business Problems

### Q1: Retrieve all sales made on '2022-11-05'
```sql
SELECT *
FROM retail_sales
WHERE sale_date = "2022-11-05";
```
### Q2: Transactions in 'Clothing' category with quantity > 3 in Nov-2022
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND quantity > 3
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
```
### Q3: Net sale and total orders for each category
```sql
SELECT
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;
```
### Q4: Average age of customers who purchased 'Beauty' category
```sql
SELECT
    ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category = 'Beauty';
```
### Q5: Transactions with total_sale > 1000
```sql
SELECT COUNT(*)
FROM retail_sales
WHERE total_sale > 1000;
```
### Q6: Total transactions by gender and category
```sql
SELECT
    category,
    gender,
    COUNT(*) as total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY gender ASC;
```
### Q7: Average sale per month and best selling month per year
```sql
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
```
### Q8: Top 5 customers by total sales
```sql
SELECT
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
### Q9: Number of unique customers per category
```sql
SELECT
    category,
    COUNT(DISTINCT(customer_id)) as unique_customer
FROM retail_sales
GROUP BY category;
```
### Q10: Number of orders per shift (Morning < 12, Afternoon 12-17, Evening > 17)
```sql
WITH hourly_sale AS (
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
LIMIT 10;
```
---

## End of Project


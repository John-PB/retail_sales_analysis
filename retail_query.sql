-- Retail Analysis
CREATE DATABASE retail_project;

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

-- Create Table
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)

-- Check the data, is it correctly export or not
SELECT * FROM retail_sales
LIMIT 20;

-- Total Row in Table
SELECT COUNT(*)
FROM retail_sales;

-- Check the null values
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

-- Delete all null values
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;
	
-- Total Data
SELECT COUNT(*) AS total_count
FROM retail_sales;

-- Total Customer by Gender
SELECT gender, COUNT(*) AS total_count
FROM retail_sales
GROUP BY gender;

-- Total Revenue 
SELECT SUM(total_sale) AS total_sale
FROM retail_sales;

-- Total Revenue Per Category, What Category make the most revenue and what category make the less revenue
SELECT category, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category;

SELECT category, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue ASC;

-- Average Revenue per Transaction
SELECT AVG(total_sale)
FROM retail_sales;

-- How Many Customer we have ?
SELECT COUNT(DISTINCT(customer_id)) AS total_customers
FROM retail_sales;

-- Unique Category
SELECT DISTINCT category
FROM retail_sales;

-- Transactions on 2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Transactions for Clothing Category Where Quantity sold more than equal 4 and transactons made on December 2022
SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND 
	quantity >= 4 
	AND 
	DATE_PART('month', sale_date) = 11 AND DATE_PART('year', sale_date) = 2022;

-- Average age of customers who purcashed electronics product, round to two decimal places
SELECT ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Electronics';

-- Transactions that have more than equal 1500 for beauty products
SELECT transactions_id, customer_id, total_sale AS total_bill
FROM retail_sales
WHERE total_sale >= 1500 AND category = 'Beauty';\

-- Total transactions by gender in each category
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Average sale for each month, What is the best selling month in each year
SELECT year, month, average_sale
FROM
	(	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS average_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY year, month
	) 
WHERE rank = 1;

-- Top 5 customers based on high total sales
SELECT customer_id, SUM(total_sale) as total_purchase
FROM retail_sales
GROUP BY customer_id
ORDER BY total_purchase DESC
LIMIT 5;

-- Total unique customers that make purchase for each category
SELECT category, COUNT(DISTINCT(customer_id)) total_unique_customers
FROM retail_sales
GROUP BY category;

-- Total transaction made in the morning,afternoon,and evening
-- Morning < 12, afternoon between 12 and 17, evening > 17
SELECT COUNT(*) total_transactions, CASE
				WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
				WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
				ELSE 'Evening'
		  END AS times
FROM retail_sales
GROUP BY times;

-- Average sale by day
SELECT TO_CHAR(sale_date, 'Day') AS Day, ROUND(AVG(total_sale)::NUMERIC, 2) AS average_sale
FROM retail_sales
GROUP BY Day
ORDER BY average_sale DESC;

-- Total sales in morning, afternoon and evening
SELECT CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	   END AS times,
	   SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY times
ORDER BY total_sales DESC;

-- Different age groups, including youth and adults, tend to have their own preferred shopping times.
-- age classificstion based on this https://www.statcan.gc.ca/en/concepts/definitions/age2
SELECT 
    CASE 
		WHEN AGE BETWEEN 15 AND 24 THEN 'Youth'
		WHEN AGE BETWEEN 25 AND 64 THEN 'Adult'
		WHEN age IS NULL THEN 'Unknown' 
    END AS age_group,

    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day,

    COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY age_group, time_of_day
ORDER BY age_group, transaction_count DESC;
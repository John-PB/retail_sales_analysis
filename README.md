# RETAIL SALES ANALYSIS PROJECT

## Objectives
1. **Create retail sales database** : create from scratch retail sales database
2. **Data Cleaning** : cleaning null value from null values
3. **Exploratory Data Analysis** : perform EDA to better understanding about data

### 1. Database Creation

**Database Structure**

* `transactions_id` - Unique ID for each transaction
* `sale_date` - Date of the sale  
* `sale_time` - Time of the sale
* `customer_id` - Customer’s unique ID
* `gender` - Gender of the customer  
* `age` - Age of the customer  
* `category` - Product category
* `quantity` - Number of units sold  
* `price_per_unit` - Price per unit  
* `cogs` – Cost of Goods Sold 
* `total_sale` - Revenue from sale
  
```sql
CREATE DATABASE retail_project;
```

```sql
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
```

### 2. Data Cleaning
**Check and delete null values**
* Check null values
  ```sql
  SELECT *
  FROM retail_sales
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
  ```
* Delete null values
  ```sql
  DELETE
  FROM retail_sales
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
  ```
### 3. Exploratory Data Analysis
1. **Total data**
   ```sql
   SELECT COUNT(*) AS total_count
   FROM retail_sales;
   ```
   
2. **Total Customer by Gender**
   ```sql
   SELECT gender, COUNT(*) AS total_count
   FROM retail_sales
   GROUP BY gender;
   ```

3. **Total Revenue**
   ```sql
   SELECT SUM(total_sale) AS total_sale
   FROM retail_sales;
   ```
   
4. **Total Revenue Per Category, What Category make the most revenue and what category make the less revenue**
   ```sql
   SELECT category, SUM(total_sale) AS total_revenue
   FROM retail_sales
   GROUP BY category;
   ```

   ```sql
   SELECT category, SUM(total_sale) AS total_revenue
   FROM retail_sales
   GROUP BY category
   ORDER BY total_revenue ASC;
   ```
   
5. **Average Revenue per Transaction**
   ```sql
   SELECT AVG(total_sale)
   FROM retail_sales;
   ```
   
6. **Total customer**
   ```sql
   SELECT COUNT(DISTINCT(customer_id)) AS total_customers
   FROM retail_sales;
   ```
   
7. **Unique Category**
   ```sql
   SELECT DISTINCT category
   FROM retail_sales;
   ```
    
8. **Transactions on 2022-11-05**
    ```sql
    SELECT * 
    FROM retail_sales
    WHERE sale_date = '2022-11-05'
    ```
    
9. **Transactions for Clothing Category Where Quantity sold more than equal 4 and transactons made on December 2022**
    ```sql
    SELECT * 
    FROM retail_sales
    WHERE 
	    category = 'Clothing' 
	  AND 
	    quantity >= 4 
	  AND 
	    DATE_PART('month', sale_date) = 11 AND DATE_PART('year', sale_date) = 2022;
    ```
    
10. **Average age of customers who purcashed electronics product, round to two decimal places**
    ```sql
    SELECT ROUND(AVG(age), 2) AS average_age
    FROM retail_sales
    WHERE category = 'Electronics';
    ```
    
11. **Transactions that have more than equal $1500 for beauty products**
    ```sql
    SELECT transactions_id, customer_id, total_sale AS total_bill
    FROM retail_sales
    WHERE total_sale >= 1500 AND category = 'Beauty';
    ```
    
12. **Total transactions by gender in each category**
    ```sql
    SELECT transactions_id, customer_id, total_sale AS total_bill
    FROM retail_sales
    WHERE total_sale >= 1500 AND category = 'Beauty';
    ```
    
13. **Average sale for each month, What is the best selling month in each year**
    ```sql
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
    ```
    
14. **Top 5 customers based on high total sales**
    ```sql
    SELECT customer_id, SUM(total_sale) as total_purchase
    FROM retail_sales
    GROUP BY customer_id
    ORDER BY total_purchase DESC
    LIMIT 5;
    ```
    
15. **Total unique customers that make purchase for each category**
    ```sql
    SELECT category, COUNT(DISTINCT(customer_id)) total_unique_customers
    FROM retail_sales
    GROUP BY category;
    ```
    
16. **Total transaction made in the morning,afternoon,and evening**
    ```sql
    SELECT COUNT(*) total_transactions, CASE
				WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
				WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
				ELSE 'Evening'
		  END AS times
    FROM retail_sales
    GROUP BY times;
    ```
    
17. **Average sale by day**
    ```sql
    SELECT TO_CHAR(sale_date, 'Day') AS Day, ROUND(AVG(total_sale)::NUMERIC, 2) AS average_sale
    FROM retail_sales
    GROUP BY Day
    ORDER BY average_sale DESC;
    ```
    
18. **Total sales in morning, afternoon and evening**
    ```sql
    SELECT CASE
		          WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	          	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		          ELSE 'Evening'
	         END AS times,
	         SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY times
    ORDER BY total_sales DESC;
    ```
    
19. **Different age groups, including youth and adults, tend to have their own preferred shopping times**
    ```sql
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
    ```

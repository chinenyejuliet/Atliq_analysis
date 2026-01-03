# Atliq_analysis SQL DATA ANALYSIS
## Overview
Atliq Hardware (imaginary company) is a major player in the computer hardware manufacturing industry, with operations across India and other international markets. Despite its success, the company has struggled with making timely and accurate data-based decisions. To address this challenge, the management is expanding its data analytics team, seeking candidates with strong SQL skills to enhance their data-driven decision-making processes.

As part of the Resume Project Challenge 4, organized by Codebasics, applicants are required to complete an SQL skills test, designed by Tony Sharma, the head of data analytics at Atliq Hardware. The test involves working with a consumer goods database, which holds key information related to the company's operations and performance.

**This project showcases my solutions to the SQL test, highlighting my ability to:**
- Write complex SQL queries to extract meaningful insights from large datasets.
- Perform data cleaning, transformation, and reporting using SQL.
- Support business decision-making by analyzing sales, inventory, and other key performance indicators.

The test is a crucial step in demonstrating how junior analysts can contribute to Atliq Hardware’s goal of improving their operational efficiency and data-driven strategies.

## Tools 
- Mysql

## Data Sources
This is a Project taken from Resume Project Challenge 4  organized by Codebasics and Atliq Technologies [visit page](https://codebasics.io/challenge/codebasics-resume-project-challenge)

This file provides a comprehensive overview of the tables found in the 'gdb023' (atliq_hardware_db) database. It includes information for six main tables:
1. dim_customer: contains customer-related data
2. dim_product: contains product-related data
3. fact_gross_price: contains gross price information for each product
4. fact_manufacturing_cost: contains the cost incurred in the production of each product
5. fact_pre_invoice_deductions: contains pre-invoice deductions information for each product
6. fact_sales_monthly: contains monthly sales data for each product.

***

## Queries

-- Question 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC 
region. 
```SELECT
      DISTINCT market
    FROM  dim_customer
    WHERE customer = 'Atliq Exclusive' 	AND region = 'APAC';
```

-- Question 2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains 
these fields,  
- unique_products_2020  
- unique_products_2021 
- percentage_chg

```
 SELECT (
		SELECT
			count(distinct product_code)
		FROM fact_sales_monthly f_2020
		WHERE fiscal_year = '2020') AS unique_products_2020,
	(
          SELECT
			count(distinct product_code)
		FROM fact_sales_monthly f_2021
		WHERE fiscal_year = '2021') AS unique_products_2021,
		CONCAT(Round ((SELECT unique_products_2021 - unique_products_2020)/(SELECT unique_products_2020)*100,2 ),'%')AS percentage_chg 
FROM fact_sales_monthly
LIMIT 1;
```

-- Question 3.  Provide a report with all the unique product counts for each segment and sort them in 
descending order of product counts. The final output contains 2 fields, 
- segment  
- product_count

 ```
SELECT 
	segment,
      COUNT(DISTINCT product_code) AS product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;
```

-- Question 4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final 
output contains these fields, 
- segment  
- product_count_2020  
- product_count_2021  
- difference 
```
WITH Counts_2020 AS (
			SELECT
				segment,
                COUNT(DISTINCT d.product_code) AS product_count_2020
			FROM dim_product d
            JOIN fact_sales_monthly fm USING (product_code)
            WHERE fiscal_year = 2020
            GROUP BY segment
), 
 Counts_2021 AS (
			SELECT
				segment,
                COUNT(DISTINCT d.product_code) AS product_count_2021
			FROM dim_product d
            JOIN fact_sales_monthly fm USING (product_code)
            WHERE fiscal_year = 2021
            GROUP BY segment
)
SELECT 
	c2.segment,
	c1.product_count_2020,
	c2.product_count_2021,
    c2.product_count_2021 - c1.product_count_2020 AS difference
FROM Counts_2020 c1
JOIN Counts_2021 c2
ON c1.segment = c2.segment
ORDER BY difference DESC;
```

-- Question 5.  Get the products that have the highest and lowest manufacturing costs. The final output should 
contain these fields,  
- product_code   
- product  
- manufacturing_cost
  
```
WITH highest_MCOST AS ( 
		SELECT 
			product_code,
			product,
			MAX(fmc.manufacturing_cost) AS manufacturing_cost
		FROM fact_manufacturing_cost fmc 
		JOIN dim_product USING (product_code)
        GROUP BY product_code, product
		ORDER BY manufacturing_cost DESC
		LIMIT 1     
),
lowest_MCOST AS(
SELECT 
	product_code,
    product,
    MIN(fmc.manufacturing_cost) AS manufacturing_cost
    
FROM fact_manufacturing_cost fmc 
JOIN dim_product USING (product_code)
GROUP BY product_code, product
ORDER BY manufacturing_cost 
LIMIT 1
)
SELECT
	*
FROM lowest_MCOST lm
UNION
SELECT
	*
FROM highest_MCOST hm;
```

-- Question 6. Generate a report which contains the top 5 customers who received an average high 
pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output 
contains these fields,  
- customer_code
-  customer  
- average_discount_percentage

```
SELECT 
		customer_code,
        customer,
		ROUND(AVG(pre_invoice_discount_pct)*100,5) AS Average_discount_percentage 
FROM fact_pre_invoice_deductions fd
JOIN dim_customer dc USING (customer_code)
WHERE fiscal_year = '2021' AND market = 'India'
GROUP BY customer_code,customer
ORDER BY Average_discount_percentage DESC
LIMIT 5;
```

-- Question 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each 
month. This analysis helps to get an idea of low and high-performing months and take strategic 
decisions. The final report contains these columns:  
- Month  
- Year 
- Gross sales Amount 

```
SELECT 
        MONTHNAME(date) AS MONTH,
        YEAR(date) AS YEAR,
        SUM(gross_price * sold_quantity) AS `Gross sales Amount`
FROM fact_sales_monthly fm
LEFT JOIN fact_gross_price fp USING (product_code)
LEFT JOIN dim_customer dc USING (customer_code)
WHERE customer = 'Atliq Exclusive'
GROUP BY MONTH,YEAR
ORDER BY YEAR;
```

-- Question 8. In which quarter of 2020, got the maximum total_sold_quantity? The final output contains 
these fields sorted by the total_sold_quantity, 
- Quarter  
- total_sold_quantity
```
SELECT 
        CONCAT('Q',QUARTER (date)) AS Quarter,
        SUM(sold_quantity) AS total_sold_quantity
FROM fact_sales_monthly fm
WHERE YEAR(date) = '2020'
GROUP BY Quarter
ORDER BY total_sold_quantity DESC
LIMIT 1;
```

-- Question 9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of 
contribution? The final output contains these fields,  
- Channel 
- gross_sales_mln 
- percentage

```
WITH total_sales_by_channel AS (		
			SELECT 
				channel,
				ROUND(SUM(gross_Price * sold_quantity )/1000000,2) AS gross_sales_mln
			FROM dim_customer
			JOIN fact_sales_monthly fm USING (customer_code)
			JOIN fact_gross_price USING (product_code)
			WHERE fm.fiscal_year = 2021
			GROUP BY channel			
)
 SELECT 
		channel,
        CONCAT(ROUND(gross_sales_mln / (SELECT SUM(gross_sales_mln) 
										FROM total_sales_by_channel) * 100 ,2), '%'
		) AS percentage
FROM  total_sales_by_channel 
ORDER BY percentage DESC;
```

Question 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 
2021? The final output contains these fields,  
- division  
- product_code  
- product  
- total_sold_quantity  
- rank order 
```
WITH total_products_sold AS (
					SELECT 
						division,
                        product_code,
                        product,
                        SUM(sold_quantity) AS total_sold_quantity,
						RANK() OVER(PARTITION BY division ORDER BY SUM(sold_quantity) DESC) AS rank_order
					FROM fact_sales_monthly fm
                    JOIN dim_product dp USING (product_code)
                    WHERE fiscal_year = 2021
                    GROUP BY product_code, division, product
)
SELECT *
FROM total_products_sold
WHERE rank_order IN (1,2,3)
```

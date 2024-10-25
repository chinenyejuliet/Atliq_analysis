-- Question 1 
SELECT 
	-- customer,
    DISTINCT market
	-- region
FROM  dim_customer
WHERE customer = 'Atliq Exclusive' 	AND region = 'APAC';

-- Question 2
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

-- Question 3
SELECT 
	segment,
    COUNT(DISTINCT product_code) AS product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;

-- QUestion 4

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

-- Question 5
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


-- Question 6
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
-- Question 7 
		
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

 -- Question 8
		
SELECT 
        CONCAT('Q',QUARTER (date)) AS Quarter,
        SUM(sold_quantity) AS total_sold_quantity
FROM fact_sales_monthly fm
WHERE YEAR(date) = '2020'
GROUP BY Quarter
ORDER BY total_sold_quantity DESC
LIMIT 1;

-- Question 9
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
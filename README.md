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

-- Question 2.hat is the percentage of unique product increase in 2021 vs. 2020? The final output contains 
these fields,  
• unique_products_2020  
• unique_products_2021 
• percentage_chg

```
 



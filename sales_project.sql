-- DATA CLEANING PROCESS-- 

-- STEP:0 CREATE A WORKING COPY OF ORIGINAL DATASET -- 

SELECT * FROM retail_sales.sales_dataset;

CREATE TABLE sales_staging
LIKE sales_dataset;

SELECT * FROM sales_staging;

INSERT INTO sales_staging
SELECT * FROM sales_dataset;

SELECT * FROM sales_staging;

-- STEP:1 CHECK FOR DUPLICATE RECORDS -- 


WITH duplicates_cte AS
(
SELECT `Transaction ID`, `Date`, `Customer ID`, Gender, Age, `Product Category`, Quantity, `Price per Unit`, `Total Amount`, COUNT(*) AS duplicates
FROM sales_staging 
GROUP BY `Transaction ID`, `Date`, `Customer ID`, Gender, Age, `Product Category`, Quantity, `Price per Unit`, `Total Amount`
)
SELECT * FROM duplicates_cte 
WHERE duplicates > 1;

-- NO DUPLICATE RECORDS FOUND 

-- STEP:2 CHECK FOR CATEGORICAL INCONSISTENCIES (STANDARDIZATION)

SELECT * FROM sales_staging;

SELECT DISTINCT Gender FROM sales_staging;

SELECT DISTINCT `Product Category` 
FROM sales_staging;


-- NO INCONSISTENCIES FOUND IN CATEGORICAL VALUES 

-- STEP:3 CHECK FOR MISSING OR BLANK VALUES ACROSS ALL COLUMNS

SELECT *
FROM sales_staging 
WHERE Gender IS NULL OR Gender = '';

SELECT *
FROM sales_staging 
WHERE `Transaction ID` IS NULL OR `Transaction ID` = '';

SELECT *
FROM sales_staging 
WHERE `Date` IS NULL OR `Date` = '';

SELECT *
FROM sales_staging 
WHERE `Customer ID` IS NULL OR `Customer ID` = '';

SELECT *
FROM sales_staging 
WHERE Age IS NULL OR Age = '';

SELECT *
FROM sales_staging 
WHERE `Product Category` IS NULL OR `Product Category` = '';

SELECT *
FROM sales_staging 
WHERE Quantity IS NULL OR Quantity = '';

SELECT *
FROM sales_staging 
WHERE `Price per Unit` IS NULL OR `Price per Unit` = '';

SELECT *
FROM sales_staging 
WHERE `Total Amount` IS NULL OR `Total Amount` = '';

-- NO MISSING OR BLANK VALUES DETECTED

-- STEP:4 COLUMN REVIEW
-- ALL COLUMNS ARE COMPLETE AND RELEVANT:  NO COLUMNS REMOVED



-- EXPLORATORY DATA ANALYSIS (EDA) --

SELECT * FROM sales_staging;

-- 1. TOTAL NUMBER OF TRANSACTIONS: 

SELECT COUNT(*) AS total_transactions
FROM sales_staging;

-- 2. UNIQUE NUMBER OF CUSTOMERS:

SELECT COUNT(DISTINCT `Customer ID`) AS unique_customers 
FROM sales_staging;

-- 3. GENDER DISTRIBUTION:

SELECT Gender, COUNT(*) AS distribution_in_gender
FROM sales_staging
GROUP BY Gender;

-- FEMALE CUSTOMERS DOMINATE

-- 4. AGE GROUP DISTRIBUTION:

SELECT MIN(Age), MAX(Age), AVG(Age)
FROM sales_staging
GROUP BY Gender;


SELECT 
	CASE 
		WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
	END AS age_group,
    COUNT(*) AS age_group_count
FROM sales_staging 
GROUP BY age_group
ORDER BY age_group;

-- AGE GROUP 46 - 60 HAS THE HIGHEST CUSTOMER COUNT

-- 5. REVENUE BY PRODUCT CATEGORY:

SELECT `Product Category`, SUM(`Total Amount`) AS total_revenue
FROM sales_staging
GROUP BY `Product Category`
ORDER BY total_revenue DESC;

-- ELECTRONICS CATEGORY GENERATES THE HIGHEST REVENUE


-- 6. MONTHLY SALES TREND:

SELECT 
	MONTHNAME(`Date`) AS month,
    SUM(`Total Amount`) AS monthly_sales
FROM sales_staging
GROUP BY MONTH(`Date`), MONTHNAME(`Date`)
ORDER BY MONTH(`Date`);

-- MAY IS THE HIGHEST-PERFORMING MONTH 

-- 7. AVERAGE ORDER VALUE:

SELECT AVG(`Total Amount`) AS avg_order_value 
FROM sales_staging;

-- AVERAGE ORDER VALUE IS $456.00

-- 8. MOST PURCHASED PRODUCT CATEGORY BY QUANTITY:

SELECT `Product Category`, SUM(`Quantity`) AS total_quantity_sold
FROM sales_staging
GROUP BY `Product Category`
ORDER BY total_quantity_sold DESC;

-- CLOTHING IS THE MOST FREQUENTLY PURCHASED CATEGORY

-- 9. GENDER BREAKDOWN WITHIN AGE GROUP 46 - 60

SELECT Gender, COUNT(*) AS count_in_46_60
FROM sales_staging
WHERE Age BETWEEN 46 AND 60
GROUP BY Gender;

-- FEMALES ONLY DOMINATE WITHIN THE 46 - 60 AGE GROUP


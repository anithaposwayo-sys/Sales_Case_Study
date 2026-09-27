-- Databricks notebook source

----Checking the type of data I have----
DESCRIBE workspace.default.sales_case_study_2021_1;

----Checking my data by Columns----
SELECT DISTINCT Date
FROM workspace.default.sales_case_study_2021_1
LIMIT 10;

SELECT DISTINCT Sales
FROM workspace.default.sales_case_study_2021_1
LIMIT 10;

SELECT DISTINCT `Cost Of Sales`
FROM workspace.default.sales_case_study_2021_1
LIMIT 10;

SELECT DISTINCT 'Quantity Sold'
FROM workspace.default.sales_case_study_2021_1
LIMIT 10;

----- Checking The number of records on the dataset----
SELECT
    Date,
    COUNT(*) AS number_of_records
FROM workspace.default.sales_case_study_2021_1
GROUP BY Date
HAVING COUNT(*) > 1
ORDER BY Date;

SELECT *
FROM workspace.default.sales_case_study_2021_1
WHERE Sales < 0
   OR `Cost Of Sales` < 0
   OR `Quantity Sold` < 0;


SELECT 
CAST(Date AS DATE) AS Date,
CAST(Sales AS DECIMAL(18,2)) AS Sales,
CAST(`Cost Of Sales` AS DECIMAL(18,2)) AS Cost_Of_Sales,
CAST(`Quantity Sold` AS INT) AS Quantity_Sold
FROM workspace.default.sales_case_study_2021_1;
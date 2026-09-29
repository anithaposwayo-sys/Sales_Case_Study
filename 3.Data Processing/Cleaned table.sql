-- Databricks notebook source
CREATE OR REPLACE TEMP TABLE sales_case_study_cleaned AS
SELECT 
CAST(Date AS DATE) AS Date,
CAST(Sales AS DECIMAL(18,2)) AS Sales,
CAST(`Cost Of Sales` AS DECIMAL(18,2)) AS Cost_Of_Sales,
CAST(`Quantity Sold` AS INT) AS Quantity_Sold
FROM workspace.default.sales_case_study_2021_1;

SELECT * FROM sales_case_study_cleaned;



SELECT Date,
        Sales,
        `Cost_Of_Sales`,
        `Quantity_Sold`,
    

Sales / Quantity_Sold AS Unit_Sales_Price,

    -- Gross profit
    Sales - Cost_Of_Sales AS Gross_Profit,

    -- Gross profit percentage
    (Sales - Cost_Of_Sales) / Sales AS Gross_Profit_Percentage,

    -- Gross profit per unit
    (Sales - Cost_Of_Sales) / Quantity_Sold AS Gross_Profit_Per_Uni
FROM sales_case_study_cleaned;


SELECT
    MIN(Sales) AS Min_Sales,
    MAX(Sales) AS Max_Sales,
    MIN(Cost_Of_Sales) AS Min_Cost,
    MAX(Cost_Of_Sales) AS Max_Cost
FROM sales_case_study_cleaned;

----Comparing prices with the previous days----

WITH price_analysis AS (
    SELECT
        Date,
        Sales,
        Cost_Of_Sales,
        Quantity_Sold,
        Sales / Quantity_Sold AS Unit_Sales_Price,

        LAG(Sales / Quantity_Sold) OVER (
            ORDER BY Date
        ) AS Previous_Unit_Price

    FROM sales_case_study_cleaned
)

SELECT
    Date,
    Sales,
    Cost_Of_Sales,
    Quantity_Sold,
    Unit_Sales_Price,
    Previous_Unit_Price,

    Unit_Sales_Price - Previous_Unit_Price AS Price_Change

FROM price_analysis
ORDER BY Date;

-----Flagging the days that had promotions----

CREATE OR REPLACE TEMP VIEW Price_analysis AS 
(
    WITH price_analysis AS (
        SELECT
        Date,
        Sales,
        Cost_Of_Sales,
        Quantity_Sold,
        Sales / Quantity_Sold AS Unit_Sales_Price,
        Sales - Cost_Of_Sales AS Gross_Profit,
        (Sales - Cost_Of_Sales) / Sales AS Gross_Profit_Percentage,
        (Sales - Cost_Of_Sales) / Quantity_Sold AS Gross_Profit_Per_Unit,

        LAG(Sales / Quantity_Sold) OVER (
            ORDER BY Date
        ) AS Previous_Unit_Price

    FROM sales_case_study_cleaned

),


promotion_flag AS (
    SELECT
        *,
        CASE
            WHEN Unit_Sales_Price < Previous_Unit_Price
            THEN 1
            ELSE 0
        END AS Promotion_Flag

    FROM price_analysis
)

SELECT *
FROM promotion_flag
ORDER BY Date
);

SELECT *
FROM price_analysis

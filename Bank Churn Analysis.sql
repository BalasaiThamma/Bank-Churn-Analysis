-- --KPI (Bank Churn Analysis)

-- --See All Data From Table
SELECT * FROM churn;

-- Total Customers-- 
SELECT COUNT(clientnum) AS Total_Customers FROM churn;		

-- --Avg Utilization Ratio
SELECT ROUND(AVG(utilization_ratio), 2) AS Avg_Utilization 
FROM churn;

-- Average Credit Limit-- 
SELECT ROUND(AVG(credit_limit),2) AS Avg_Credit_Limit FROM churn;

-- --Average Age
SELECT AVG(customer_age) AS Avg_Age FROM churn;


-- --GRANULAR / DEEP ANALYSIS

-- -- 1. Customer Distribution by Card Category
SELECT card_category, COUNT(clientnum) AS Customer_Count 
FROM churn 
GROUP BY card_category 
ORDER BY Customer_Count DESC;

-- 2. Average Balance by Income Level
SELECT income, AVG(balance) AS Avg_Balance 
FROM churn 
GROUP BY income 
ORDER BY Avg_Balance DESC;


-- -- 3. Customers by Marital Status
SELECT marital_status, COUNT(clientnum) AS Customer_Count 
FROM churn 
GROUP BY marital_status 
ORDER BY Customer_Count DESC;


-- -- 4. Customers Segmentation by Age Group
SELECT 
    CASE 
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN customer_age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+' 
    END AS Age_Group,
    COUNT(clientnum) AS Total_Customers
FROM churn
GROUP BY CASE 
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN customer_age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+' 
    END
ORDER BY Total_Customers DESC;


-- -- 5. Highest Credit Utilization Customers (Top 10)
SELECT 
    clientnum, 
    customer_age, 
    income, 
    credit_limit, 
    utilization_ratio
FROM churn
ORDER BY utilization_ratio DESC
LIMIT 10;


-- -- 6. Customers with High Credit Limit but Low Balance (Top 10)
SELECT 
    clientnum,
    customer_age,
    income,
    credit_limit,
    balance,
    ROUND((balance * 100.0 / credit_limit), 2) AS Balance_Percentage
FROM churn
WHERE balance < (0.2 * credit_limit)
    AND balance > 0  -- Exclude customers with zero balance
ORDER BY Balance_Percentage ASC
LIMIT 10;

-- -- 7. Customers with the Longest Relationship (Top 10 by Tenure)
SELECT 
    clientnum,
    customer_age,
    months_on_book,
    income,
    balance
FROM churn
ORDER BY months_on_book DESC
LIMIT 10;


-- -- 8. Average Dependent Count by Income Group
SELECT 
    income, 
    ROUND(AVG(dependent_count), 2) AS Avg_Dependents
FROM churn
GROUP BY income
ORDER BY Avg_Dependents DESC;


-- -- 9. Credit Utilization Index (High-Risk Customers)
SELECT 
    clientnum, 
    customer_age, 
    income, 
    credit_limit, 
    utilization_ratio,
    ROUND((utilization_ratio * 100.0), 2) AS Utilization_Percentage,
    CASE 
        WHEN utilization_ratio > 0.8 THEN 'High Risk'
        WHEN utilization_ratio BETWEEN 0.5 AND 0.8 THEN 'Moderate Risk'
        ELSE 'Low Risk' 
    END AS Risk_Level
FROM churn
ORDER BY utilization_ratio DESC;


-- --10. Longest Relationship Customers (VIP Segmentation)
SELECT 
    clientnum, 
    customer_age, 
    months_on_book, 
    income, 
    balance, 
    credit_limit
FROM churn
WHERE months_on_book > 53
ORDER BY balance DESC;







SELECT *
FROM c_add;

SELECT *
FROM c_details;

-- Total client
SELECT COUNT(DISTINCT Client_Num) AS Total_client
FROM c_add;

--customer satisfaction score
SELECT AVG(Cust_Satisfaction_Score) AS Customer_satisfaction_score
FROM c_add;

-- Customer Income
SELECT SUM(Income) AS Income
FROM c_add;

-- Revenue
SELECT SUM(Total_Trans_Amt + Annual_Fees + Interest_Earned) AS Revenue
FROM c_details;

-- Total Interest
SELECT ROUND(SUM(Interest_Earned),2) AS Total_Interest
FROM c_details;

--Total Trans volume 
SELECT SUM(Total_Trans_Vol) AS Trans_volume
FROM c_details;

SELECT 'Total_client' AS Measure_Name, COUNT(DISTINCT Client_Num) AS Measure_Value FROM c_add
UNION ALL
SELECT 'Income' AS Measure_Name, SUM(Income) AS Measure_Value FROM c_add
UNION ALL
SELECT 'Revenue' AS Measure_Name, Round(SUM(Total_Trans_Amt + Annual_Fees + Interest_Earned),2) AS Measure_Value FROM c_details
UNION ALL
SELECT 'Total_Interest' AS Measure_Name, ROUND(SUM(Interest_Earned),2) AS Measure_Value FROM c_details
UNION ALL 
SELECT 'Trans_volume' AS Measure_Name, SUM(Total_Trans_Vol) AS Measure_Value FROM c_details
UNION ALL
SELECT 'Customer_satisfaction_score' AS Measure_Name, AVG(Cust_Satisfaction_Score) AS Measure_Value FROM c_add


-- Total clients by State
SELECT state_cd, COUNT(Client_Num) AS Clients 
FROM c_add
GROUP BY state_cd
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by gender
SELECT Gender, COUNT(Client_Num) AS Clients 
FROM c_add
GROUP BY Gender
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by Marital Status
SELECT Marital_Status, COUNT(Client_Num) AS Clients 
FROM c_add
GROUP BY Marital_Status
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by Marital Status
SELECT Marital_Status, COUNT(Client_Num) AS Clients 
FROM c_add
GROUP BY Marital_Status
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by job
SELECT Customer_Job, COUNT(Client_Num) AS Clients 
FROM c_add
GROUP BY Customer_Job
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by Education
SELECT Education_Level, COUNT(Client_Num) AS Clients 
FROM c_add
GROUP BY Education_Level
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by Education
SELECT Card_Category, COUNT(Client_Num) AS Clients 
FROM c_details
GROUP BY Card_Category
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by Exp_Type
SELECT Exp_Type, COUNT(Client_Num) AS Clients 
FROM c_details
GROUP BY Exp_Type
ORDER BY COUNT(Client_Num) DESC;

-- Total Clients by use
SELECT Use_Chip, COUNT(Client_Num) AS Clients 
FROM c_details
GROUP BY Use_Chip
ORDER BY COUNT(Client_Num) DESC;

-- Total client Credit card limit
SELECT COUNT(DISTINCT Client_Num) AS Total_client,
       CASE
        WHEN Credit_Limit < 10000 THEN 'Below 10k'
        WHEN Credit_Limit BETWEEN 10000 AND 50000 THEN '10K TO 30K' 
        ELSE 'Above 30k'
        END AS cc_limit
FROM c_details
GROUP BY
       CASE
        WHEN Credit_Limit < 10000 THEN 'Below 10k'
        WHEN Credit_Limit BETWEEN 10000 AND 50000 THEN '10K TO 30K' 
        ELSE 'Above 30k'
        END 
ORDER BY cc_limit DESC

-- Revenue over time (months)
SELECT MONTH(Week_Start_Date) AS Month,
SUM(Total_Trans_Amt + Annual_Fees + Interest_Earned) AS Revenue
FROM c_details
WHERE Week_Start_Date IS NOT NULL
GROUP BY MONTH(Week_Start_Date)
ORDER BY Revenue DESC;

-- Cumalitive Analysis
--Total sales per month and running total of sales over time.
SELECT C_Month, Revenue,
 SUM(Revenue) OVER (ORDER BY C_Month) AS running_total
FROM (
SELECT MONTH(Week_Start_Date) AS C_Month,
SUM(Total_Trans_Amt + Annual_Fees + Interest_Earned) AS Revenue
FROM c_details
WHERE Week_Start_Date IS NOT NULL
GROUP BY MONTH(Week_Start_Date)) T

-- Moving avg and running total of Interest Earned
SELECT C_Month, int_earned, 
      SUM(int_earned) OVER(ORDER BY C_Month) AS running_total,avg_int,
      AVG(avg_int) OVER(ORDER BY C_Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
      FROM(
SELECT MONTH(Week_Start_Date) AS C_Month,
ROUND(SUM(Interest_Earned),2) AS int_earned,
ROUND(AVG(Interest_Earned),2) AS avg_int
FROM c_details
WHERE Week_Start_Date IS NOT NULL
GROUP BY MONTH(Week_Start_Date))t

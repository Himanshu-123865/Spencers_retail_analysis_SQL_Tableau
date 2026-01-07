USE Spencer_retails ;

-- ======================================================================================================
-- Exploring the Customer Data Table
-- ======================================================================================================

-- Total number of customer 
SELECT COUNT( DISTINCT Customer_id) AS Total_Customers
FROM Customers ;

-- Total number of customers by Gender and percentages
SELECT *,
CONCAT(ROUND(((No_of_customers)/SUM(No_of_customers) OVER())*100,2),"%") AS Per_of_Total
FROM(
SELECT Gender, COUNT( DISTINCT Customer_id ) AS No_of_customers
FROM Customers 
WHERE Gender != ""
GROUP BY Gender ) A ;

-- Total number of customers by Marital status and percentages
SELECT *,
CONCAT(ROUND((No_of_customers)/SUM(No_of_customers) OVER()*100,2),"%") AS Per_of_total
FROM(
SELECT Marital_status, Count( DISTINCT Customer_id) AS No_of_customers
FROM Customers 
GROUP BY Marital_status )A 
ORDER BY per_of_total ;

-- Total number of customers by cities 
SELECT *,
CONCAT(ROUND((No_of_customers/SUM(No_of_customers) OVER())*100,2),"%") AS Per_of_total
FROM (
SELECT City_code, COUNT(DISTINCT Customer_id) AS No_of_customers
FROM Customers 
GROUP BY city_code ) A ;

-- Total customers by various age groups
WITH CTE_1 AS(
SELECT  Age_categories, COUNT(DISTINCT customer_id) as No_of_customers
FROM (
SELECT *,
CASE WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 0 AND 25 THEN "0-25" 
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 26 AND 40 THEN "26-40"
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 41 AND 65 THEN "41-65"
ELSE "65+" END AS Age_categories
FROM Customers ) A 
GROUP BY Age_categories
)

SELECT Age_categories, No_of_customers,
CONCAT(ROUND((((No_of_customers)/SUM( No_of_customers) over() )*100),2),"%")  AS Per_of_total 
FROM CTE_1 ;



/* Insights from the analysis :-
1) Gender of the customers visiting the store is balanced with Male vs Female being equal with 51% vs 49% share.
2) Married customers are slight higher with 56% share as opposed to 44% for singles, spencers can optimize their product 
offering by customizing their product mix for family needs.
3) Share of customers is balanced between all cities where the stores are located, showing healthy distibution of business.
4) Major share of the customers visiting the store are in 41-65 age range with 65% share, spencers should use majority of their retail
space for products catering to this age groups to improve sales, Alternatively they can use creative marketing campaigns target younger age groups
to increase their shares.
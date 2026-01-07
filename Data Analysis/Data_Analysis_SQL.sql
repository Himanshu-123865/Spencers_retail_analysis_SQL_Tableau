
/*
============================================================================================================
Data Analysis
============================================================================================================
*/

-- 1) Share insights on sales performance based on customer age categories.

SELECT Age_categories,
COUNT( DISTINCT Cust_id) AS No_of_cus,
 SUM(sales) AS Total_sales,
 ROUND( SUM(sales) / COUNT( DISTINCT Cust_id),2) AS Avg_sales 
FROM (
SELECT 
CASE WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 0 AND 25 THEN "0-25" 
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 26 AND 40 THEN "26-40"
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 41 AND 65 THEN "41-65"
ELSE "65+" END AS Age_categories,
Total_amt AS Sales,
cust_id
FROM Customers C
JOIN Transactions T
ON C.customer_id = T.cust_id
) A
GROUP BY Age_categories ;

/*
 Insights : 
 1) Spencers has two major age categories for customer where in highest customers are between 
the ages of 41 - 65,that is 45% percent higher customers than 26-40 Age category with 65% of total sales.
2)Average sales are similar but marginally higher for the 41 - 65 Age category.
 */
  
  -- 2)	What are the top two prod_subcat for different customer_age_categories
  
  WITH CTE_1 AS(
  
  SELECT Age_categories,prod_cat,
prod_subcat,
  SUM(Qty) AS No_of_products,
    DENSE_RANK() OVER(PARTITION BY Age_categories ORDER BY  COUNT(prod_subcat) DESC) AS r1
  FROM(

SELECT 
CASE WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 0 AND 25 THEN "0-25" 
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 26 AND 40 THEN "26-40"
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 41 AND 65 THEN "41-65"
ELSE "65+" END AS Age_categories,
prod_cat,
prod_subcat,
Qty
FROM Transactions T
JOIN prod_cat_info P
ON P.Prod_sub_cat_code = T.Prod_subcat_code
JOIN Customers C
ON T.cust_id = c.customer_id ) A
GROUP BY Age_categories,prod_cat,prod_subcat

  ) 

  SELECT Age_categories,prod_cat, prod_subcat, No_of_products,r1
  FROM CTE_1
  WHERE r1 = 1 or r1 = 2
  ORDER BY Age_categories, r1 ;
  
  /* 
  Insights :
  '26-40'Age category: Top products categories preferred by Age groups '26-40' are Mobiles, Women's hand bags, 
                        Foot wear & comics.
  ' 41-65'Age category:  Top product categories prefereed by '41-65' are Mobiles, Kid footwear & clothing.
  */
  

-- 3)	 Analyze the customer preference of the store type based on the product category they purchase.

SELECT prod_cat,store_type,Total_qty,category_rank
FROM ( 
SELECT prod_cat,store_type,SUM(Qty) As Total_qty,
DENSE_RANK() OVER(PARTITION BY Prod_cat ORDER BY SUM(Qty) DESC) AS category_rank
FROM Transactions T 
JOIN Prod_cat_info P
ON T.prod_cat_code = P.prod_cat_code 
GROUP BY prod_cat,store_type ) A
WHERE category_rank = 1 OR category_rank = 2
ORDER BY Prod_cat, category_rank ;

/* 
Insights : Top 2 preferred store type for the customers across all categories are "eshop" & "MBR"  
		   except for eshop where customers prefer shopping in physical store after online.
		
*/

-- 4) Share top two store type preference based for each City 

SELECT City_name,store_type,Total_qty,Store_rank
FROM(

SELECT City_name,store_type,SUM(Qty) AS Total_qty,
DENSE_RANK() OVER(PARTITION BY city_name ORDER BY SUM(Qty) DESC) AS Store_rank
FROM Transactions T 
JOIN Customers C 
ON T.cust_id = C.customer_id 
GROUP BY City_name,store_type) A
WHERE store_rank = 1 or store_rank = 2  
ORDER BY City_name, Store_rank ;

/* 
Insights: Eshop or online is the Top mode of shopping for customers across all the 10 cities 
		  secondary preference are either Flag ship store in 4 cities & MBR in 5 cities. Showing 
		  clear preference among customer for these 3 stores for their shopping needs
*/

 -- 5)	Categorize the customers basis the sales generated & the tenure in the system as follows 
--     a)	 Platinum customer: Tenaurity > 12 months & sales > 6000$
--     b)	Gold customers: Tenurity > 12 months  & Sales between 3000  to 6000
--     c)	Regular customers; Tenurity > 12 months 
--     d)	New customers: Tenurity < 12 months 

 
 WITH CTE_1 AS (
 
 SELECT Cust_id,sales,Life_span,
 CASE WHEN life_Span > 12 AND SALES > 10000 THEN "Platinum_customers"
 WHEN life_Span > 12 AND SALES BETWEEN  5001 AND 9999  THEN "Gold_customers"
WHEN life_Span > 12 AND SALES  <  5000 THEN  "Regular_customers"
ELSE "New_cutomers" END AS "Customer_Type"
FROM(
SELECT Cust_id,SUM(Total_Amt) AS Sales,MIN(tran_date),MAX(tran_date),
TIMESTAMPDIFF(Month, MIN(tran_date), MAX(tran_date)) AS Life_span
FROM Transactions 
GROUP BY Cust_id 
) A
 )
 
 SELECT *,
 CONCAT(ROUND((no_of_customers/SUM(no_of_customers)  OVER())*100,2),"%") AS Per_of_total_cus
 FROM(
 SELECT Customer_type, Count(Cust_ID) AS no_of_customers
FROM CTE_1 
GROUP BY Customer_type ) B ;

/* 

Insights : More than 40 % of the customers of spencer_retails fall in Platinum customer & ~ 20 % gold customer 
		  which shows high brand loyalty among the spencer customers 
          Also as per analysis its noted that ~ 30 % of the total customers are new customer  showing health expansion 
          for spencer retails
          
*/

-- 6)	Top 3 Cities that are attracting most new customers. 
WITH CTE_1 AS(
  SELECT city_name,cus_category,COUNT(DISTINCT Cust_id) AS Total_Cus
FROM(
SELECT city_name,Cust_id,SUM(Total_Amt) AS Sales,MIN(tran_date),MAX(tran_date),
TIMESTAMPDIFF(Month, MIN(tran_date), MAX(tran_date)) AS Life_span,
 CASE WHEN TIMESTAMPDIFF(Month, MIN(tran_date), MAX(tran_date)) < 12  THEN  "New_cutomers" ELSE "Veteran_customers"END AS Cus_category
FROM Transactions T
JOIN Customers C
ON C.customer_id = T.cust_id
GROUP BY Cust_id 
) A
GROUP BY city_name,cus_category  )
SELECT City_name,cus_category,per_cat,
DENSE_RANK() OVER(ORDER BY per_cat DESC) AS R1
FROM(
SELECT *,
  SUM(Total_Cus) OVER(PARTITION BY City_name) As Total_city_customer,
 CONCAT(ROUND( (SUM(Total_Cus)/ SUM(Total_Cus) OVER(PARTITION BY City_name))*100,2),"%") AS per_cat
  FROM CTE_1 
  GROUP BY city_name,cus_category
   ) B
   WHERE cus_category = 'New_cutomers' 
   LIMIT 3;
 
 /* 
 Insights: Top 3 cities with highest share of new customers are California, Anaheim, Detroit with > 28% of their total 
            customers being less than 12 months old in the system.
 */
 
 

-- 7) Share the number of repeat customers for each product subcategory also show the percentage of repeat customers 
--    among the total customers (Repeat customers are customers that have more than 3 orders in same subcategory)

WITH CTE_1 AS(
SELECT
    Prod_cat,Prod_subcat,
    COUNT(CASE WHEN Total_orders >= 3 THEN cust_id END) AS repeat_customers,
    COUNT(CASE WHEN Total_orders < 3 THEN cust_id END) AS regular_customers
FROM(
SELECT Prod_cat,Prod_subcat, cust_id, COUNT( Distinct Transaction_id) AS Total_orders
FROM Transactions T
JOIN Prod_cat_info p
ON T.prod_subcat_code = P.prod_sub_cat_code 
GROUP BY Prod_cat,Prod_subcat, cust_id) A
GROUP BY Prod_cat,Prod_subcat
)
SELECT *,
CONCAT(ROUND(repeat_customers/(repeat_customers + regular_customers)*100,2),"%") AS per_of_repeat_cus
FROM cte_1
 ;
/* Insights 
Over all repeat customer percentage is < 10 % for every category, spencers can improve on Loyalty Programs & offer incetives
like discount or coupons on second purchase to drive the customer_retention 
*/



;
SELECT * FROM transactions ;	
SELECT * FROM customers  ;
SELECT * FROM prod_cat_info ;

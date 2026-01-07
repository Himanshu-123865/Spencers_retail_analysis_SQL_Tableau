USE Spencer_retails ;

/*
============================================================================================================
Time-series Analysis
============================================================================================================
*/

-- 1)	Share time series analysis of data to understand the sales, number of customer & qty growth  
--       YoY for spencer retails.

SELECT Year,No_of_customers,
CONCAT(ROUND((No_of_customers-LAG(No_of_customers) OVER(ORDER BY YEAR))/LAG(No_of_customers) OVER(ORDER BY YEAR)*100,2),"%") AS Per_change_in_cus,
Sales,
CONCAT(ROUND(((Sales -  LAG(sales) OVER( ORDER BY YEAR))/LAG(sales) OVER( ORDER BY YEAR))*100,2),"%") AS Per_change_in_sales,
Qty,
CONCAT(ROUND(((Qty - LAG(QTY) OVER(ORDER BY YEAR))/ LAG(QTY) OVER(ORDER BY YEAR))*100,2),"%") AS Per_change_in_qty 
FROM(
SELECT YEAR(tran_date) AS Year, COUNT(DISTINCT Cust_id) AS No_of_customers,
SUM(Total_amt) AS Sales, SUM(Qty) AS Qty
FROM Transactions 
GROUP BY YEAR(tran_date)) A 
; 
/* 
Insights :
Noted posetive correlation between number of customer, sales & quantity. We see marginal increase in 
all the three categories from 2011 to 2012, further which there is a decline in the sales in 2013 & 2014,
showing an overall downward trend for the business. 
*/
 

-- 2)	What customer Age categories are shwowing growth YoY by sales 

SELECT AGe_categories, Year(tran_date)AS Year, SUM(Total_amt) AS Sales,
CONCAT(ROUND(((SUM(Total_amt)-LAG(SUM(Total_amt)) OVER(PARTITION BY Age_categories ORDER BY Year(tran_date)) )/
LAG(SUM(Total_amt)) OVER(PARTITION BY Age_categories ORDER BY Year(tran_date)) )*100,2),"%") AS Per_change_in_sales
FROM(
SELECT *,
CASE WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 0 AND 25 THEN "0-25" 
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 26 AND 40 THEN "26-40"
WHEN  TIMESTAMPDIFF(YEAR,DOB,NOW()) BETWEEN 41 AND 65 THEN "41-65"
ELSE "65+" END AS Age_categories
FROM Transactions T
JOIN Customers C
ON T.cust_id = c.customer_id ) A
GROUP BY AGe_categories, YEAR
ORDER BY Age_categories, Year 
;
/* 
Insghts: Fidings point over all decrease sales among all age_customers following the pattern of general sales decline for specncer retails. 
*/

-- 3) What store types are growing by sales & need to be invested in & store types that are dwindling based on YoY sales.

SELECT store_type,Year,No_of_customers,
CONCAT(ROUND((No_of_customers-LAG(No_of_customers) OVER(PARTITION BY Store_type ORDER BY YEAR))/LAG(No_of_customers) OVER(PARTITION BY Store_type ORDER BY YEAR)*100,2),"%") 
AS Per_change_in_cus,
Sales,
CONCAT(ROUND(((Sales -  LAG(sales) OVER(PARTITION BY Store_type  ORDER BY YEAR))/LAG(sales) OVER(PARTITION BY Store_type  ORDER BY YEAR))*100,2),"%") AS Per_change_in_sales
FROM(
SELECT store_type,YEAR(tran_date) AS Year, COUNT(DISTINCT Cust_id) AS No_of_customers,
SUM(Total_amt) AS Sales, SUM(Qty) AS Qty
FROM Transactions 
GROUP BY store_type,YEAR(tran_date)) A 
GROUP BY store_type,YEAR
ORDER BY Store_type,year ;
;

-- 4)  Share the seasonal pattern of sales for each product category to identify the month with highest sales.

SELECT *,
CONCAT(ROUND((Sales/ SUM(sales) OVER(PARTITION BY Prod_cat ))*100,2),"%") AS per_of_tot_yearly_sales,
DENSE_RANK() OVER(PARTITION BY Prod_cat ORDER BY SALES DESC) AS Ranking
FROM (
SELECT Prod_cat,DATE_FORMAT(tran_date,"%b") AS Month, SUM(Total_amt) AS Sales
FROM Transactions T 
JOIN prod_cat_info P
ON T.prod_subcat_code = P.prod_sub_cat_code
GROUP BY  Prod_cat,MONTH(tran_date),DATE_FORMAT(tran_date,"%b")
) A
ORDER BY Prod_cat,Ranking
;
/*
insights : The data shows the following sesaonality for the various category 
Bags & Books & clothing: These category has highest sales in Jan & feb & then in sep & oct months
Footwear & electronics: These categories have strong demand in Dec, Jan & Feb months
Home & kitchens : This category has its peak sales from Jan to Mar months
*/


-- 5)Show new customers gained by spencer’s & retention of the existing customer by spencer’s YoY.
-- (New customers are the customers who have not placed order in prev_year)

WITH CTE_1 AS(
SELECT *, 
CASE WHEN last_year_order > 0 then "Old_customers"
ELSE "New_customer" END AS Cust_categories
FROM (
SELECT Year(tran_date) AS year, count(Transaction_id) As curr_year_order ,
LAG(count(Transaction_id)) OVER(PARTITION BY cust_id ORDER BY Year(tran_date))  AS last_year_order,
 Cust_id
FROM Transactions 
GROUP BY Year(tran_date), Cust_id
) A
ORDER BY CUST_ID, YEAR
)
SELECT YEAR,New_customer_count+Old_customer_count AS total_cus,New_customer_count,
Concat(ROUND((New_customer_count/(New_customer_count+Old_customer_count)*100),2),"%") AS per_of_new_cus,
Old_customer_count,
Concat(ROUND((Old_customer_count/(New_customer_count+Old_customer_count)*100),2),"%") AS per_of_old_cu
FROM(
SELECT YEAR,
COUNT( CASE WHEN cust_categories ="New_customer" THEN "New" END)  AS New_customer_count,
COUNT( CASE WHEN cust_categories ="Old_customers" THEN "Old" END)  AS Old_customer_count
FROM CTE_1
GROUP BY Year ) B ;

/* 
Insights:
From the above analysis it is clear that spencer reatils is failing to attract new customers, as we year on year
decrease in the percentage of new customers. Spencers need to improve its marketing,advertising & referal programs
to bring in new customers. 
*/




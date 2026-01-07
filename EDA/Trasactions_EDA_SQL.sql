USE spencer_retails ;

-- =========================================================================================================
-- Exploring the Transaction table
-- =========================================================================================================

-- Total transactions for all stores 
SELECT COUNT(DISTINCT transaction_id) AS Total_transactions 
FROM Transactions ;

-- Transaction at an yearly grain
SELECT YEAR(Tran_date) AS Year , Count( DISTINCT Transaction_id) AS Total_transactions
FROM Transactions 
GROUP BY YEAR(Tran_date);

-- Seasonal purchase pattern by month 
SELECT DATE_FORMAT(Tran_date,"%b") AS Month , Count( DISTINCT Transaction_id) AS Total_transactions
FROM Transactions 
GROUP BY DATE_FORMAT(Tran_date,"%b") ,MONTH(Tran_date)
ORDER BY MONTH(Tran_date) ;

-- Total quantity sold 
SELECT SUM(Qty) As Total_quantity_sold
FROM Transactions ;

-- Quantity sold, sales and percenatge share by different store types
SELECT *,
CONCAT(ROUND((quantity_sold/sum(quantity_sold) OVER())*100,2),"%") AS per_of_total_qty,
CONCAT(ROUND((sales_amt/SUM(sales_amt) OVER())*100,2),"%") AS per_of_total_sales 
FROM(
SELECT store_type, SUM(qty) AS quantity_sold, 
SUM(Total_amt) as sales_amt
FROM Transactions
GROUP BY store_type )A ;


-- Sales amount by product sub category, category and % sales contributions of subcategory in category & category in total sales
SELECT *,SUM(Sales_amount) OVER(PARTITION BY Prod_cat) AS sales_by_category,
CONCAT(ROUND((Sales_amount/SUM(Sales_amount) OVER(PARTITION BY Prod_cat))*100,2),"%") AS per_saleby_prodcat,
CONCAT(ROUND((SUM(Sales_amount) OVER(PARTITION BY Prod_cat)/Sum(sales_amount)over())*100,2),"%") AS per_saleby_category
FROM (
SELECT Prod_cat,prod_subcat,SUM(Total_amt) AS Sales_amount
FROM Transactions T
JOIN Prod_cat_info P
ON T.prod_subcat_code = P.prod_sub_cat_code 
GROUP BY Prod_cat,prod_subcat 
ORDER BY  Prod_cat,prod_subcat) a ;

-- Determining the product cost for each subcategory 
SELECT *,
ROUND(Total_sales/ Total_qty,2) AS product_cost
FROM (
SELECT prod_subcat_code, SUM(Total_amt) AS Total_sales, SUM(qty) AS Total_qty
FROM transactions 
GROUP BY prod_subcat_code ) A
;

--  calculate the Highest & lowest taxed sub_category

WITH Cte_1 as (
    SELECT 
        Prod_subcat_code,
        SUM(TAX) AS Tax,
        SUm(Qty) AS quantity,
        SUM(TAX)/SUM(QTY)  AS Avg_TAX
    FROM Transactions
    GROUP BY Prod_subcat_code
),
cte_2 as (
    SELECT 
        Prod_subcat_code,
        Avg_TAX,
        RANK() OVER (ORDER BY Avg_TAX DESC) AS High_rank,
        RANK() OVER (ORDER BY Avg_TAX ASC) AS Low_rank
    FROM cte_1
)
SELECT 
    Prod_subcat_code,
    CASE 
        WHEN High_rank = 1 THEN 'Highest_Tax'
        WHEN Low_rank = 1 THEN 'Lowest_tax'
    END AS Tax_subcategory,
Round(Avg_tax,2) as Avg_tax
FROM cte_2
WHERE High_rank = 1 OR Low_rank = 1;
;



SELECT * FROM Transactions ;

SELECT * from prod_cat_info 
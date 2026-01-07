USE spencer_retails ;

-- ===========================================================================================================
-- Exploring the Product Table
-- ===========================================================================================================

-- Total product categories offered by the store 
SELECT COUNT(DISTINCT Prod_cat_code) AS Total_categories
FROM prod_cat_info ;



-- Total number of subcategory of products offered by the store 
SELECT COUNT( Prod_sub_cat_code) AS Total_subcategories
FROM prod_cat_info ;

-- Total numbers of subcategories in each categroy
SELECT Prod_cat , COUNT(DISTINCT prod_subcat) AS Total_subcategories
FROM prod_cat_info
GROUP BY Prod_cat ;
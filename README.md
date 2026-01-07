>
>  # Spencer retail Analysis 
													   
_Analysis of spencer’s retail sales trends by stores, product categories & locations to support the strategic and planning decision’s using Excel, SQL and Tableau_

 ## Overview
Analysis evaluates the sales performance & customer preferences to aid data driven decision making on inventory management, marketing, pricing and investments for the leadership. 

## Requirements:
Data driven decision making is pre-requisite to understand and manage the performance of various aspects of business today. This project answers some key questions like: - 
1)	 Identifying underperforming Product categories needing price adjustments & promotions
2)	Peformance of various stores to understand the growing & declining channel of sales to ensure better future investments 
3)	Customer Age categories sales preferences & changing dynamics for better inventory optimization.
## Dataset:
Data is sourced from Kaggle for analysis & is in multiple CSV files. Kaggle [Data set link] (https://www.kaggle.com/datasets/rishikumarrajvansh/retail-case-study) for reference. 
## Tools used for the Analysis:
1)	Excel: (Pivot, Filters)
2)	 SQL (CTE’s, Subquery, Window Function, Joins, Aggregations and DDL queries)
3)	Tableau(String, Date, Aggregate and Logical Functions, Parameters, actions, charts)

## Data cleaning: - 
1)	 Standardized the date format in DOB column in customer table. 
2)	Removing anomalies in  like ‘-‘  values from qty, tax and rate columns.
3)	Converted string type for ‘Tran_date’ column to the Date data type. 

## EDA:
### Customers 
1)	 Spencer’s customers are all in 26 to 65 age range, with Top age category with 65 % share is 41-65 Age category.
2)	Proportional distribution of customers across gender & location categories with married customers being slightly higher at 56% compared to singles 44% 
### Products
1)	Spencer’s offer 6 product categories with 23 different subcategories of products across all 10 cities 
### Transactions
1)	Most preferred store type by customers is e-shop with 40 % share, double of all other store types
2)	Highest sales are in month of Jan & Feb and lowest sales for spencer retails are in month of May & June. 

## Key Findings
The analysis reveals a consistent downward trend across all key business metrics. Sales revenue and no_of_customer have declined across all product categories and geographical locations, indicating systemic challenges rather than isolated issues.

Critical Challenge: Customer Acquisition Decline The primary driver of declining sales is Spencer Retail's inability to attract new customers. While existing customers demonstrate strong brand loyalty with high repeat purchase rates, the percentage of new customer acquisitions has decreased year-over-year, creating an unsustainable business trajectory.
Customer Retention vs. Acquisition Gap Despite maintaining a loyal customer base with strong retention metrics, the declining influx of new customers is eroding overall market share and revenue potential. This imbalance threatens long-term business viability.

## Recommendations 
**Enhanced Promotional Strategy**: Implement targeted marketing campaigns and promotional offers specifically designed to attract new customer segments
1.	**Product Portfolio Expansion**: Diversify inventory offerings to appeal to broader customer demographics and capture untapped market segments
2.	**Balanced Growth Approach**:Maintain existing customer satisfaction initiatives while simultaneously investing in aggressive new customer acquisition programs
Spencer Retail must urgently address the new customer acquisition gap through multi-channel marketing initiatives and expanded product offerings, while preserving the strong loyalty of its existing customer base.

## Dashboard
Dashboard link for reference:-  [Dashboard link]
(https://public.tableau.com/app/profile/himanshu.trivedi6721/viz/SpencersDashboard/SpencerretailDashboard)

![image alt](https://github.com/Himanshu-123865/Spencers_retail_analysis_SQL_Tableau/blob/c46d604db0072526aea6459364ad300216463afa/images/Spencers_dashboard_image.png)


##Author: 
Himanshu Trivedi
WFM MIS Specialist
Email : Himanshu90tri@gmail.com

-- Step 1: Creating database for the analysis & loading data from the CSV Files 

-- Step 2: # Data cleaning steps ( Create samaple tables and then work on it)
-- 1. Remove duplicates to avoid inconsistencies
-- 2. Standardize data in to single format
-- 3. Null values or blank values(populate)


-- ===================================================================================================
-- Creating Database & loading the required tables 
-- ===================================================================================================

CREATE DATABASE Spencer_retails;

USE Spencer_retails ;

-- Creating customer table 

CREATE TABLE Customers
( Customer_ID  INT PRIMARY KEY UNIQUE ,
First_name VARCHAR(50),
Last_name VARCHAR(50),
DOB VARCHAR(30),
Marital_status VARCHAR(30),
Gender VARCHAR(10),
City_code INT ) ;

-- Loading data in to the Table from CSV

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Customer.CSV' into table Customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ; 

-- Creating Product table 

CREATE TABLE Prod_cat_info 
( Prod_cat_code INT NOT NULL,
Prod_cat VARCHAR(30),
Prod_sub_cat_code INT ,
Prod_subcat VARCHAR(50) ) ;

-- Loading data in to the Table from CSV

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Prod_cat_info.CSV' into table Prod_cat_info 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ; 

-- Creating Table Transactions 

CREATE TABLE Transactions (
Transaction_id BIGINT,
Cust_id INT,
Tran_date VARCHAR(30),
Prod_subcat_code INT,
Prod_cat_code INT,
Qty INT,
Rate INT,
Tax INT,
Total_amt INT,
Store_type VARCHAR(30) );

-- Loading data into the table from CSV 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Transactions.CSV' into table Transactions 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ; 


-- ===================================================================================================
-- Step 2: Cleaning the Dataset
-- ===================================================================================================

-- 1) Customer Table:

-- Standardizing the Date format in DOB column in the customer table

SELECT replace(DOB,"/","-") 
FROM Customers ;

UPDATE customers 
SET DOB =  replace(DOB,"/","-") ;

SELECT STR_TO_DATE(DOB,'%d-%m-%Y')
FROM Customers ;

UPDATE Customers
SET DOB =  STR_TO_DATE(DOB,'%d-%m-%Y') ;

ALTER TABLE customers 
MODIFY DOB DATE ;

/* With the above queries we made the following changes to the DOB Column 
 1) Converetd all values in DOB column in singular format.ie "dd-mm-yyyy"
 2) Updated the date format from dd-mm-yyyy to yyyy-mm-dd
 3) Aleterd the data type for DOB Column to DATE from string. 
 */


-- 2) Products table : None required for the products table 

-- 3) Transaction Table

-- a) cleaning data in the tran_date column below :

SELECT Tran_date 
FROM Transactions
WHERE tran_date NOT LIKE "%-%-%" ;

SELECT REPLACE(Tran_date,"/","-") 
FROM Transactions ;

Update  Transactions 
SET Tran_date =  REPLACE(Tran_date,"/","-")  ;

SELECT STR_TO_DATE(Tran_date,"%d-%m-%Y")
FROM TRANSACTIONS  ;

Update  Transactions 
SET Tran_date = STR_TO_DATE(Tran_date,"%d-%m-%Y") ;


ALTER TABLE Transactions 
MODIFY Tran_date DATE ;


/* With the above queries we made the following changes to the Tran_date Column 
 1) Check for any Format discrepancy
 2) Converetd all values in DOB column in singular format.ie "dd-mm-yyyy"
 3) Updated the date format from dd-mm-yyyy to yyyy-mm-dd
 4) Aleterd the data type for DOB Column to DATE from string. 
 */

-- b) Removing - values from the Qty,Rate,Tax,Total_amt Columns.

SELECT * FROM Transactions ;

SELECT TRIM("-" FROM QTY) 
FROM Transactions ;

UPDATE Transactions 
SET QTY =  TRIM("-" FROM QTY),
Rate = TRIM("-" FROM Rate),
Tax = TRIM("-" FROM Tax),
Total_amt = TRIM("-" FROM Total_amt) ;

/* With the above queries we made the following changes to Qty, Rate, Tax, Total_amt columns
 1) Check for any Format discrepancy
 2) Converetd all values & removing the "-" values 
 3) Updated the coloumns data
 */




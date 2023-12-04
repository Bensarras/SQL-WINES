CREATE DATABASE wine_db;
-- we create de databe for the use later-- 
USE wine_db;
CREATE TABLE wine_sales (
    Product_ID INT,
    Quantity INT,
    Customer_Name VARCHAR(255),
    Email VARCHAR(255),
    Country VARCHAR(100),
    Wine_Type VARCHAR(100),
    Size_Type VARCHAR(100),
    Bottle_Size_ML INT,
    Bottle_Price DECIMAL(10, 2),
    Sales DECIMAL(10, 2),
    Cup_Size VARCHAR(100),
    Loyalty_Card BOOLEAN
);
-- We added the missing values
ALTER TABLE wine_sales
ADD COLUMN Order_ID INT AFTER Product_ID,
ADD COLUMN Order_Date DATE AFTER Order_ID,
ADD COLUMN Customer_ID INT AFTER Customer_Name;
-- select the table to see if the data was imported correctly
SELECT * from wine_sales;

-- Now we will proceed to clean the dataset more and make it ready
-- We will check for duplicates firs
SELECT Customer_Name, Email, COUNT(*)
FROM wine_sales
GROUP BY Customer_Name, Email
HAVING COUNT(*) > 1;

-- also we will check for null values-- 
SELECT *
FROM wine_sales
WHERE Product_ID IS NULL OR Quantity IS NULL OR Customer_Name IS NULL OR Email IS NULL;

-- Now that we see there is no null values we can keep working with the data bas

-- we are gonna keep cleaning the dataset now we will check for invalid emails
SELECT *
FROM wine_sales
WHERE Email NOT LIKE '%_@__%.__%';
-- input the bottle prices
SET SQL_SAFE_UPDATES = 0;
UPDATE wine_sales

SET Bottle_Price = CASE 
    WHEN Size_Type = 'L' AND Wine_Type = 'Carbenet Sauvignon' THEN 250
    WHEN Size_Type = 'M' AND Wine_Type = 'Carbenet Sauvignon' THEN 180
    WHEN Size_Type = 'S' AND Wine_Type = 'Carbenet Sauvignon' THEN 100
    ELSE Bottle_Price
END
WHERE Wine_Type = 'Carbenet Sauvignon';
-- Show and count the countrys
SELECT Country, COUNT(*) AS Number_of_Entries
FROM wine_sales
GROUP BY Country;

-- Check the customers and how many purchases they did
SELECT Customer_Name, COUNT(*) AS Number_of_Purchases
FROM wine_sales
GROUP BY Customer_Name;

-- now we will see each quantity per type of wine
SELECT Wine_Type, SUM(Quantity) AS Total_Quantity
FROM wine_sales
GROUP BY Wine_Type;
-- See the biggest customer
SELECT Customer_Name, COUNT(*) AS Number_of_Orders
FROM wine_sales
GROUP BY Customer_Name
ORDER BY Number_of_Orders DESC
LIMIT 1;

-- See customers by id and check they amount of orders and wine type
SELECT Customer_ID, Wine_Type, COUNT(*) AS Number_of_Orders
FROM wine_sales
GROUP BY Customer_ID, Wine_Type
ORDER BY Wine_Type, Number_of_Orders DESC;


--  find the customer who ordered the most of each wine type

SELECT Wine_Type, Customer_ID, MAX(Number_of_Orders) as Most_Orders
FROM (
    SELECT Customer_ID, Wine_Type, COUNT(*) AS Number_of_Orders
    FROM wine_sales
    GROUP BY Customer_ID, Wine_Type
) AS SubQuery
GROUP BY Wine_Type;
-- The most sold winen and wine type
SELECT Wine_Type, Size_Type, COUNT(*) AS Total_Orders
FROM wine_sales
GROUP BY Wine_Type, Size_Type
ORDER BY Total_Orders DESC
LIMIT 1;
-- The least sold winen and wine type
SELECT Wine_Type, Size_Type, COUNT(*) AS Total_Orders
FROM wine_sales
GROUP BY Wine_Type, Size_Type
ORDER BY Total_Orders ASC
LIMIT 1;










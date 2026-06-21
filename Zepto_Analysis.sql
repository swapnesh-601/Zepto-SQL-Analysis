DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150),
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--DATA EXPLORATION

--Seeing the data
SELECT * FROM zepto;

--Counting the number of rows
SELECT  COUNT(*) FROM zepto;

--null values
SELECT * FROM zepto
WHERE sku_id IS NULL
OR 
category IS NULL
OR 
name IS NULL
OR 
mrp IS NULL
OR 
discountPercent IS NULL
OR 
availableQuantity IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
outOfStock IS NULL
OR 
quantity IS NULL;

--Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY 1;

--Product in stock vs out of stock
SELECT outOfStock,
COUNT(sku_id)
FROM zepto
GROUP BY 1;

--Product names present multiple time
-- Product names present multiple times
SELECT
    name,
    COUNT(sku_id) AS "Number of SKU's"
FROM zepto
GROUP BY 1
HAVING COUNT(sku_id) > 1
ORDER BY 2 DESC;

--DATA CLEANING

--Product with price = 0
SELECT * FROM zepto
WHERE mrp =0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp=0;

--Convert paise to rupees
UPDATE zepto 
SET mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

--Checking after converting rupees to paise
SELECT mrp,
discountedSellingPrice
FROM zepto;

--BUSINESS QUESTIONS

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,
discountpercent
FROM zepto
ORDER BY 2 DESC
LIMIT 10;

-- Q2. What are the products with high MRP but out of stock?
SELECT name,
mrp,
outOfStock
FROM zepto
WHERE outOfStock = TRUE
ORDER BY mrp DESC;

-- Q3. Calculate estimated revenue for each category.
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name,
mrp,
discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC,discountpercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountpercent),2) AS average_discount
FROM zepto
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,
weightInGms,
discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name,
weightInGms,
CASE WHEN weightInGms<1000 THEN 'Low'
WHEN weightInGms<5000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto; 

-- Q8. What is the total inventory weight per category?
SELECT category,
SUM(weightinGms*availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;





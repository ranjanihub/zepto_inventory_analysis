drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--NULL VALUES
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
discountedsellingprice IS NULL
OR
availablequantity IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock and out of stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count (sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning 

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0

SELECT mrp,discountedsellingprice FROM zepto

--product which have higest percentage
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--CHECKING HIGH MRP IS OUT OF STOCK
SELECT DISTINCT NAME, MRP
FROM ZEPTO
WHERE OUTOFSTOCK = TRUE AND MRP>300
ORDER BY MRP DESC;

--ESTIMATE REVENUE FOR ALL 
SELECT CATEGORY,
SUM(discountedsellingprice * AVAILABLEQUANTITY) AS TOTAL_REVENUE
FROM ZEPTO
GROUP BY CATEGORY
ORDER BY TOTAL_REVENUE;

-- PRODUCT HAVING LESS DISCOUNT
SELECT DISTINCT NAME,MRP, discountpercent
FROM ZEPTO
WHERE MRP > 500 AND discountpercent < 10
ORDER BY MRP DESC, discountpercent DESC;

--PRODUCT WITH HIGEST DISCOUNT
SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--PRICE PER GRAMS 
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightinGms,2) As price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--PRODUCT GROUPING BASED ON WEIGHT LIKE LOW, MEDIUM AND BULK
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 Then 'low'
	when weightInGms < 5000 then 'medium'
	else 'Bulk'
	end as weight_category
FROM zepto;

--TOTAL QUANTITY IN CATEGORY
SELECT category,
SUM(weightInGms * availableQuantity) As total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight
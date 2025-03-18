DROP TABLE IF EXISTS cafe_data;


CREATE TABLE cafe_data(
Transaction_id VARCHAR(20),
Item	CHAR(10),
Quantity CHAR(10),	
Price_per_unit	CHAR(10),
Total_spent	CHAR(10),
Payment_method	CHAR(20),
location	CHAR(10),
Transaction_date VARCHAR(20)
);

SELECT * FROM cafe_data;

-- checking null values in each column -- 
SELECT 
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS transaction_id_nulls,
    SUM(CASE WHEN item IS NULL THEN 1 ELSE 0 END) AS item_nulls,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS price_per_unit_nulls,
    SUM(CASE WHEN total_spent IS NULL THEN 1 ELSE 0 END) AS total_spent_nulls,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS payment_method_nulls,
    SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS location_nulls,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS transaction_date_nulls
FROM cafe_data;

-- Changing the words like "ERROR" or "UNKNOWN" to null --

UPDATE cafe_data
SET 
    quantity = CASE WHEN quantity IN ('ERROR', 'UNKNOWN') THEN NULL ELSE quantity END,
	item = CASE WHEN item IN ('ERROR', 'UNKNOWN') THEN NULL ELSE item END,
	price_per_unit = CASE WHEN price_per_unit IN ('ERROR', 'UNKNOWN') THEN NULL ELSE price_per_unit END,
	total_spent = CASE WHEN total_spent IN ('ERROR', 'UNKNOWN') THEN NULL ELSE total_spent END,
	payment_method = CASE WHEN payment_method IN ('ERROR', 'UNKNOWN') THEN NULL ELSE payment_method END,
    location = CASE WHEN location IN ('ERROR', 'UNKNOWN') THEN NULL ELSE location END,
    transaction_date = CASE WHEN transaction_date IN ('ERROR', 'UNKNOWN') THEN NULL ELSE transaction_date END;

-- Changing the datatyes of columns --
ALTER TABLE cafe_data
ALTER COLUMN quantity TYPE INT USING quantity::integer,
ALTER COLUMN price_per_unit TYPE DECIMAL(10,2) USING price_per_unit::numeric,
ALTER COLUMN total_spent TYPE DECIMAL(10,2) USING total_spent::numeric,
ALTER COLUMN transaction_date TYPE DATE USING transaction_date::DATE;
;

SELECT * FROM cafe_data LIMIT 20;

-- Updating null values in item column with "SomeItem" --

UPDATE cafe_data
SET item = 'SomeItem'
WHERE item IS NULL;

-- Updating quantity column --
UPDATE cafe_data
SET quantity = total_spent / price_per_unit
WHERE quantity IS NULL 
AND price_per_unit IS NOT NULL 
AND total_spent IS NOT NULL;

-- Updating total_spent column -- 
UPDATE cafe_data
SET total_spent = quantity * price_per_unit
WHERE total_spent IS NULL 
AND price_per_unit IS NOT NULL 
AND quantity IS NOT NULL;

-- Updating price_per_unit column -- 
UPDATE cafe_data
SET price_per_unit = total_spent / quantity 
WHERE price_per_unit IS NULL 
AND total_spent IS NOT NULL 
AND quantity IS NOT NULL;

-- How many rows have all three empty columns -- 
SELECT COUNT(*) 
FROM cafe_data
WHERE quantity IS NULL 
   OR price_per_unit IS NULL 
   OR total_spent IS NULL;

-- Deleting these rows -- 
DELETE FROM cafe_data
WHERE quantity IS NULL 
   OR price_per_unit IS NULL 
   OR total_spent IS NULL;

-- Dealing with empty rows of location column -- 
WITH location_proportions AS (
    SELECT 
        location, 
        COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS probability
    FROM cafe_data
    WHERE location IS NOT NULL
    GROUP BY location
)
UPDATE cafe_data
SET location = (
    SELECT location 
    FROM location_proportions
    ORDER BY RANDOM()
    LIMIT 1
)
WHERE location IS NULL;

-- Dealing with empty rows of payment_method column -- 
WITH payment_proportions AS (
    SELECT 
        payment_method, 
        COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS probability
    FROM cafe_data
    WHERE payment_method IS NOT NULL
    GROUP BY payment_method
)

UPDATE cafe_data
SET payment_method = (
    SELECT payment_method 
    FROM payment_proportions
    ORDER BY RANDOM()
    LIMIT 1
)
WHERE payment_method IS NULL;



-- Deleting rows with null Transaction_date -- 
DELETE FROM cafe_data 
WHERE transaction_date IS NULL;

-- Checking for nulls again --
SELECT 
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS transaction_id_nulls,
    SUM(CASE WHEN item IS NULL THEN 1 ELSE 0 END) AS item_nulls,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS price_per_unit_nulls,
    SUM(CASE WHEN total_spent IS NULL THEN 1 ELSE 0 END) AS total_spent_nulls,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS payment_method_nulls,
    SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS location_nulls,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS transaction_date_nulls
FROM cafe_data;




















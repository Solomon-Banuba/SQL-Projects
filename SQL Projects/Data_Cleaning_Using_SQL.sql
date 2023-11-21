-- DATA CLEANING/WRANGLING WITH SQL

/* Data Cleaning process 
		1. Renaming Columns
        2. Remove irrelevant data
		2. Remove duplicate data
		3. Fix structural errors
		4. Do type conversion
		5. Handle missing data
		6. Deal with outliers
		7. Standardize/Normalize data
		8. Validate data
*/



USE germanusedcars;

SELECT * FROM used_cars;



						-- 	#1. RENAMING COLUMNS

-- Inspecting Columns Names 
SHOW COLUMNS FROM used_cars;

-- Renaming columns to be more consistent and intuitive
ALTER TABLE table_name 
RENAME COLUMN old_column_name TO new_column_name;

ALTER TABLE used_cars
RENAME COLUMN   MyUnknownColumn TO  id,
RENAME COLUMN price_in_euro TO price,
RENAME COLUMN year TO year_made;

SELECT * FROM used_cars;


					-- #2. CHECKING AND REMOVING DUPLICATES

-- 4 way to check for duplicates

-- OPTION 1: Using DISTINCT  + COUNT 
SELECT 
	 DISTINCT id,
     COUNT(*) AS id_count
FROM used_cars
GROUP BY id
ORDER BY id_count DESC;


-- OPTION #2: Using HAVING Clause
SELECT 
	 id,
     brand,
     model,
     color,
     COUNT(*) AS count
FROM used_cars
GROUP BY 
	 id,
     brand,
     model,
     color
HAVING COUNT(*) > 1
ORDER BY id;


-- OPTION #3: Use Windows function: ROW_NUMBER
SELECT 
    *, 
    ROW_NUMBER() OVER ( 
        PARTITION BY  id, brand, model, color
        ORDER BY id, brand, model, color
        ) AS rn
FROM used_cars;



-- OPTION #4: Using CTE
WITH cte AS 
	(
       SELECT 
           *, 
           ROW_NUMBER() OVER ( 
			PARTITION BY  id, brand, model, color
			ORDER BY id, brand, model, color
			) AS rn
FROM used_cars
)
SELECT * FROM cte WHERE rn <> 1;


-- FIND INCONSISTENT DATA TYPE AND CONVERT THEM.
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'germanusedcars' and table_name = 'used_cars';
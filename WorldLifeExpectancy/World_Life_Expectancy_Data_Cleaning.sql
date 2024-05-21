# Project : World Life Expectancy (Data Cleaning)

SELECT * 
FROM world_life_expectancy.world_life_expectancy
;

# Step 1 : Removing Duplicates
# 1. Identify duplicates
SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy.world_life_expectancy
GROUP BY country, year, CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1 
;
# 2. Remove Duplicates

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS Row_Num
	FROM world_life_expectancy.world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy.world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID,
    CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS Row_Num
	FROM world_life_expectancy.world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
)
;

# Identifying the blanks

SELECT * 
FROM world_life_expectancy.world_life_expectancy
WHERE Status = ''
;

SELECT DISTINCT (Status)
FROM world_life_expectancy.world_life_expectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country) 
FROM world_life_expectancy.world_life_expectancy
WHERE Status = 'Developing'
;

UPDATE world_life_expectancy.world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
				SELECT DISTINCT(Country) 
				FROM world_life_expectancy.world_life_expectancy
				WHERE Status = 'Developing'
				)
;

UPDATE world_life_expectancy.world_life_expectancy t1
JOIN world_life_expectancy.world_life_expectancy t2
	ON t1.country = t2.country 
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

SELECT * 
FROM world_life_expectancy.world_life_expectancy
WHERE Country = 'United States of America'
;

UPDATE world_life_expectancy.world_life_expectancy t1
JOIN world_life_expectancy.world_life_expectancy t2
	ON t1.country = t2.country 
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

# Checking NULL

SELECT * 
FROM world_life_expectancy.world_life_expectancy
WHERE Status IS NULL
;

SELECT * 
FROM world_life_expectancy.world_life_expectancy
#WHERE `Life expectancy` = ''
;

SELECT country, year, `Life expectancy`
FROM world_life_expectancy.world_life_expectancy
#WHERE `Life expectancy` = ''
;

SELECT t1.country, t1.year, t1.`Life expectancy`, 
t2.country, t2.year, t2.`Life expectancy`, 
t3.country, t3.year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
FROM world_life_expectancy.world_life_expectancy t1
JOIN world_life_expectancy.world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy.world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1
WHERE t1.`Life expectancy` = ''
;


UPDATE world_life_expectancy.world_life_expectancy t1
JOIN world_life_expectancy.world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy.world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1 
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
WHERE t1.`Life expectancy` = ''
;
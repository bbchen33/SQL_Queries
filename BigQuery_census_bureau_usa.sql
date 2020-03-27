# Examine population with zipcode = 80024
SELECT *
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '80024'
LIMIT 100

# Total population at zipcode 80024
SELECT SUM(population) AS total_population
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '80024'
GROUP BY zipcode
LIMIT 100

# Order data by total population from each zipcode
SELECT zipcode, SUM(population) AS total_population
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
GROUP BY 1
ORDER BY 2 DESC
LIMIT 100

# Zipcode with biggest population increase between 2010 and 2000
SELECT t1.zipcode, t1,population, sub.new_population, (sub.new_population - t1.population) AS difference
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2000 t1
JOIN
(SELECT zipcode, population AS new_population
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010 t2) AS sub
ON t1.zipcode = sub.zipcode
ORDER BY 4 DESC
LIMIT 100

# Padding short zipcode with 0 at front
SELECT lpad(zipcode, 5, '0') AS good_zipcode
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
LIMIT 100

# Using a subquery and a window function to get the 4th quartile of the maximum age
SELECT * FROM 
(SELECT zipcode, maximum_age, NTILE(4) OVER (ORDER BY maximum_age) AS quartile
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE maximum_age IS NOT NULL 
ORDER BY 3) AS sub
WHERE sub.quartile = 4
LIMIT 100




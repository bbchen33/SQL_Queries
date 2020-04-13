# Determine number of cases by country
SELECT country_region, SUM(confirmed) AS cases
FROM bigquery-public-data.covid19_jhu_csse_eu.summary
WHERE date = '2020-04-12'
GROUP BY country_region
ORDER BY 2 DESC

# The country with the highest case numbers in April 2020
SELECT country_region, SUM(_4_1_20 + _4_2_20 + _4_3_20 + _4_4_20 + _4_5_20 + _4_6_20 + _4_7_20 + _4_8_20 + _4_9_20 + _4_10_20 + _4_11_20 + _4_12_20) AS april_sum
FROM bigquery-public-data.covid19_jhu_csse_eu.confirmed_cases
GROUP BY country_region
ORDER BY 2 DESC

# Window function can help finding out how the case/death/recovered number grows over time by country
SELECT country_region, date,
       SUM(confirmed) OVER (PARTITION BY country_region ORDER BY date) AS case_number,
       SUM(deaths) OVER (PARTITION BY country_region ORDER BY date) AS death_number,
       SUM(recovered) OVER (PARTITION BY country_region ORDER BY date) AS recovered_number
FROM bigquery-public-data.covid19_jhu_csse_eu.summary
WHERE country_region = 'US'

# The average recovery rate by country as of 4/12/2020
SELECT country_region, date, 
       ROUND(100*SUM(recovered)/SUM(confirmed),2) AS recovery_rate
FROM bigquery-public-data.covid19_jhu_csse_eu.summary
WHERE date = '2020-04-12'
GROUP BY 1, 2
ORDER BY 3 DESC

# Count how number of affected countries change over time 
SELECT date, COUNT(DISTINCT country_region) AS country_count
FROM bigquery-public-data.covid19_jhu_csse_eu.summary
GROUP BY date
ORDER BY 1

# Subquery to see the countries with more total number of deaths than the total number of cases in India
SELECT country_region, SUM(deaths) AS total_deaths
FROM bigquery-public-data.covid19_jhu_csse_eu.summary
WHERE date = '2020-04-12'
GROUP BY 1
HAVING SUM(deaths) > (
SELECT SUM(confirmed) FROM bigquery-public-data.covid19_jhu_csse_eu.summary
WHERE country_region = 'India' and date = '2020-04-12'
GROUP BY country_region, date
)
ORDER BY 2 DESC



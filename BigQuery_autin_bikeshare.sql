/* BigQuery public dataset - austin_bikeshare.bikeshare_trips */

-- Examine data --
SELECT *
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
LIMIT 100

-- Average ride legnth (round up to 2nd decimal place) --
SELECT ROUND(AVG(duration_minutes), 2) AS avg_ride
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
LIMIT 100

-- Bike station ordered by the checkout rate -- 
SELECT start_station_id, start_station_name, COUNT(*) AS check_out_count
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 100

-- Bike station ordered by the checkout rate where the subscriber_type is Walk Up --
SELECT start_station_id, start_station_name, COUNT(*) AS check_out_count
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
WHERE subscriber_type = 'Walk Up'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 100

-- --


-- Window function to get the cumulative duration time grouped by station_id and ordered by start_time --
SELECT start_station_id, start_time,
       SUM(duration_minutes) OVER (PARTITION BY start_station_id ORDER BY start_time) AS cumulative_duration
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
WHERE start_station_id IS NOT NULL
LIMIT 100

-- Window function like above but with ranking --
SELECT start_station_id, start_time,
       SUM(duration_minutes) OVER (PARTITION BY start_station_id ORDER BY start_time) AS cumulative_duration, 
       RANK() OVER (PARTITION BY start_station_id ORDER BY start_time) AS rank
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
WHERE start_station_id IS NOT NULL
LIMIT 100


-- Number of checkout from each station and the station's status --
-- Use Join to merge bikeshare_trips and bikeshare_stations --
SELECT t.start_station_id, COUNT(*) AS events, s.status
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips t
JOIN bigquery-public-data.austin_bikeshare.bikeshare_stations s
ON t.start_station_id = s.station_id
GROUP BY t.start_station_id, s.status
LIMIT 100

-- Select events that had duration_minutes > average duration_minutes using subquery --
SELECT bikeid, duration_minutes
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
WHERE duration_minutes >(
SELECT AVG(duration_minutes) AS avg_duration
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips)
LIMIT 100


--Users by country--
SELECT DATE_TRUNC('day', e.occurred_at),
       location,
       COUNT(*) 
FROM tutorial.yammer_events e
JOIN tutorial.yammer_users u
ON e.user_id = u.user_id
AND e.occurred_at >= '2014-05-01'
AND e.occurred_at < '2014-09-01'
GROUP BY 1,2
ORDER BY 1,2

--Users by country2 (list count of each country in separate column for easy plotting)--
SELECT DATE_TRUNC('day', e.occurred_at),
       COUNT(CASE WHEN location = 'Argentina' THEN 'Arg' END) AS Arg_count,
       COUNT(CASE WHEN location = 'Australia' THEN 'Au' END) AS Au_count,
       COUNT(CASE WHEN location = 'Belgium' THEN 'Bel' END) AS Bel_count,
       COUNT(CASE WHEN location = 'Brazil' THEN 'Bra' END) AS Bra_count
FROM tutorial.yammer_events e
JOIN tutorial.yammer_users u
ON e.user_id = u.user_id
AND e.occurred_at >= '2014-05-01'
AND e.occurred_at < '2014-09-01'
GROUP BY 1
ORDER BY 1
--Users by experimental group
SELECT DATE_TRUNC('day',e.occurred_at) AS day,
       COUNT(CASE WHEN ex.experiment_group = 'control_group' THEN 'control' END) AS control,
       COUNT(CASE WHEN ex.experiment_group = 'test_group' THEN 'test' END) AS test
FROM tutorial.yammer_emails e
JOIN tutorial.yammer_users u 
ON e.user_id = u.user_id

JOIN tutorial.yammer_experiments ex 
ON e.user_id = ex.user_id
GROUP BY 1
ORDER BY 1

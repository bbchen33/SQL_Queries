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

INSERT INTO mamontesp.hosts_cumulated
WITH yesterday AS (
SELECT 
	*
FROM mamontesp.hosts_cumulated
WHERE date = DATE('2021-01-07')
),

today AS (
SELECT
	host
	, ARRAY_AGG(DISTINCT CAST(DATE_TRUNC('day', event_time) AS DATE)) as host_activity_datelist
	, CAST(DATE_TRUNC('day', event_time) AS DATE) as date
FROM bootcamp.web_events
WHERE DATE_TRUNC('day', event_time) = DATE('2021-01-08')
GROUP BY 1, 3
)

SELECT 
	COALESCE(t.host, y.host) as host
	, CASE WHEN y.host_activity_datelist IS NOT NULL
	THEN COALESCE(t.host_activity_datelist, ARRAY[]) || y.host_activity_datelist
	ELSE t.host_activity_datelist
	END AS host_activity_datelist
	, DATE('2021-01-08') AS date
FROM yesterday AS y
FULL OUTER JOIN today AS t
ON y.host = t.host

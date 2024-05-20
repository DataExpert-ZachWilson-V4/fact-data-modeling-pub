WITH yesterday AS (
	SELECT *
	FROM dataste0.host_activity_reduced
	WHERE month_start = '2023-01-01'
),
today AS (
	SELECT *
	FROM dataste0.daily_web_metrics
	WHERE date = DATE('2023-01-02')
)

SELECT 
	COALESCE(t.host,y.host) as host,
	COALESCE(t.metric_name,y.metric_name) as metric_name,
	COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2023-01-01'), t.date) AS INTEGER))) || ARRAY[t.metric_value] as metric_value,
	'2023-01-01' as month_start
FROM yesterday y
FULL OUTER JOIN today t 
ON y.host=t.host AND y.metric_name=t.metric_name

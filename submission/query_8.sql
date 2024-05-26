-----incremental insert for host_activity_reduced
INSERT INTO mamontesp.host_activity_reduced
WITH yesterday AS (
SELECT
	  host
	, metric_name
	, metric_array
	, month_start
FROM mamontesp.host_activity_reduced
WHERE month_start = DATE('2021-01-01')
), 

today AS (
SELECT
	  host
	, metric_name
	, CAST(SUM(metric_value) AS INTEGER) AS metric_value
	, DATE_TRUNC('day', date) AS date
	, DATE_TRUNC('month', date) AS month_start
FROM mamontesp.daily_web_metrics
WHERE
DATE_TRUNC('day', date) = DATE('2021-01-02')
GROUP BY 1, 2, 4, 5
)

SELECT 
	  COALESCE(y.host, t.host) AS host
	, COALESCE(y.metric_name, t.metric_name) AS metric_name
	, COALESCE(
		y.metric_array, 
		REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2021-01-01'), t.date ) AS INTEGER))
		) || ARRAY[t.metric_value] AS metric_array
	, t.month_start
FROM yesterday AS y
FULL OUTER JOIN today AS t
ON y.host = t.host
AND y.metric_name = t.metric_name
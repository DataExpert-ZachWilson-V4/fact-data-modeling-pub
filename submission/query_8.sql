INSERT INTO dswills94.host_activity_reduced --to insert into table
WITH yesterday AS(
--setup up yesterday CTE for incremental load
SELECT
	*
FROM
	dswills94.host_activity_reduced
	--table with prior day activity
WHERE
	month_start = '2023-08-01'
	--start of month for host visits
),
today AS (
--setup up yesterday CTE for incremental load
SELECT
	*
FROM
	dswills94.daily_web_metrics
	--table with today's activity
WHERE
	DATE = DATE('2023-08-02')
	--placeholder date for today CTE
)
SELECT
	COALESCE(t.host, y.host) AS host,
	--coalesce to non null host values
	COALESCE(t.metric_name, y.metric_name) AS metric_name,
	--coalesce to non null metric names
	COALESCE(y.metric_array, REPEAT(NULL, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
	--create array of host metrics. With null repeated and calculating date_diff between today and month start (to handle inputing empty values) coalesce yesterday host activity. then conct to today's host activity array
	'2023-08-01' AS month_start
	--track our most start date
FROM
	today t
FULL OUTER JOIN yesterday y
	--we use full outer join to grab yesterday's host activity records and today's record, to grab new host activity, and retired host activity 
ON
	t.host = y.host
	AND t.metric_name = y.metric_name
	--join on host and metric name to find instersecting records plus nulls

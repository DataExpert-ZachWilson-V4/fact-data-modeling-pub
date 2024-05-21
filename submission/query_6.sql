INSERT INTO
	dswills94.hosts_cumulated
	--We load into cumulative table
WITH yesterday AS (
	--build temp table with yesterday 
	SELECT
		*
	FROM
		dswills94.hosts_cumulated
		--we pull yesterday data
	WHERE
		DATE = DATE('2022-12-31')
		--use a prior date as container
),
	today AS (
	--build temp table with today
	SELECT
		host,
		--we pull the host
	CAST(date_trunc('day', event_time) AS DATE) AS event_date,
		--we pull the event time cast as date
		COUNT(1)
		--we are doing aggregate because we are grouping
	FROM
		bootcamp.web_events
		--we pull columns from this table
	WHERE
		date_trunc('day', event_time) = DATE('2023-01-01')
		--we need today's date
	GROUP BY
		host,
		CAST(date_trunc('day', event_time) AS DATE)
		--group by host, and event time
)
SELECT
	COALESCE(y.host, t.host) AS host,
	--we coalesce null host values from yesterday and today
	CASE
		WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
		ELSE ARRAY[t.event_date]
	END AS host_activity_datelist,
	--if host has activity yesterday, then concat today's event_date with yesterdays host_activity_datelist in an array, else bring just today's event_date
	DATE('2023-01-01') AS DATE
	--we bring our partition
FROM
	yesterday y
FULL OUTER JOIN today t
ON
	y.host = t.host
	--we use full outer join to grab yesterday's host activity records and today's host activity record record, to grab new host activity, and retired host activity (no new activity)

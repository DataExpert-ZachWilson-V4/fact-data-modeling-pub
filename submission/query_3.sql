INSERT INTO
	dswills94.user_devices_cumulated
	--We load into cumulative
WITH yesterday AS (
	--build temp table with yesterday 
	SELECT
		*
	FROM
		dswills94.user_devices_cumulated
		--we pull yesterday data
	WHERE
		DATE = DATE('2022-12-31')
		--use a prior date as container
),
	today AS (
	--build temp table with today
	SELECT
		wbe.user_id,
		--we pull the user id
		d.browser_type,
		--we pull browser type
	CAST(date_trunc('day',
		wbe.event_time) AS DATE) AS event_date,
		--we pull the event date
		COUNT(1)
		--we are doing aggregate because we are grouping
	FROM
		bootcamp.web_events wbe
		--we pull columns from this table
	INNER JOIN bootcamp.devices d
		--we join with devices as we pull browser type
	ON
		wbe.device_id = d.device_id
		--one to one relationship to join table
	WHERE
		date_trunc('day', wbe.event_time) = DATE('2023-01-01')
		--we need today's date
	GROUP BY
		wbe.user_id,
		d.browser_type,
		CAST(date_trunc('day', wbe.event_time) AS DATE)
		--group by user, browser type, and event time
)
SELECT
	COALESCE(y.user_id, t.user_id) AS user_id,
	--we coalesce null user_id values from yesterday and today
	COALESCE(y.browser_type, t.browser_type) AS browser_type,
	--we coalesce null browser_type values from yesterday and today
	CASE
		WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
		ELSE ARRAY[t.event_date]
	END AS dates_active,
	--if user is active yesterday, then concat today's event_date with yesterdays dates_active array, else bring just today's event_date
	DATE('2023-01-01') AS DATE
	--we bring our partition
FROM
	yesterday y
FULL OUTER JOIN today t
ON
	y.user_id = t.user_id
	--we use full outer join to grab user's yesterday's records and today's record, to grab new users, and retired users

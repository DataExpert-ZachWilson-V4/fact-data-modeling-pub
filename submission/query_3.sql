--- DML to populate above query
DELETE FROM mamontesp.user_devices_cumulated

INSERT INTO mamontesp.user_devices_cumulated
WITH yesterday AS (
	SELECT 
		*
	FROM mamontesp.user_devices_cumulated
	WHERE date = DATE('2021-01-06')
), 
today AS (
	SELECT 
		we.user_id
		-- One entry map per each browser used in a given day
		, map_agg(d.browser_type, ARRAY[CAST(DATE_TRUNC('day', we.event_time) AS DATE)]) AS dates_active_by_browser
	FROM bootcamp.web_events AS we
	LEFT JOIN bootcamp.devices AS d
	ON we.device_id = d.device_id
	WHERE DATE_TRUNC('day', we.event_time) = DATE('2021-01-07')
	GROUP BY 1
)

SELECT
	COALESCE(y.user_id, t.user_id) AS user_id
	, MAP_ZIP_WITH(
		COALESCE(y.dates_active_by_browser, MAP(ARRAY[], ARRAY[]))
		, COALESCE(t.dates_active_by_browser, MAP(ARRAY[], ARRAY[]))
		, (k, v1, v2) ->  COALESCE(v2, ARRAY[]) || COALESCE(v1, ARRAY[])
		) AS dates_active_by_browser
	, DATE('2021-01-07') AS date
FROM yesterday AS Y
FULL OUTER JOIN today AS t
ON y.user_id = t.user_id

-- Test query
SELECT * FROM mamontesp.user_devices_cumulated
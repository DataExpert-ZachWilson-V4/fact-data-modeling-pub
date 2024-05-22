/* Write a query to incrementally populate the hosts_cumulated table from the web_events table. */

INSERT INTO hosts_cumulated
-- Retrieve existing data 
WITH yesterday AS (
    SELECT 
    	*
    FROM hosts_cumulated
    WHERE date = DATE('2023-05-21')
),
-- CTE to retrieve aggregated host count by day
hosts_aggregated AS (
	SELECT 
		host,
		CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date,
		-- track number of hosts per day
		COUNT(*) AS host_count
FROM bootcamp.web_events
GROUP BY 
	host,
    CAST(DATE_TRUNC('day', event_time) AS DATE)
),
-- CTE to calculate aggregated host count for current day
today AS (
    SELECT 
    	host,
        event_date,
        COUNT(*)
    FROM hosts_aggregated
    WHERE event_date = DATE('2023-05-22')
    GROUP BY 
    	host,
        event_date
)
SELECT 
	COALESCE(y.host, t.host) AS host,
    CASE 
    	-- if new user, create a new record with current date 
    	WHEN y.host_activity_datelist IS NULL THEN ARRAY[t.event_date]
        -- if user exists, append current date record with existing
        ELSE ARRAY[t.event_date] || y.host_activity_datelist
    END AS host_activity_datelist,
    DATE('2023-05-22') AS date
FROM yesterday y
FULL OUTER JOIN today t 
	ON y.host = t.host
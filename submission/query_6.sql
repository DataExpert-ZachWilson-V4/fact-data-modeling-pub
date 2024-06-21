-- This query incrementally populates the 'hosts_cumulated' table from the 'web_events' table.
-- It captures the host activity and updates the 'hosts_cumulated' table with new activity records.
INSERT INTO hosts_cumulated
-- Step 1: Define a CTE to capture the activity for the current day.
WITH today_activity AS (
    SELECT
        host,
        ARRAY_AGG(DISTINCT DATE_TRUNC('day', event_time)) AS dates_active_today
    FROM bootcamp.web_events
    WHERE DATE_TRUNC('day', event_time) = CURRENT_DATE
    GROUP BY host
),

-- Step 2: Select data from the existing 'hosts_cumulated' table for the previous cumulative activity.
     previous_activity AS (
         SELECT
             host,
             host_activity_datelist,
    date
FROM hosts_cumulated
WHERE date = (SELECT MAX(date) FROM hosts_cumulated)
    )

-- Step 3: Combine the new activity with the previous cumulative activity.

SELECT
    COALESCE(pa.host, ta.host) AS host,
    array_distinct(concat(COALESCE(pa.host_activity_datelist, ARRAY[]), COALESCE(ta.dates_active_today, ARRAY[]))) AS host_activity_datelist,
    CURRENT_DATE AS date
FROM
    previous_activity pa
    FULL OUTER JOIN today_activity ta ON pa.host = ta.host

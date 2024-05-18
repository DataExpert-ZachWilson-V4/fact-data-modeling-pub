INSERT INTO videet.user_devices_cumulated 
WITH prev_day AS ( -- Define a CTE named 'prev_day' to retrieve yesterday's data.
  SELECT * -- Retrieves accumulated dates of user activities per browser from the previous day.
  FROM videet.user_devices_cumulated
  WHERE date = DATE('2023-01-01') 
  -- Initial setup, expected to be empty on the first day.
),
current_day AS ( -- Define another CTE for today's data aggregation.
  SELECT 
    we.user_id, -- User identifier from web events.
    CAST(date_trunc('day', we.event_time) AS DATE) AS event_date, -- Truncate to day and cast to date to align with 'dates_active'.
    MAP_AGG(
    d.browser_type,
    ARRAY[CAST(date_trunc('day', we.event_time) AS DATE)]
    ) AS browser_map, -- Maps each browser to a list of dates (today), creating a single-entry array for each.
    COUNT(1) AS event_count -- Counts the total events for each user-browser combination; mainly for debugging.
  FROM bootcamp.web_events AS we
  LEFT JOIN bootcamp.devices AS d
    ON we.device_id = d.device_id
  WHERE CAST(date_trunc('day', we.event_time) AS DATE) = DATE('2023-01-02')
  GROUP BY we.user_id, CAST(date_trunc('day', we.event_time) AS DATE) -- Group by user and truncated event date.
),
combined AS ( -- Combine data from 'prev_day' and 'current_day'.
  SELECT
    COALESCE(p.user_id, c.user_id) AS user_id, -- Ensure user_id is selected whether present in 'prev_day' or 'current_day'.
    CASE
        WHEN p.dates_active IS NULL AND c.browser_map IS NOT NULL THEN c.browser_map
        -- Directly use today's map if no prior data exists.
        WHEN p.dates_active IS NOT NULL AND c.browser_map IS NULL THEN MAP_AGG(p.browser_type, p.dates_active)
        -- Use only yesterday's data if today's data is missing.
        ELSE MAP_ZIP_WITH(
        MAP_AGG(p.browser_type, p.dates_active),
        c.browser_map,
        (k, v1, v2) -> COALESCE(v2, ARRAY[]) || COALESCE(v1, ARRAY[]))
        -- Merge maps from both days, concatenating date arrays, handling nulls.
    END AS browser_map,
    COALESCE(c.event_date, p.date + INTERVAL '1' DAY) AS date -- Set the record's date to today or the next day from yesterday's date.
  FROM prev_day AS p
  FULL OUTER JOIN current_day AS c ON p.user_id = c.user_id
  GROUP BY 1,p.dates_active, c.browser_map, 3-- Grouping necessary to properly combine records.
)
SELECT 
  a.user_id,
  b.browser_type,
  b.dates_active,
  a.date
FROM combined AS a
CROSS JOIN UNNEST(a.browser_map) WITH ORDINALITY AS b (browser_type, dates_active, ordinality)
-- Explode the map into rows for each browser type, maintaining array indices as 'ordinality'.
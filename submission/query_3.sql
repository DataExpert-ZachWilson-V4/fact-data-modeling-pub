INSERT INTO jsgomez14.user_devices_cumulated 
WITH yesterday AS ( -- Define a CTE named yesterday.
  SELECT * -- This contains acumulates per date a list of dates
            -- when the user was active in a specific browser
  FROM jsgomez14.user_devices_cumulated
  WHERE date = DATE('2022-12-31')
  -- If first day, it will be empty.
),
today AS (
  SELECT 
    user_id,
    CAST(date_trunc('day',event_time) AS DATE) AS event_date,
    -- We truncate the event_time to get the date part only.
    -- We cast it to DATE to match the data type of the dates_active column.
    MAP_AGG(
    browser_type,
    ARRAY[CAST(date_trunc('day',event_time) AS DATE)]
    ) AS browser_type_agg,
    -- Aggregate the browser_type and today's date (single value array) into a MAP.
    COUNT(1) AS cnt
    -- Count the number of events per user and browser. 
    -- It won't be used in the final output. It was just for debugging purposes.
  FROM bootcamp.web_events AS WE
  LEFT JOIN bootcamp.devices AS D
    ON WE.device_id = D.device_id
  WHERE CAST(date_trunc('day',event_time) AS DATE) = DATE('2023-01-01')
  GROUP BY 1,2
),
aggregated AS (
  SELECT
    COALESCE(Y.user_id, T.user_id) AS user_id,
    CASE
        WHEN Y.dates_active IS NULL AND T.browser_type_agg IS NOT NULL THEN T.browser_type_agg
        -- If the user was not active yesterday but is active today, we take today's data. Already a Map.
        WHEN Y.dates_active IS NOT NULL AND T.browser_type_agg IS NULL THEN MAP_AGG(Y.browser_type, Y.dates_active)
        -- If the user was active yesterday but is not active today, we take yesterday's data. Convert into a Map.
        ELSE MAP_ZIP_WITH(
        MAP_AGG(Y.browser_type, Y.dates_active),
        T.browser_type_agg,
        (k, v1, v2)->  COALESCE(v2,ARRAY[]) || COALESCE(v1, ARRAY[]))
        -- If the user was active both days, we merge the two maps by key.
        -- We concatenate the arrays. Avoid nulls by using COALESCE and concat an empty array.
    END AS browser_type_agg,
    COALESCE(T.event_date, Y.date + INTERVAL '1' DAY) AS date
  FROM yesterday AS Y
  FULL OUTER JOIN today AS T ON Y.user_id = T.user_id
  GROUP BY 1, Y.dates_active, T.browser_type_agg, 3
)
SELECT 
  A.user_id,
  B.browser_type,
  B.dates_active,
  A.date
FROM aggregated AS A
CROSS JOIN UNNEST(A.browser_type_agg) WITH ORDINALITY AS B (browser_type, dates_active, ind)
-- Unnest the MAP into rows. We use WITH ORDINALITY to get the key, value pairs
-- and be able to obtain the desired schema.

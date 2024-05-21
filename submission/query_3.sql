INSERT INTO mmarquez225.user_devices_cumulated 
WITH yesterday AS (
  SELECT * -- This gives us the dates when the user was active in a specific browser
  FROM mmarquez225.user_devices_cumulated
  WHERE date = DATE('2022-12-31') -- This is for the initial run or if it is empty
),
today AS (
  SELECT 
    user_id,
    CAST(date_trunc('day',event_time) AS DATE) AS event_date,
    MAP_AGG(
    browser_type,
    ARRAY[CAST(date_trunc('day',event_time) AS DATE)]
    ) AS browser_type_agg
    -- This is to aggregate browser type and todays date 
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
        -- this is to see if user was active today but not yesterday in that case we take todays date
        WHEN Y.dates_active IS NOT NULL AND T.browser_type_agg IS NULL THEN MAP_AGG(Y.browser_type, Y.dates_active)
        -- same logic as above just taking yesterdays date
        ELSE MAP_ZIP_WITH(
        MAP_AGG(Y.browser_type, Y.dates_active),
        T.browser_type_agg,
        (k, v1, v2)->  COALESCE(v2,ARRAY[]) || COALESCE(v1, ARRAY[]))
        -- this if the user was active both the days so we merge the two
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
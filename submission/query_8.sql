-- Reduced Host Fact Array Implementation (`query_8.sql`)

-- a query to incrementally populate the `host_activity_reduced` table from a `daily_web_metrics` table. 
-- Assume `daily_web_metrics` exists in your query. Don't worry about handling the overwrites or deletes for overlapping data.
-- Remember to leverage a full outer join, and to properly handle imputing empty values in the array for windows 
--    where a host gets a visit in the middle of the array time window.

-- unlike other tables, we will be upserting
-- populated three dates - 8/1 to 8/3 with cleanup of extra rows
INSERT INTO siawayforward.host_activity_reduced
WITH yesterday AS (

  SELECT *
  FROM siawayforward.host_activity_reduced
  WHERE month_start = '2023-08-01'

), today AS (

  SELECT *
  FROM siawayforward.daily_web_metrics
  WHERE date = DATE('2023-08-03')

)
SELECT
  COALESCE(y.host, t.host) AS host,
  COALESCE(y.metric_name, t.metric_name) AS metric_name,
  COALESCE(
    -- if there was something yesterday
    y.metric_array, 
    -- if there was nothing, we want to blank fill the array so it has the same length for everyone
    REPEAT(NULL, 
    -- use number of empty days to fill in the nulls
    CAST( 
      DATE_DIFF('DAY', DATE('2023-08-01'), t.date)
    AS INTEGER)
    )
    ) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM today t
FULL OUTER JOIN yesterday y
  ON t.host = y.host
  AND t.metric_name = y.metric_name


-- cleanup query for lack of a better upsert method
-- DELETE FROM siawayforward.host_activity_reduced
-- WHERE CARDINALITY(metric_array) < 3
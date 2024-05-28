-- Inserts rows into videet.host_activity_reduced from daily metrics table
INSERT INTO videet.host_activity_reduced
WITH yesterday AS (
  -- Selects all entries from the 'host_activity_reduced' table for the start of the month.
  SELECT *
  FROM videet.host_activity_reduced
  WHERE month_start = '2023-02-01'  -- Targeting data for February 2023.
),
today AS (
  -- Selects all entries from the 'daily_web_metrics' table for the specific day.
  SELECT 
    host,
    metric_name,
    metric_array AS metric_value,  -- Assuming metric_array is already an array of integers.
    date
  FROM videet.daily_web_metrics
  WHERE date = DATE('2023-02-02')  -- Focusing on metrics recorded on February 2, 2023.
)

-- Final SELECT statement to merge 'yesterday' and 'today' data and prepare the update/insert for the 'host_activity_reduced' table
SELECT
  COALESCE(t.host, y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  -- Concatenate arrays safely, handle NULL cases explicitly
  COALESCE(y.metric_array, CAST(ARRAY[] AS ARRAY(INTEGER))) || t.metric_value AS metric_array,  -- Direct concatenation of arrays, handling NULLs with an empty array initialization
  '2023-02-01' AS month_start
FROM
  today t
FULL OUTER JOIN 
  yesterday y 
ON 
  t.host = y.host AND t.metric_name = y.metric_name
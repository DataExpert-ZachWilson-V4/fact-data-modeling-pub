--query_8
INSERT INTO qhamzah.host_activity_reduced
WITH
  -- Select previously backfilled data for the specified month
  yesterday AS (
    SELECT *
      FROM qhamzah.host_activity_reduced
     WHERE month_start = '2023-08-01'
  ),
  -- Select new data to be loaded for the specified date
  today AS (
    SELECT *
      FROM qhamzah.daily_web_metrics
     WHERE date = DATE('2023-08-02')
  )

-- Combine data from 'yesterday' and 'today'
SELECT
  COALESCE(t.host, y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  -- Combine metric arrays: if 'yesterday' array is not null, append 'today' metric value; otherwise, create an array of nulls up to the date and append the 'today' metric value
  COALESCE(
    y.metric_array,
    REPEAT(
      NULL,
      CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER)
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
  FROM today t
  FULL OUTER JOIN yesterday y ON t.host = y.host AND t.metric_name = y.metric_name

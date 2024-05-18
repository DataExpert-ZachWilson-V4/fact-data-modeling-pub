INSERT INTO mposada.host_activity_reduced
WITH
  yesterday AS (
    SELECT
      *
    FROM
      mposada.monthly_array_web_metrics
    WHERE
      month_start = '2023-08-01'  -- grabs this month data
  ),
  today AS (
    SELECT
      *
    FROM
      mposada.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-03')  -- grabs todays data, this is the new incoming data
  )
SELECT
  COALESCE(t.host, y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  COALESCE(
    y.metric_array,
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER   -- gets metric array or if its NULL it create an array of NULLS with the number of NULLS equal to the amount of days since start of month until today for example if you use DATE_DIFF('day', DATE('2023-08-01'), DATE('2023-08-03')) it creates two nulls
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array, -- adds the value corresponding to today to the array 
  '2023-08-01' AS month_start
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host= y.host
  AND t.metric_name = y.metric_name

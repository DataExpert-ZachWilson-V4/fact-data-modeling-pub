INSERT INTO
  derekleung.monthly_array_web_metrics
--CTE layers:
--Context: data until January 2nd is ready, going on Jan 3rd
--this_month: everything in the current month
--today: today's new data to put inside the monthly array
--SELECT statement: build the metric array: 1 is 
WITH
  this_month AS (
    SELECT
      *
    FROM
      derekleung.monthly_array_web_metrics
    WHERE
      month_start = '2023-01-01'
  ),
  today AS (
    SELECT
      *
    FROM
      derekleung.daily_web_metrics
    WHERE
      DATE = DATE('2023-01-03')
  )
SELECT
  COALESCE(t.user_id, tm.user_id) AS user_id,
  COALESCE(t.metric_name, tm.metric_name) AS metric_name,
--if no nulls whatsoever (happiest path) then just concat today to this month
--if today is first value to concat n nulls in front, or else tm.metric_array should have taken care of all the prevailing nulls
  COALESCE(
    tm.metric_array,
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM
  today t
  -- full outer join is used here to include NULLs of both today (no activity today) and new users (no activity prior to today)
  FULL OUTER JOIN this_month tm ON t.user_id = tm.user_id
  AND t.metric_name = tm.metric_name

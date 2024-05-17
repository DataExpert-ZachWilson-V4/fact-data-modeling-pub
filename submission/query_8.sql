INSERT INTO jsgomez14.host_activity_reduced
WITH yesteday_t AS (
  SELECT *
  FROM jsgomez14.host_activity_reduced
  WHERE month_start = '2023-08-01'
),
today_t AS(
  SELECT *
  FROM jsgomez14.daily_web_metrics
  -- Lets assume that the table exists as the assignement suggests.
  WHERE date = DATE('2023-08-02')
)
SELECT
  COALESCE(T.host, Y.host) AS host,
  COALESCE(T.metric_name, Y.metric_name) AS metric_name,
  COALESCE(
    Y.metric_array, -- 1. Y.metric_array is null first day of the month.
    REPEAT(null, -- 1. First day of the month: DATE_DIFF below will be 0.
                -- 1. This means that REPEAT return an empty array.
                -- 1. This empty array will be concatenated with Today's metric_value.
                -- 2. Y.metric_array is null 1st day and rest of the month.
                -- 2. It need to be filled with nulls. This what REPEAT does.
      CAST(DATE_DIFF('day', DATE('2023-08-01'), T.date) AS INTEGER)
    )) || ARRAY[T.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM today_t AS T
FULL OUTER JOIN yesteday_t AS Y 
  ON T.host = Y.host AND T.metric_name = Y.metric_name
  -- Outter join with host and metric_name as keys.
-- This query does insertS one year of data into monthly table `host_activity_reduced`
INSERT INTO
    shashankkongara.host_activity_reduced
-- first time it ran, this will be empty table. then it incrementally load data one year at a time.
WITH
  yesterday AS (
    SELECT
      *
    FROM
      shashankkongara.host_activity_reduced
    WHERE
      month_start = '2023-08-01'
  ),
  today AS (
    SELECT
      *
    FROM
      shashankkongara.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')
  )
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    -- combine metric arrays from 'yesterday' and 'today'
    -- if there are some users who are showing up new in te middle of month window, then `REDUCE` will create NULL's every day before that date
    COALESCE(
        y.metric_array,
        -- if 'y.metric_array' is NULL, create an array with NULL values
        REPEAT(
            NULL,
            -- calculate the difference in days between '2023-08-01' and 't.date' and cast it as INTEGER
            CAST(
                DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
            )
        )
    ) || ARRAY[t.metric_value] AS metric_array,
    -- set the month_start for the inserted records to '2023-08-01'
    '2023-08-01' AS month_start
FROM
    today t
    FULL OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name


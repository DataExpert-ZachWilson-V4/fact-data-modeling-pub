    -- Subqueries:
    --     yesterday: Selects all records from alia.host_activity_reduced where the month_start is August 1, 2023.
    --     today: Selects all records from alia.daily_web_metrics for August 2, 2023.

    -- Insert Operation:
    --     Merges data from yesterday (y) and today (t) using a full outer join on host and metric_name.
    --     Constructs metric_array:
    --         If y.metric_array exists, appends t.metric_value to it.
    --         If y.metric_array is missing, initializes it with NULL values for days from August 1 up to the current date and then appends t.metric_value.
    --     Sets the month_start to August 1, 2023.

INSERT INTO
  alia.host_activity_reduced
WITH
  yesterday AS (
    SELECT
      *
    FROM
     alia.host_activity_reduced
    WHERE
      month_start = '2023-08-01'
  ),
  today AS (
    SELECT
      *
    FROM
      alia.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')
  )
SELECT
  COALESCE(t.host, y.host) AS host,
  COALESCE(t.metric_name, y.metric_name) AS metric_name,
  COALESCE(
    y.metric_array,
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
  FULL OUTER JOIN yesterday y ON t.host = y.host
  AND t.metric_name = y.metric_name
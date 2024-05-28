--Reduced Host Fact Array Implementation 

-- Creating the daily_web_metrics from the lab with the host column added now

-- CREATE TABLE hariomnayani88482.daily_web_metrics (
--   metric_name VARCHAR,
--   metric_value BIGINT,
--   host varchar,
--   DATE DATE
-- )
-- WITH
--   (
--     FORMAT = 'PARQUET',
--     partitioning = ARRAY['metric_name', 'date']
--   )

--Populating daily_web_metrics

-- INSERT INTO
--   hariomnayani88482.daily_web_metrics
-- SELECT
--   'visited_home_page' AS metric_name,
--   COUNT(
--     CASE
--       WHEN url = '/' THEN 1
--     END
--   ) AS metric_value,
--   host,
--   CAST(event_time AS DATE) AS DATE
-- FROM
--   bootcamp.web_events
-- GROUP BY
--   host,
--   CAST(event_time AS DATE)

-- INSERT INTO
--   hariomnayani88482.daily_web_metrics
-- SELECT
--   'visited_signup' AS metric_name,
--   COUNT(
--     CASE
--       WHEN url = '/signup' THEN 1
--     END
--   ) AS metric_value,
--   host,
--   CAST(event_time AS DATE) AS DATE
-- FROM
--   bootcamp.web_events
-- GROUP BY
--   host,
--   CAST(event_time AS DATE)

--Now we use this created table to run the following query which Host Fact Array 

INSERT INTO
  hariomnayani88482.host_activity_reduced
WITH
  yesterday AS (
    SELECT
      *
    FROM
      hariomnayani88482.host_activity_reduced
    WHERE
      month_start = '2023-08-01'
  ),
  today AS (
    SELECT
      *
    FROM
      hariomnayani88482.daily_web_metrics
    WHERE
      DATE = date('2023-08-02')
  )
SELECT
  coalesce(t.host, y.host) AS host,
  coalesce(t.metric_name, y.metric_name) AS metric_name,
  coalesce(
    y.metric_array,
    repeat(
      NULL,
      cast(
        date_diff('day', date('2023-08-01'), t.date) AS integer
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  '2023-08-01' AS month_start
FROM
  today AS t
  FULL OUTER JOIN yesterday AS y ON t.host = y.host
  AND t.metric_name = y.metric_name
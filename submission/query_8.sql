--Reduced Host Fact Array Implementation (query_8.sql)

INSERT INTO sanniepatron.host_activity_reduced

WITH
  yesterday AS (
    SELECT
      *
    FROM
      sanniepatron.host_activity_reduced
    WHERE
      month_start = '2023-01-01'
  ),
  today AS (
    SELECT
      dwm.*,
      we.host
    FROM
      sanniepatron.daily_web_metrics dwm
      JOIN bootcamp.web_events we ON dwm.user_id = we.user_id
    WHERE
      DATE = date('2023-01-03')
  )
SELECT
  coalesce(y.host, t.host) AS host,
  coalesce(y.metric_name, t.metric_name) AS metric_name,

 coalesce (y.metric_array,repeat(null, cast(date_diff('day',  date('2023-01-01'), t.date) as integer))) || ARRAY[t.metric_value] AS metric_array,
  
  '2023-01-01' AS month_start
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
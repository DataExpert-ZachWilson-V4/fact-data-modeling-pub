INSERT INTO hosts_cumulated
  WITH
  yesterday AS (
    SELECT
      *
    FROM
      hosts_cumulated 
    WHERE
      DATE = DATE('2023-01-02')
  ),

  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM bootcamp.web_events 
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-03')
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )


SELECT
  COALESCE(y.host, t.host) AS user_id,
  CASE
    WHEN y.host_activity_datelist  IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist  
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2023-01-03') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t 
  ON y.host= t.host
  
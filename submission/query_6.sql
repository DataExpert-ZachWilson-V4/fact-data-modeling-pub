INSERT INTO saismail.hosts_cumulated
WITH hosts AS (
SELECT
  w.host AS host,
  NULL as host_activity_datelist,
  CAST(w.event_time AS DATE) AS "date"
  FROM 
  bootcamp.web_events w
),
yesterday AS (
    SELECT
      *
    FROM
      saismail.hosts_cumulated
    WHERE
      "date"= DATE('2023-01-06')
  ),
  today AS (
    SELECT
      host,
      "date",
      COUNT(1)
    FROM
      hosts
    WHERE
      "date" = DATE('2023-01-07')
    GROUP BY
      host,
      "date"
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t."date"] || y.host_activity_datelist
    ELSE ARRAY[t."date"]
  END AS host_activity_datelist,
  t."date" as "date"
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
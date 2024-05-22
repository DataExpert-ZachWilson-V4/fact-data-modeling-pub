INSERT INTO
  hosts_cumulated WITH yesterday AS (
    SELECT
      *
    FROM
      hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31') -- Selects data from the table for the date '2022-12-31' and stores it in a CTE named yesterday.
  ),
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1) AS activity_count
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01') -- Selects data from the web_events table for the date '2023-01-01' and stores it in a CTE named today.
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY [t.event_date] || y.host_activity_datelist -- If yesterday's host_activity_datelist is not NULL, it concatenates today's event_date with yesterday's host_activity_datelist.
    ELSE ARRAY [t.event_date] -- If yesterday's host_activity_datelist is NULL, it initializes the host_activity_datelist with today's event_date.
  END AS host_activity_datelist,
  DATE('2023-01-01') AS DATE -- Sets the date to '2023-01-01' for all inserted records.
FROM
  yesterday y FULL
  OUTER JOIN today t ON y.host = t.host -- Performs a full outer join between yesterday and today based on the host.
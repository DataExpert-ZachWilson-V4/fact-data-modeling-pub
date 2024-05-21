    -- Subqueries:
    --     yesterday: Selects all records from alia.hosts_cumulated for January 2, 2023.
    --     today: Aggregates event data from bootcamp.web_events for January 3, 2023, grouping by host and event date.

    -- Insert Operation:
    --     Merges data from yesterday (y) and today (t) using a full outer join on host.
    --     Updates host_activity_datelist by appending the new event date from today to the existing list from yesterday. If no previous activity is found, it initializes the list with the current event date.
    --     Sets the date for the record to January 3, 2023.

INSERT INTO
  alia.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      alia.hosts_cumulated
    WHERE
      DATE = DATE('2023-01-02')
  ),
  today AS (
    SELECT
      host,
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-03')
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-03') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
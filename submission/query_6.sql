INSERT INTO
  vaishnaviaienampudi83291.hosts_cumulated
WITH
  yesterday AS ( -- collect yesterday's data from our target table
    SELECT
      *
    FROM
      vaishnaviaienampudi83291.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31')
  ),
  today AS ( --collect latest data from our base table 
    SELECT
      host, -- HOST details
      CAST(date_trunc('day', event_time) AS DATE) AS event_date, --extracting date from event_time column
      COUNT(1)
    FROM
      bootcamp.web_events 
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01') --today's date
    GROUP BY
      host,
      CAST(date_trunc('day', event_time) AS DATE)
  )
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y. host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y. host_activity_datelist --check if dates_active is not null the concat the new date to the existing list.
    ELSE ARRAY[t.event_date] -- if the dates_active list is null then create the list with new date
  END AS host_activity_datelist,
  DATE('2023-01-01') AS DATE
FROM
  yesterday y
  FULL OUTER JOIN today t  --join yesterday's data with today's data on host 
  ON y.host = t.host  
  

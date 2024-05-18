--Populate one day of data into the hosts_cumulated table
--Use a FULL OUTER JOIN to ensure data from both yesterday and today is loaded
--Load host_activity_datelist in descending date order by host name
--Would pass yesterday's and today's dates in as parameters if this query was in an Airflow job
INSERT INTO hosts_cumulated
WITH yesterday AS (
  SELECT *
  FROM hosts_cumulated
  WHERE date = DATE('2023-03-11')
), 
today AS (
  SELECT we.host,
    CAST(DATE_TRUNC('day', we.event_time) AS DATE) AS event_date
  FROM bootcamp.web_events we
  WHERE DATE_TRUNC('day', we.event_time) = DATE('2023-03-12')
  GROUP BY we.host,
    DATE_TRUNC('day', we.event_time)
)
SELECT COALESCE(y.host,t.host) as host,
  CASE WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist ELSE ARRAY[t.event_date] END AS host_activity_datelist,
  DATE('2023-03-12') AS date
FROM yesterday y
  FULL OUTER JOIN today t on y.host = t.host
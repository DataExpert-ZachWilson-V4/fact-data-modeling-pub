CREATE TABLE bhakti.web_users_cumulated (
  user_id BIGINT,
  browser_type varchar,
  dates_active ARRAY(DATE),
  DATE DATE
)
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['date'])


-- INSERT INTO academy.bootcamp.user_devices_cumulated
-- SELECT we.user_id, d.browser_type, ARRAY_AGG(DATE_TRUNC('day', we.event_time) ORDER BY we.event_time DESC), CURRENT_DATE
-- FROM academy.bootcamp.web_events we
-- JOIN academy.bootcamp.devices d ON we.device_id = d.device_id
-- GROUP BY we.user_id, d.browser_type;
SELECT we.user_id, d.browser_type, d.device_type,ARRAY_AGG(DATE_TRUNC('day', we.event_time) ORDER BY we.event_time DESC) AS dates_active
        FROM academy.bootcamp.web_events we
        JOIN academy.bootcamp.devices d ON we.device_id = d.device_id
        GROUP BY we.user_id, d.browser_type, d.device_type
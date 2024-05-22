-- incremental query to populate the table you wrote the DDL for in the above question from the `web_events` and `devices` tables.
--  This should look like the query to generate the cumulation table from the fact modeling day 2 lab.

INSERT INTO siawayforward.user_devices_cumulated
-- we want to know for each user, what browser type they used on which dates as of today
-- `user_id bigint`
-- `browser_type varchar`
-- `dates_active array(date)`
-- `date date`

-- TESTING USER: Appears 8/14, 8/15, 8/19 -108823150, there are non-consecutive appearances
-- using range of Aug 14 - 19 2023 to test adding 
WITH yesterday_history AS (
    SELECT *
    FROM siawayforward.user_devices_cumulated
    WHERE DATE = DATE('2023-08-18')

), today_history AS (
    SELECT
        web.user_id,
        d.browser_type,
        DATE('2023-08-19') AS todays_date,
        -- activity logged dates
        ARRAY_AGG(DATE(web.event_time)) AS event_date
    FROM bootcamp.web_events web
    LEFT JOIN bootcamp.devices d 
        ON web.device_id = d.device_id
    WHERE DATE(web.event_time) = DATE('2023-08-19')
    -- we only care if a date appears, not how many times
    GROUP BY 1, 2, 3
    
)
SELECT
    COALESCE(yh.user_id, th.user_id) AS user_id,
    COALESCE(yh.browser_type, th.browser_type) AS browser_type,
    -- append today's date to event date history
    CASE 
        -- order by most recent
        WHEN yh.user_id IS NULL AND th.todays_date IS NOT NULL 
            THEN ARRAY[(th.todays_date)]
        WHEN yh.dates_active IS NOT NULL AND th.todays_date IS NOT NULL
            THEN ARRAY[(th.todays_date)] || yh.dates_active
        WHEN yh.dates_active IS NOT NULL AND th.todays_date IS NULL
            THEN yh.dates_active
    ELSE NULL END AS dates_active,
    COALESCE(th.todays_date, yh.date + INTERVAL '1' DAY) AS date 
FROM yesterday_history yh
FULL OUTER JOIN today_history th
ON th.user_id = yh.user_id
-- TESTING USER: Appears 8/14, 8/15, 8/19 -108823150
-- WHERE COALESCE(yh.user_id, th.user_id) = -108823150
-- again we only care about one row with everything
GROUP BY 1, 2, 3, 4
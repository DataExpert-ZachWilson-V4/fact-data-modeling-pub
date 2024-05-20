-- INSERT DATA INCREMENTALLY INTO THE 'user_devices_cumulated' TABLE 
-- FROM THE 'web_events' AND 'devices' TABLES
INSERT INTO
    devpatel18.user_devices_cumulated
WITH
    yesterday AS (
        -- RETRIEVE ALL COLUMNS FROM 'user_devices_cumulated' FOR THE DATE '2023-01-01'
        SELECT
            *
        FROM
            devpatel18.user_devices_cumulated
        WHERE
            date = DATE('2023-01-01')
    ),
    today AS (
        -- SELECT user_id AND browser_type, AGGREGATING DISTINCT ACTIVE DATES FOR EACH USER AND BROWSER TYPE
        SELECT
            we.user_id,
            d.browser_type,
            ARRAY_AGG(
                DISTINCT CAST(DATE_TRUNC('day', we.event_time) AS DATE)
            ) AS dates_active,
            COUNT(1) AS event_count
        FROM
            bootcamp.devices d
            -- LEFT JOIN THE 'devices' TABLE WITH THE 'web_events' TABLE ON device_id
            LEFT JOIN bootcamp.web_events we ON d.device_id = we.device_id
        WHERE
            -- FILTER TO INCLUDE ONLY EVENTS FROM '2023-01-02'
            DATE_TRUNC('day', we.event_time) = DATE('2023-01-02')
        -- GROUP BY user_id AND browser_type
        GROUP BY
            we.user_id,
            d.browser_type
    )
-- SELECT AND COMBINE DATA FROM THE 'yesterday' AND 'today' CTEs
SELECT
    -- USE COALESCE TO HANDLE MISSING user_id OR browser_type IN EITHER 'yesterday' OR 'today'
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    -- COMBINE ACTIVE DATES FROM 'yesterday' AND 'today'
    CASE
        WHEN y.dates_active IS NOT NULL THEN t.dates_active || y.dates_active
        ELSE t.dates_active
    END AS dates_active,
    -- SET THE DATE FOR THE NEW RECORDS TO '2023-01-02'
    DATE('2023-01-02') AS date
FROM
    -- PERFORM A FULL OUTER JOIN ON user_id BETWEEN 'yesterday' AND 'today'
    yesterday y
    FULL OUTER JOIN today t ON y.user_id = t.user_id

INSERT INTO akshayjainytl54781.user_devices_cumulated
WITH yesterday AS ( -- CTE to hold yesterday's data
    select
        *
    from
        akshayjainytl54781.user_devices_cumulated
    where
        date = DATE ('2022-12-31')
),
today AS ( -- CTE to hold today's data
    select
        w.user_id,
        d.browser_type,
        -- Generating an array here so we don't repeat the code in the final SELECT statement
        ARRAY_AGG(DISTINCT CAST(DATE_TRUNC('day', event_time) AS DATE)) as event_date_array
    FROM
        bootcamp.devices d
        -- Left join to get all devices & browser types
        LEFT JOIN bootcamp.web_events w
    ON 
        (d.device_id = w.device_id)
    WHERE
        DATE_TRUNC('day', event_time) = DATE ('2023-01-01')
    GROUP BY 1,2
)

-- Combining the result from yesterday and today. Most recent data is added first (Reverse chronological order)
SELECT
    COALESCE(t.user_id, y.user_id) AS user_id,
    COALESCE(t.browser_type, y.browser_type) AS browser_type,
    CASE
        -- Case 1 -- We have cumulated data from yesterday. In that case, today's data is at the first index, concatendated with the existing data
        -- This way, the array is in a reverse chronological order of days in the month. Very easy to analyze and deduce.
        WHEN y.dates_active IS NOT NULL THEN event_date_array || y.dates_active -- Case 2 -- No prior data. This happens for the 1st day of the month
        ELSE event_date_array
    END AS dates_active,
    DATE ('2023-01-01') AS date
FROM
    yesterday y FULL OUTER JOIN today t ON (
        y.user_id = t.user_id
        AND y.browser_type = t.browser_type
    )
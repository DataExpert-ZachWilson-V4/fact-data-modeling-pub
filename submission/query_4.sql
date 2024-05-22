-- Convert the date list implementation into the base-2 integer datelist representation
WITH
    -- Unnest the dates_active array and convert them into powers of 2
    exploded_dates AS (
        SELECT 
            user_id, 
            browser_type, 
            date_diff('day', MIN(date), event_date) AS day_diff
        FROM 
            raniasalzahrani.user_devices_cumulated
        CROSS JOIN UNNEST(dates_active) AS t (event_date)
        GROUP BY 
            user_id, browser_type, event_date
    ),
    -- Sum the powers of 2 in a group by on user_id and browser_type
    summed_dates AS (
        SELECT 
            user_id, 
            browser_type, 
            SUM(POW(2, CAST(day_diff AS bigint))) AS date_bits
        FROM 
            exploded_dates
        GROUP BY 
            user_id, browser_type
    )
-- Convert the sum to base 2
SELECT 
    user_id, 
    browser_type, 
    TO_BASE(CAST(date_bits AS bigint), 2) AS date_bits
FROM 
    summed_dates

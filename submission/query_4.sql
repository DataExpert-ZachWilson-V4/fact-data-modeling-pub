-- CTE to explode the dates_active array into individual rows
WITH exploded_dates AS (
    SELECT
        user_id,
        browser_type,
        -- Unnest the dates_active array into individual dates
        UNNEST(dates_active) as active_date,
        -- Calculate the number of days ago from the current date
        DATE_DIFF('day', active_date, CURRENT_DATE) as days_ago
    FROM user_devices_cumulated
),
-- CTE to calculate the sum of powers of 2 for each (user_id, browser_type) combination
powers_of_two AS (
    SELECT
        user_id,
        browser_type,
        -- Sum the powers of 2 for each days_ago value
        SUM(POW(2, days_ago)) as datelist_int
    FROM exploded_dates
    GROUP BY user_id, browser_type
)
-- Select the final results
SELECT
    user_id,
    browser_type,
    datelist_int
FROM powers_of_two
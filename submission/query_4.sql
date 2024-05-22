WITH exploded_dates AS (
    SELECT
        user_id,
        browser_type,
        POWER(2, DATEDIFF(CURRENT_DATE, date)) AS date_power
    FROM
        user_devices_cumulated,
        UNNEST(dates_active) AS t(date)
),
summed_powers AS (
    SELECT
        user_id,
        browser_type,
        SUM(date_power) AS date_power_sum
    FROM
        exploded_dates
    GROUP BY
        user_id, browser_type
)
SELECT
    user_id,
    browser_type,
    date_power_sum,
    TO_BASE(date_power_sum, 2) AS date_power_binary
FROM
    summed_powers

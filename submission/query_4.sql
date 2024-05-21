-- Calculate the binary representation of the sum of powers of 2 of dates
WITH ExpandedData AS (
    SELECT 
        user_id, 
        browser_type, 
        date,
        element AS active_date
    FROM andreskammerath.user_devices_cumulated
    CROSS JOIN UNNEST(dates_active) AS t(element)
),
PowersOfTwo AS (
    SELECT 
        user_id, 
        browser_type, 
        POW(2, 30 - day(active_date)) AS power_of_two
    FROM ExpandedData
),
SummedPowers AS (
    SELECT 
        user_id, 
        browser_type, 
        CAST(SUM(power_of_two) AS BIGINT) AS summed_powers
    FROM PowersOfTwo
    GROUP BY user_id, browser_type
)
SELECT 
    user_id, 
    browser_type, 
    TO_BASE(summed_powers, 2) AS binary_representation
FROM SummedPowers ORDER BY binary_representation DESC

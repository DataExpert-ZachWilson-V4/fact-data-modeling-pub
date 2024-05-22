-- INPUT => ASSUMING DATA IS LOADED INTO TABLE TILL THE END OF MONTH for e.g. for Jan 2023 there is data from 2023-01-01 till 2023-01-31
-- LOGIC => 1) Below query takes above month data and creates bitwise string representing 31 days of activity
--          2) Both output columns dates_active_int and dates_active_arr are in descending order
--          3) Below query can be executed month by month
-- NOTE => The maximum value of an INTEGER in trino is 2^31-1, so the constant passed to the POW function needs to be <= 30

WITH cumulated AS (
    SELECT *
    FROM tharwaninitin.user_devices_cumulated
    WHERE date = DATE('2023-01-31')
),
date_cross_joined AS (
    SELECT *
    FROM cumulated
    CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-31'))) AS t(sequence_date)
),
date_int_sum AS (
    SELECT user_id,
        browser_type,
        SUM(
            CASE WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('DAY',sequence_date, date))
            ELSE 0 END
        ) AS dates_active_int,
        ANY_VALUE(dates_active) dates_active_arr
    FROM date_cross_joined
    GROUP BY user_id, browser_type
)
SELECT user_id,
    browser_type,
    REVERSE(SUBSTRING(REVERSE(ARRAY_JOIN(REPEAT('0',31),'') || TO_BASE(CAST(dates_active_int as INTEGER), 2)),1,31)) AS dates_active_int,
    dates_active_arr
FROM date_int_sum
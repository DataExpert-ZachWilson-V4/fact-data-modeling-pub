-- This query converts a month's worth of values in the user_devices_cumulated.dates_active array
-- into a bitwise string representing 28 days of activity for February, with values in descending order.
-- Adjusting the constant in the POW function accordingly and using BIGINT to handle large values.
WITH today AS (
    -- Select records from the last day of the target month to base the analysis on the most recent data
    SELECT *
    FROM jlcharbneau.user_devices_cumulated
    WHERE date = DATE '2021-02-08'
    ),
    datelist_seq AS (
-- Generate a sequence of dates for February and cross join with today's data to prepare for bit calculation
SELECT today.*, t.sequence_date
FROM today
    CROSS JOIN UNNEST(SEQUENCE(DATE '2021-02-01', DATE '2021-02-28')) AS t(sequence_date)
    ),
    datelist_int AS (
    -- Calculate a bitwise BIGINT where each bit represents a day in the month the user was active
SELECT user_id,
    browser_type,
    CAST(SUM(CASE WHEN CONTAINS(dates_active, sequence_date) THEN CAST(POW(2, 27 - DATE_DIFF('day', sequence_date, DATE '2021-02-28')) AS BIGINT) ELSE 0 END) AS BIGINT) AS history_int
FROM datelist_seq
GROUP BY user_id, browser_type
    )
SELECT user_id,
       browser_type,
       -- Convert the BIGINT to a binary string and pad with leading zeros to ensure it represents all 28 days of February
       LPAD(TO_BASE(history_int, 2), 28, '0') AS history_base2_string
FROM datelist_int
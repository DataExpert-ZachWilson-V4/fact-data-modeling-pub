WITH
today_user_device_cumulated AS (
    SELECT
        *
    FROM
        martinaandrulli.user_devices_cumulated
    WHERE
        DATE = DATE('2021-03-27')
),
date_list_int_cte AS (
    SELECT
        user_id,
        browser_type,
        CAST(
            SUM( -- Casting the result of the following calculation as a BIGINT and aliasing it as 'history_int'
                CASE 
                    -- If the 'dates_active' column contains the 'sequence_date', calculate the result using the POW and DATE_DIFF functions
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE)) -- Convert unnested date into powers of 2
                    -- If the 'dates_active' column does not contain the 'sequence_date', set the result to 0
                    ELSE 0
                END
                ) AS BIGINT
            ) AS daterange_int -- Sum the powers of 2 obtained
    FROM
        today_user_device_cumulated
    CROSS JOIN UNNEST (SEQUENCE(DATE('2021-03-24'), DATE('2021-03-27'))) AS t (sequence_date) -- Unnest date to have timerange split into initial and final
    -- Group by user_id and browser_type to have two rows for the same user in the same sequence interval but with a different browser
    GROUP BY 
        user_id, browser_type
)
SELECT
    *,
    TO_BASE(daterange_int, 2) AS daterange_in_binary -- Convert the sum to base 2
FROM date_list_int_cte
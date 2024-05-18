-- Today's data
WITH today AS (
    SELECT
        *
    FROM
        akshayjainytl54781.user_devices_cumulated
    WHERE
        date = DATE('2023-01-07')
),
-- CTE to hold generate integer representation of dates active
history_int_data AS (
    SELECT
        user_id,
        browser_type,
        CAST(
            -- Generate an integer representation of the dates active array by summing the items in the array
            -- when it's active, and 0 (when NULL) otherwise.
            SUM(
                CASE
                    -- Check if sequence date has the dates_active
                    /**
                    This works by:
                    1. Check if the 'sequence_date' exists in the 'dates_active' array
                    2. When present, then we calculate the difference between the 'sequence_date' and the partitioned 'date'
                        2.1 We substract the above from 30, and power of 2, so we are setting the appropriate bit in power-of-2
                        representation of the difference.
                        For ex-, let's say sequence_date = '2023-01-07' and date = '2023-01-01', the date_diff = 6 days,
                        so we need to set the 6th bit in a 30 bit representation of the month
                    3. Finally, we do a sum of this to get a 32 bit integer
                    **/
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                    ELSE 0
                END
            ) AS BIGINT
        ) as history_int
    FROM
        today
        CROSS JOIN UNNEST( -- Generate a sequence of dates to each date against.
            SEQUENCE(DATE ('2023-01-01'), DATE('2023-01-07'))
        ) as t(sequence_date)
    GROUP BY
        1,
        2
)
-- Converting to base-2 integer representation of dates active array
SELECT
    *,
    TO_BASE (history_int, 2) as active_history_binary, -- Convert to binary representation
    BIT_COUNT(history_int, 32) as num_days_active -- Count the number of 1s in the array to see number of days active
FROM
    history_int_data
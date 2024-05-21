-- CTE query that reads from user_devices_cumulated  table and generates a datelist by unnesting and converting into powers of 2
-- Define a CTE to select all records from the user_devices_cumulated table for the specific date
WITH
    TODAY AS (
        SELECT
            * -- Select all columns from user_devices_cumulated for the date '2021-01-20'
        FROM
            amaliah21315.user_devices_cumulated
        WHERE
            DATE = DATE ('2021-01-20') -- Filter by selected date
    ),
    -- Define a CTE to calculate the date power list integer
    date_power_list_int AS (
        SELECT
            user_id, -- Select user_id
            browser_type, -- Select browser_type
            -- Calculate the date power list as an integer
            CAST(
                SUM( -- Sum the powers of 2
                    CASE
                    -- If the dates_active array contains the current sequence date, calculate the power of 2
                        WHEN CONTAINS (dates_active, sequence_date) THEN POW (
                            2,
                            31 - DATE_DIFF ('day', sequence_date, DATE ('2021-01-20'))
                        )
                        ELSE 0 -- Otherwise, contribute 0 to the sum
                    END
                ) AS BIGINT -- Cast the result to BIGINT
            ) AS date_power -- Name the resulting column as date_power
        FROM
            TODAY -- Use the records from the TODAY CTE
            -- Cross join with a sequence of dates from '2021-01-19' to '2021-01-20'
            CROSS JOIN UNNEST (
                SEQUENCE (DATE ('2021-01-19'), DATE ('2021-01-20'))
            ) AS t (sequence_date)
        GROUP BY
            user_id, -- Group by user_id
            browser_type -- Group by browser_type
    )
    -- Select the final results
SELECT
    *, -- Select all columns from the date_power_list_int CTE
    TO_BASE (date_power, 2) AS date_power_in_binary -- Convert the date_power to a binary representation
FROM
    date_power_list_int -- Use the date_power_list_int CTE
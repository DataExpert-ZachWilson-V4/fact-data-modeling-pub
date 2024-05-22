-- Common Table Expression (CTE) to get data for the specified date
WITH
  today AS (
    SELECT
      * -- Select all columns from user_devices_cumulated table
    FROM
      RaviT.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07') -- Filter for the specific date
  ),
  -- CTE to generate an integer representation of activity history
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        SUM(
          CASE
            -- Check if the sequence_date is in dates_active
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE)) 
            -- If true, calculate a value using power of 2 based on the date difference
            ELSE 0 -- If false, return 0
          END
        ) AS BIGINT
      ) AS history_int -- Sum the values and cast to BIGINT as history_int
    FROM
      today
      -- Generate a sequence of dates from 2023-01-01 to 2023-01-07
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
    GROUP BY
      user_id, 
      browser_type
  )
-- Select final results
SELECT
  *, 
  TO_BASE(history_int, 2) AS history_in_binary -- Convert history_int to binary representation
FROM
  date_list_int

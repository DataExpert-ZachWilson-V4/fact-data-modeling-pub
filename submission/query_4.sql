-- Common Table Expressions (CTEs) to organize the query
WITH  
  -- CTE to fetch data for today (2021-01-05) from the table user_devices_cumulated
  today AS (
    SELECT
      *
    FROM
      user_devices_cumulated
    WHERE
      date = DATE('2021-01-07')
  ),
  
  -- CTE to generate a list of dates and their corresponding binary integers for each user and browser type
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      -- Calculate the binary integer representing the user's history on each date
      CAST(
        SUM(
          CASE
            -- If the date is in the active dates array, calculate the corresponding binary integer
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, date))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      -- Generate a sequence of dates from '2023-01-01' to '2023-01-07' using CROSS JOIN UNNEST
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
-- Selecting data from date_list_int and converting history_int to binary
SELECT
  *,
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list_int

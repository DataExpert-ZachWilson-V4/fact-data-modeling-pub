-- query_4 User Devices Activity Int Datelist Implementation 
-- On top of query_3 convert the date list implementation into the base-2 integer datelist representation
-- unnest the dates, and convert them into powers of 2
-- sum those powers of 2 in a group by on user_id and browser_type
-- convert the sum to base 2


WITH
  today AS (
    SELECT
        user_id
      , browser_type
      , dates_active
      , date
    FROM
      aayushi.user_devices_cumulated
    WHERE
      date = DATE('2023-01-07')  -- Selecting data for the specified date
  ),  -- CTE to select data for the current date (2023-01-07)

  date_list_int AS (
    SELECT
        user_id
      , browser_type
      , CAST(
            SUM(
            CASE
                -- summing powers of 2 and calculating the integer representation of activity history using bitwise operations
                WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                ELSE 0
            END
            ) AS BIGINT
        ) AS history_int
    FROM
      today
      -- unnesting and generating a sequence of dates from 2023-01-01 to 2023-01-07
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date)
    GROUP BY
        user_id
      , browser_type
  )  -- CTE to calculate the integer representation of the user's activity history by Unnesting the dates_active array 

-- Selecting user_id, browser_type, activity history as integer, and activity history in binary
SELECT
    user_id
  , browser_type
  , history_int
  , TO_BASE(history_int, 2) AS history_in_binary  -- Converting activity history to binary (base 2)
FROM
  date_list_int


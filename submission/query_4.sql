-- CTE to get the data for the current day (today)
WITH
  today AS (
    SELECT
      *
    FROM
      nonasj.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
  -- CTE to transform dates_active into a base-2 integer representation (date_list_int)
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      -- Calculate the base-2 integer representation of the activity dates
      CAST(
        SUM(
          CASE
            -- Check if the date is in the dates_active array
            WHEN CONTAINS(dates_active, sequence_date) THEN 
              -- Convert the date to a power of 2
              POW(2, 31 - DATE_DIFF('day', sequence_date, DATE('2023-01-01')))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      -- Cross join with a sequence of dates from 2023-01-01 to 2023-01-07
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
-- Final SELECT to add binary representations and activity flags
SELECT
  *,
  -- Convert the base-2 integer representation to a binary string
  TO_BASE(history_int, 2) AS history_in_binary,
  -- Define a base for weekly activity (binary representation of active for first 7 days)
  TO_BASE(
    FROM_BASE('11111110000000000000000000000000', 2),
    2
  ) AS weekly_base,
  -- Count the number of days active
  BIT_COUNT(history_int, 64) AS num_days_active,
  -- Check if there is any activity in the weekly base period
  BIT_COUNT(
    BITWISE_AND(
      history_int,
      FROM_BASE('11111110000000000000000000000000', 2)
    ),
    64
  ) > 0 AS is_weekly_active,
  -- Check if there is any activity in the last week (second 7-day period)
  BIT_COUNT(
    BITWISE_AND(
      history_int,
      FROM_BASE('00000001111111000000000000000000', 2)
    ),
    64
  ) > 0 AS is_weekly_active_last_week,
  -- Check if there is any activity in the last three days
  BIT_COUNT(
    BITWISE_AND(
      history_int,
      FROM_BASE('11100000000000000000000000000000', 2)
    ),
    64
  ) > 0 AS is_active_last_three_days
FROM
  date_list_int
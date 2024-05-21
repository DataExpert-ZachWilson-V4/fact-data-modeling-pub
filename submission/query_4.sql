-- Define a CTE named 'cumulated'
WITH cumulated AS (
  -- Select all records from 'user_devices_cumulated' where the date is '2023-01-07'
  SELECT * 
  FROM ningde95.user_devices_cumulated
  WHERE date = DATE('2023-01-07')
),

-- Define a CTE named 'sequenced'
sequenced AS (
  -- Select all records from 'cumulated'
  -- Cross join with a sequence of dates from '2023-01-01' to '2023-01-07'
  SELECT * 
  FROM cumulated 
  CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) t(sequence_date)
),

-- Define a CTE named 'int_history'
int_history AS (
  -- Select user_id, browser_type, calculated int_history, and dates_active
  SELECT 
    user_id,
    browser_type,
    SUM(
      CAST(
        CASE 
          -- If the sequence_date is in dates_active, calculate a bit position value
          WHEN CONTAINS(dates_active, sequence_date) 
          THEN POW(2, 31 - DATE_DIFF('day', DATE('2023-01-01'), sequence_date))
          -- Otherwise, use 0
          ELSE 0 
        END AS BIGINT
      )
    ) AS int_history,  -- Sum these values to get an integer representation of the active dates
    dates_active
  FROM sequenced
  GROUP BY user_id, browser_type, dates_active
)

-- Final SELECT statement to determine activity in the first and second week
SELECT 
  *,
  TO_BASE(int_history, 2) AS binary_history,  -- Convert int_history to a binary string
  -- Check if any bit in the first week (bits 25-31) is set
  BIT_COUNT(
    BITWISE_AND(
      int_history,
      FROM_BASE('11111110000000000000000000000000', 2)
    ),
    64
  ) > 0 AS is_first_week_active,
  -- Check if any bit in the second week (bits 18-24) is set
  BIT_COUNT(
    BITWISE_AND(
      int_history,
      FROM_BASE('00000001111111000000000000000000', 2)
    ),
    64
  ) > 0 AS is_second_week_active
FROM int_history

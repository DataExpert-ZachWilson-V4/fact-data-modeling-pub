-- CTE to use existing data from the user_devices_cumulated table
WITH today AS (
  SELECT *
  FROM videet.user_devices_cumulated
),

-- CTE to create a binary representation of active dates
date_list_int AS (
  SELECT 
    user_id,
    browser_type,
    -- Calculating a binary integer from the dates_active array
    CAST(SUM(
      CASE 
        WHEN contains(dates_active, sequence_date) THEN 
          -- Calculating power of 2 based on the date difference; newer dates get higher bits
          POW(2, 31 - DATE_DIFF('day', sequence_date, DATE('2023-01-06')))
        ELSE 0 
      END
    ) AS BIGINT) AS history_int
  FROM 
    today
  -- Generating a sequence of dates to check against the dates_active array
  CROSS JOIN UNNEST(
    SEQUENCE(DATE('2023-01-01'), DATE('2023-01-06'))
  ) AS t(sequence_date)
  GROUP BY 
    user_id,
    browser_type
)

-- Final select to get the binary string representation of history_int
SELECT 
  user_id,
  browser_type,
  history_int,
  -- Convert the bigint history_int to a base-2 (binary) string
  TO_BASE(history_int, 2) AS history_in_binary
FROM 
  date_list_int
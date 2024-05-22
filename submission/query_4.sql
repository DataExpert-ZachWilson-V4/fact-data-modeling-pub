-- CTE to select records from user_devices_cumulated for the specific date
WITH today AS (
  SELECT *
  FROM user_devices_cumulated
  WHERE date = DATE('2023-01-07')
),
-- CTE to calculate a binary history integer for each user and browser type
date_list_int AS (
  SELECT
    user_id,
    browser_type,
    -- Calculate the history integer by summing powers of 2 based on active dates
    CAST(
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date)
            THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))  -- Calculate binary position
          ELSE 0  -- If the date is not active, add 0
        END 
      ) AS BIGINT
    ) AS history_int
  FROM today
  -- Generate a sequence of dates
  CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date)
  GROUP BY
    user_id,
    browser_type  -- Group by user and browser type to calculate history_int for each
)
-- Select and convert the history integer to binary representation
SELECT
  user_id,
  browser_type,
  history_int,
  TO_BASE(history_int, 2) AS history_in_binary  -- Convert history integer to binary
FROM date_list_int

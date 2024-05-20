WITH
  current_day_data AS (
    -- Select all data from user_devices_cumulated for the specific date
    SELECT
      *
    FROM
      faraanakmirzaei15025.user_devices_cumulated
    WHERE
      date = DATE('2021-06-07')
  ),
  user_activity_pow2 AS (
    -- Calculate the power of two representation for active dates
    SELECT
      user_id,
      browser_type,
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE('2021-06-07')))
          ELSE 0
        END
      ) AS pow2_active_days
    FROM
      current_day_data
      -- Generate a sequence of dates from 2021-06-01 to 2021-06-07
      CROSS JOIN UNNEST(SEQUENCE(DATE('2021-06-01'), DATE('2021-06-07'))) AS t(sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
-- Convert the power of two values to binary representation
SELECT
  user_id,
  browser_type,
  TO_BASE(CAST(pow2_active_days AS INT), 2) AS active_days_binary
FROM
  user_activity_pow2

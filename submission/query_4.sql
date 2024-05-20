WITH
  today_data AS (
    -- Select all data from user_devices_cumulated for the specific date
    SELECT
      *
    FROM
      user_devices_cumulated
    WHERE
      date = DATE('2023-01-07')
  ),
  user_activity_bit_int AS (
    SELECT
      user_id,
      browser_type,
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE('2021-01-07')))
          ELSE 0
        END
      ) AS active_days
    FROM
      today_data
      CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date)
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
  WITH
  today_data AS (
    -- Select all data from user_devices_cumulated for the specific date
    SELECT
      *
    FROM
      user_devices_cumulated
    WHERE
      date = DATE('2023-01-07')
  ),
  user_activity_bit_int AS (
    SELECT
      user_id,
      browser_type,
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE('2023-01-07')))
          ELSE 0
        END
      ) AS active_days_exp
    FROM
      today_data
      CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
-- Convert the power of two values to binary representation
SELECT
  user_id,
  browser_type,
  TO_BASE(CAST(active_days_exp AS INT), 2) AS active_days_binary
FROM
  user_activity_pow2
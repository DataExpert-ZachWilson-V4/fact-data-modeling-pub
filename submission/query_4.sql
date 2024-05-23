-- The purpose of this query is to convert the dates_active array into a base-2 integer datelist representation.
-- This involves three main transformations:
-- 1. Unnest the dates_active array and convert each date into a power of 2.
-- 2. Sum these powers of 2 for each user_id and browser_type combination.
-- 3. Convert the sum to a base-2 representation and calculate the number of active days.
-- The final result will include the user_id, browser_type, the integer history, its binary representation, and the number of active days.


WITH
  -- Select the current day's data
  today AS (
    SELECT
      *
    FROM
      vpsjul8468082.user_devices_cumulated
    WHERE
      date = DATE('2023-01-07')
  ),
  -- Unnest dates_active and sequence of given dates
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        SUM(
          CASE
            WHEN contains(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_bigint
    FROM
      today
      CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
      GROUP BY 
user_id,
browser_type
  )
SELECT *,
    TO_BASE(history_bigint, 2) AS binary_date
FROM date_list_int

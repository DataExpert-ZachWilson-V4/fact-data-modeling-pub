-- This query converts the dates_active array into a base-2 integer representation.
-- The process includes three main steps:
-- 1. Unnest the dates_active array and represent each date as a power of 2.
-- 2. Aggregate these powers of 2 for each user_id and browser_type combination.
-- 3. Convert the aggregated sum into its binary representation and calculate the total number of active days.
-- The final output will include the user_id, browser_type, the aggregated integer value (history), its binary representation, and the count of active days.

WITH
  -- Select the current day's data
  today AS (
    SELECT
      *
    FROM
      user_devices_cumulated
    WHERE
      date = DATE('2022-12-21')
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
      CROSS JOIN UNNEST(SEQUENCE(DATE('2022-12-01'), DATE('2023-12-21'))) AS t (sequence_date)
      GROUP BY 
user_id,
browser_type
  )
SELECT *,
    TO_BASE(history_bigint, 2) AS binary_date
FROM date_list_int

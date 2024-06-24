WITH
  today AS (
    SELECT
      *
    FROM
      jb19881.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-08')
  )
, date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        -- 3. sum power of 2 by user_id and browser_type
        SUM(
          CASE
            -- 2. convert to power of two
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      -- 1. unnest dates
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-08'))) AS t (sequence_date)
    GROUP BY user_id, browser_type
)
SELECT
  *,
  -- 4. convert sum to base 2
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list_int
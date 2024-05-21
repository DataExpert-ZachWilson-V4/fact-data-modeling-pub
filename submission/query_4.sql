WITH
  today AS (
    SELECT
      *
    FROM
      mposada.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07') -- Adjusted date to match prompt
  ),
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        SUM(
          CASE
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE)) -- calculates the power of 2
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date) -- creates a sequence of dates in that range and by cross join unnest it creates one row per date in the sequence
    GROUP BY
      user_id, 
      browser_type
  )
SELECT
  *,
  TO_BASE(history_int, 2) AS history_base_2
FROM
  date_list_int 

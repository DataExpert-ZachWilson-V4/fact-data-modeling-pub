WITH
  today AS (
    SELECT
      *
    FROM
      rgindallas.user_devices_cumulated
    WHERE
      DATE = DATE('2023-07-11')
  ),
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        SUM(
          CASE
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-07-01'), DATE('2023-07-11'))) AS t(sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
SELECT
  *,
  TO_BASE(history_int, 2) AS history_in_binary,
  BIT_COUNT(history_int, 64) AS num_days_active
FROM
  date_list_int

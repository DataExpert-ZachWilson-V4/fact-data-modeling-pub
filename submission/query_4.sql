WITH
today AS (
    SELECT
      *
    FROM
      saismail.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
datelist_int AS (
SELECT
  user_id,
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
  CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
  GROUP BY user_id
  )
SELECT
  *,
  TO_BASE(history_int, 2) AS history_in_binary,
  BIT_COUNT(history_int, 64) AS num_days_active,
FROM
  datelist_int
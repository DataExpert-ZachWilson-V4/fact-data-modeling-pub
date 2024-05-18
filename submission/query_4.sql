WITH
  today AS (
    SELECT
      *
    FROM
      jrsarrat.user_devices_cumulated
    WHERE
      date = DATE('2023-01-08')
  )
SELECT
  user_id,
  browser_id
  CAST(
    SUM(
      CASE
        WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 32 - DATE_DIFF('day', sequence_date, DATE))
        ELSE 0
      END
    ) AS BIGINT
  )
FROM
  today
  CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-08'))) AS t (sequence_date)
GROUP BY
  user_id,
  browser_id

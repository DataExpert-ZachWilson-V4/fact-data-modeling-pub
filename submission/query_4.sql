WITH
  today AS (
    SELECT
      *
    FROM
      jrsarrat.user_devices_cumulated
    WHERE
      date = DATE('2023-01-08')
  ),
  date_list_int AS (
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
    CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-02'), DATE('2023-01-08'))) AS t (sequence_date)
  GROUP BY
  user_id,
  browser_id
)
SELECT
  *,
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list_int

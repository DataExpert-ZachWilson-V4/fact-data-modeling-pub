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
      ) AS dates_active_int
  FROM
    today
    CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-02'), DATE('2023-01-08'))) AS t (sequence_date)
  GROUP BY
  user_id,
  browser_type
)
SELECT
  *,
  TO_BASE(dates_active_int, 2) AS dates_in_binary
FROM
  date_list_int

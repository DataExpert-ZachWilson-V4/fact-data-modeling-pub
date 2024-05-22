WITH 
  today AS (
    SELECT
      *
    FROM
      emmaisemma.web_users_cumulated
    WHERE
      DATE = DATE('2023-01-02')
  ),
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        SUM(
          CASE
            WHEN CONTAINS(dates_active, sequence_date) 
            THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
            ELSE 0
          END
        ) AS BIGINT
      ) AS dates_active
    FROM
      today
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-02'))) AS t (sequence_date)
    GROUP BY
      user_id
      browser_type
  )
SELECT
  *,
  TO_BASE(dates_active, 2) AS history_in_binary
FROM
  date_list_int
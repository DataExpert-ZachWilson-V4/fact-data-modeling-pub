with user_devices as(
select * from
deeptianievarghese22866.user_devices_cumulated 
),
date_list_int AS (
    SELECT
      user_id,
      CAST(
        SUM(
          CASE
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      user_devices
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-10'), DATE('2023-01-11'))) AS t (sequence_date)
    GROUP BY
      user_id, browser_type
  )
SELECT
  *,
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list_int

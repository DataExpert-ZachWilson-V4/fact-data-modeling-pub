WITH
  today_data AS (
    SELECT *
    FROM crouton.user_devices_cumulated
    WHERE date = DATE('2022-09-25')
  ),
  user_pow2 AS (
     SELECT
      user_id,
      browser_type,
      SUM(CASE
          WHEN CONTAINS(dates_active, sequence_date) 
          THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE('2022-09-25')))
          ELSE 0
        END) AS pow2_active_days
    FROM
      today_data
      CROSS JOIN UNNEST(SEQUENCE(DATE('2022-09-23'), DATE('2022-09-25'))) AS t(sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
SELECT
  user_id,
  browser_type,
  TO_BASE(CAST(pow2_active_days AS INT), 2) AS active_days_binary
FROM
  user_pow2
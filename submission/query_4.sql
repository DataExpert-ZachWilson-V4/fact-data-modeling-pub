
/*------------------------------------------------------------
convert the date list implementation into the base-2 integer datelist representation
*/------------------------------------------------------------

WITH
  today AS (
    SELECT
      *
    FROM
      ykshon52797255.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
    -- Sum those powers of 2 in a group by on user_id and browser_type
      CAST(SUM(CASE
                WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
                ELSE 0
                END
              ) AS BIGINT) AS history_int
    FROM
      today
      --unnest the dates, and convert them into powers of 2
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
    GROUP BY
      user_id, browser_type
  )
  
SELECT
  *,
  --convert the sum to base 2
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list_int

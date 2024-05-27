--derekleung.web_users_cumulated is pre-loaded with 7 days of data
--today: latest copy of datelist
--date_list_int: converts activity represented by datelist (array(date)) into a bigint
--(note a history_start_date column is added here for better result readability)
--SELECT statement: transform the bigint into binary
WITH
  today AS (
    SELECT
      *
    FROM
      derekleung.web_users_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
  --(note a history_start_date column is added here for better result readability)
      min(sequence_date) as history_start_date,
  --Step 1: spread sequence of dates to every row
  --Step 2: if the row with a certain date (n^th day)in sequence_date was detected activity by a certain user+browser, 
  --then history_int += 2^(31-n) (note 31 is because of January, depending on analysis this number could change)
  --Step 3: the sum concludes activity in the sequence of dates due to the uniqueness of binary representation
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
    GROUP BY
      user_id,
      browser_type
  )
SELECT
  user_id,
  browser_type,
  history_start_date,
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list_int

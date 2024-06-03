WITH today AS (
  -- Selecting all rows from the 'user_devices_cumulated' table where the date is '2021-01-02'
  SELECT *
  FROM luiscoelho37431.user_devices_cumulated
  WHERE date = DATE('2021-01-02')
)
SELECT
  -- Selecting the user_id and browser_type columns
  user_id,
  browser_type,
  -- Casting the result of the following calculation as a BIGINT and aliasing it as 'history_int'
  CAST(
    SUM(
      CASE
        -- If the 'dates_active' column contains the 'sequence_date', calculate the result using the POW and DATE_DIFF functions
        WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, date))
        -- If the 'dates_active' column does not contain the 'sequence_date', set the result to 0
        ELSE 0
      END
    ) AS BIGINT
  ) as history_int
FROM
  today
  -- Generating a sequence of dates from '2021-01-01' to '2021-01-07' and aliasing it as 't'
  CROSS JOIN UNNEST (SEQUENCE(DATE('2021-01-01'), DATE('2021-01-07'))) AS t (sequence_date)
GROUP BY
  -- Grouping the result by user_id and browser_type
  user_id,
  browser_type

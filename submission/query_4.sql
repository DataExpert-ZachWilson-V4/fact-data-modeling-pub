--This query converts a month's worth of values in the user_devices_cumulated.dates_active array into a bitwise string representing 31 days of activity:
--Values are in descending order
--The maximum value of an INTEGER in Trino is 2^31-1, so the constant passed to the POW function needs to be 30
WITH today AS (
  SELECT *
  FROM user_devices_cumulated
  WHERE date = DATE('2022-10-31')
), 
datelist_seq AS (
  SELECT *
  FROM today
    CROSS JOIN UNNEST (SEQUENCE(DATE('2022-10-01'),DATE('2022-10-31'))) AS t(sequence_date)
), 
datelist_int AS (
  SELECT user_id,
    browser_type,
    CAST(SUM(CASE WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30-DATE_DIFF('DAY',sequence_date, date)) ELSE 0 END) AS INTEGER) AS history_int
  FROM datelist_seq
  GROUP BY user_id,
    browser_type
)
SELECT user_id,
  browser_type,
  --pad any users whose first login was in the middle of the month with leading zeroes
  REVERSE(SUBSTRING(REVERSE(ARRAY_JOIN(REPEAT('0',31),'') || to_base(history_int, 2)),1,31)) as history_base2_string
FROM datelist_int
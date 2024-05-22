WITH today AS (
  SELECT 
    * 
  FROM ebrunt.user_devices_cumulated 
  WHERE date = DATE('2021-02-13')
),
summed AS (
SELECT 
  user_id, 
  browser_type,
  CAST(
    SUM(
    CASE 
      WHEN CONTAINS(dates_active, sequence) THEN POW(2, 30 - DATE_DIFF('day', sequence, date))
      ELSE 0 
     END
     ) 
     AS BIGINT
     ) as history
FROM today
CROSS JOIN UNNEST (SEQUENCE(DATE('2021-02-07'), DATE('2021-02-13'))) AS t(sequence)
GROUP BY 1, 2
)
SELECT *, TO_BASE(history, 2) as binary, BIT_COUNT(history, 32) as count_last_week FROM summed

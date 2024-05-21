 with devices_data as(
  SELECT 
    * 
  FROM 
    adbeyer.user_devices_cumulated 
  WHERE 
    date = DATE('2023-01-05')
), 
date_list_int as (
  SELECT 
    user_id, 
    browser_type, 
    CAST(
      SUM(
        CASE WHEN CONTAINS(dates_active, sequence_date) THEN POW(
          2, 
          30 - DATE_DIFF('day', sequence_date, DATE)
        ) ELSE 0 END
      ) AS INTEGER
    ) AS history_int 
  FROM 
    devices_data CROSS 
    JOIN UNNEST(
      SEQUENCE(
        DATE('2023-01-01'), 
        DATE('2023-01-05')
      )
    ) AS t (sequence_date) 
  GROUP BY 
    user_id, 
    browser_type
) 
SELECT 
  *, 
  TO_BASE(history_int, 2), 
  BIT_COUNT(history_int, 32) AS num_days_active 
FROM 
  date_list_int

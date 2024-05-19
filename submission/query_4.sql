WITH 
  current_date_records AS (
    SELECT * 
    FROM ovoxo.user_devices_cummulated
    WHERE date = DATE('2023-01-07')  
  )
  
SELECT user_id,
    browser_type,
    TO_BASE(
        CAST(
            SUM(
                CASE 
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                    ELSE 0
                END
            ) AS BIGINT
        ),
    2) AS base2_int
FROM current_date_records 
CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS c (sequence_date)
GROUP BY user_id, browser_type

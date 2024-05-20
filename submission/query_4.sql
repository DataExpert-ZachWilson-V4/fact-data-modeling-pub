-- COnvert date list array from ovoxo.user_devices_cummulated to base2 integer datelist representation, this further compresses the data and enable bitwise operations 

WITH 
  -- select subset of data to work with from voxo.user_devices_cummulated
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
    2) AS base2_int -- bit represents one week of data
FROM current_date_records 
CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS c (sequence_date) -- cross join unnest to period you want to run analysis for and based on data in base table
GROUP BY user_id, browser_type -- aggregate data for user_id and browser_type


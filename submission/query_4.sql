WITH today as
(
  SELECT *
  FROM user_devices_cumulated
  WHERE DATE = DATE('2023-01-07')
),
date_list_int AS (
    SELECT user_id,  
    browser_type,    
    CAST(
    SUM(
        CASE WHEN CONTAINS
        (
            dates_active , sequence_date
        ) 
        THEN
            POW(2 ,30 - DATE_DIFF('day' , sequence_date , DATE))
        ELSE 0 
        END 
    ) AS BIGINT
    ) AS history_int  
    FROM today  
    CROSS JOIN 
    UNNEST(SEQUENCE(DATE('2023-01-01'),DATE('2023-01-07'))) as t(sequence_date) 
    GROUP BY 1,2
)
SELECT *,
TO_BASE(history_int , 2) as history_in_binary
FROM date_list_int



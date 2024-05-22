--HW2 query_4

/*convert the date list implementation into the base-2 integer datelist representation*/

With today AS ( select
        * 
    from
        hdamerla.user_devices_cumulated   
    where
        date = DATE('2023-01-07') ),
       
     date_list_int AS ( select
        user_id,
        browser_type,
        CAST(SUM(
              CASE  --using bitwise operations, calculating the integer representation
                   WHEN CONTAINS(dates_active, sequence_date) THEN 
                     POW(2, 31 - DATE_DIFF('day', sequence_date, DATE('2023-01-01'))) 
                   ELSE 0 
              END 
       ) AS BIGINT ) as history_int  
    from
        today CROSS 
    JOIN
        UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) as t(sequence_date) 
    group by
        user_id,
        browser_type )  
       
    select
        user_id,
        browser_type,
        TO_BASE(history_int, 2) as history_in_binary
    from
        date_list_int

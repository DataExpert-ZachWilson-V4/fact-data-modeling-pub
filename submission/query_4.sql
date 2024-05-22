--User Devices Activity Int Datelist Implementation (query_4.sql)

WITH user_info AS (    
    SELECT 
    user_id,browser_type,dates_active,date
    FROM saidaggupati.user_devices_cumulated WHERE date = DATE('2023-01-07')
    ),
date_list AS (
    SELECT
        user_id,browser_type,
  -- user's record for the month
        CAST(SUM(CASE WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                ELSE 0 END) AS BIGINT
        ) AS date_int
    FROM user_info
    CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-30'))) AS t(sequence_date)
    GROUP BY user_id,browser_type
)


SELECT
    user_id,
    browser_type,
    TO_BASE(date_int, 2) AS days_history_binary
FROM date_list
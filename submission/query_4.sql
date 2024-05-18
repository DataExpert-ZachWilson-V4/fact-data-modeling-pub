WITH 
today AS (
    SELECT * FROM user_devices_cumulated
    WHERE date = DATE('2023-01-05')
),
date_list_binary AS 
(
    SELECT
        user_id,
        browser_type,
        CAST( SUM(
            CASE WHEN 
                CONTAINS(dates_active, sequence_date)
                THEN POW(2, 32 - DATE_DIFF('day', sequence_date , date))
                ELSE 0
            END
        ) AS BIGINT) AS dates_active
    FROM today
    CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-05'))) AS t(sequence_date)
    GROUP BY user_id, browser_type
)
SELECT 
    *,
     TO_BASE(dates_active, 2) AS dates_active_binary
FROM date_list_binary
-- User Devices Activity **Int** Datelist Implementation (`query_4.sql`)

-- convert the date list implementation into the base-2 integer datelist representation.
-- Assume that you have access to a table called `user_devices_cumulated` with the output of the above query. 
-- To check your work, you can either load the data from your previous query (or the lab) into a `user_devices_cumulated` table, 
--  or you can generate the `user_devices_cumulated` table as a CTE in this query.

WITH todays_user_history AS (
    SELECT *
    -- created my user_devices_cumulated table from last question to use here
    FROM siawayforward.user_devices_cumulated
    WHERE date = DATE('2023-08-19')
    
), date_list_int AS (
  SELECT
    user_id,
    browser_type,
    CAST(
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date)
          THEN POW(2, 30 - DATE_DIFF('day', sequence_date, date))
          ELSE 0 END
      ) AS BIGINT
    ) AS history_int
  FROM todays_user_history
  -- checking against test interval Aug 14-19 2023
  CROSS JOIN UNNEST (SEQUENCE(DATE('2023-08-14'), DATE('2023-08-19'))) AS t (sequence_date)
  GROUP BY 1, 2

)
SELECT *,
  TO_BASE(history_int, 2) AS date_list_binary,
  BIT_COUNT(history_int, 32) AS total_days_active
FROM date_list_int
-- test user: -108823150
-- WHERE user_id = -108823150
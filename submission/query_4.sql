WITH today AS (
-- get the current day's snapshot from web_devices cumulated table
SELECT user_id -- user id visiting the website
    -- user's browser type
     , browser_type
     -- array of days active
     , dates_active
     , date
FROM user_devices_cumulated
WHERE date = DATE('2021-01-07')
)
, date_list_int AS (
SELECT user_id
     , browser_type
     -- convert the array into integer
     -- extrapolate a user record by each day of week creating 7 records for each user
     , CAST(SUM(CASE WHEN CONTAINS(dates_active, sequence_date)
     -- get weighted exponential power of the nearest date of login from current snapshot and convert to integer
           THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
           -- if user never logged in in the last week then 0
       ELSE 0 END) AS BIGINT) AS date_int
FROM today
-- create 7 rows for each user by creating a row for each day of the week
CROSS JOIN UNNEST (SEQUENCE(DATE('2021-01-02'), DATE('2021-01-07'))) AS t(sequence_date)
GROUP BY user_id
       , browser_type
 )

SELECT user_id
     , browser_type
     -- convert the integer to binary representation for storing
     , TO_BASE(date_int, 2) AS days_active_binary
FROM date_list_int

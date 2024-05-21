/*

User Devices Activity Int Datelist Implementation (query_4.sql)
Building on top of the previous question, convert the date list implementation into the base-2 integer datelist representation as shown in the fact data modeling day 2 lab.

Assume that you have access to a table called user_devices_cumulated with the output of the above query. To check your work, you can either load the data from your previous query (or the lab) into a user_devices_cumulated table, or you can generate the user_devices_cumulated table as a CTE in this query.

You can write this query in a single step, but note the three main transformations for this to work:

* unnest the dates, and convert them into powers of 2
* sum those powers of 2 in a group by on user_id and browser_type
* convert the sum to base 2

*/


WITH
  today_data AS (
    SELECT *
    FROM harathi.user_devices_cumulated
    WHERE date = DATE('2022-09-25')
  ),
  user_pow2 AS (
     SELECT
      user_id,
      browser_type,
      SUM(CASE
          WHEN CONTAINS(dates_active, sequence_date) 
          THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE('2022-09-25')))
          ELSE 0
        END) AS pow2_active_days
    FROM
      today_data
      CROSS JOIN UNNEST(SEQUENCE(DATE('2022-09-23'), DATE('2022-09-25'))) AS t(sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
-- Convert the power of two values to binary representation
SELECT
  user_id,
  browser_type,
  TO_BASE(CAST(pow2_active_days AS INT), 2) AS active_days_binary
FROM
  user_pow2

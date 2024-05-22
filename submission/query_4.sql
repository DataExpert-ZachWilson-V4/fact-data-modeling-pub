/* User Devices Activity Int Datelist Implementation (query_4.sql)

Building on top of the previous question, convert the date list implementation into 
the base-2 integer datelist representation as shown in the fact data modeling day 2 lab.

Assume that you have access to a table called user_devices_cumulated with the output 
of the above query. To check your work, you can either load the data from your previous 
query (or the lab) into a user_devices_cumulated table, or you can generate the 
user_devices_cumulated table as a CTE in this query.

You can write this query in a single step, but note the three main transformations for 
this to work:
- unnest the dates, and convert them into powers of 2
- sum those powers of 2 in a group by on user_id and browser_type
- convert the sum to base 2
*/
WITH today AS (
    SELECT *
    FROM danieldavid.user_devices_cumulated
    -- one week of data
    WHERE date = DATE('2023-01-07')
),
-- sum those powers of 2 in a group by on user_id and browser_type
date_list_int AS (
    SELECT
        user_id,
        browser_type,
        CAST(SUM(
            CASE WHEN CONTAINS(dates_active, sequence_date) 
                -- calculates the power of 2 for each day user was active
                    THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
                ELSE 0
            END
            ) AS BIGINT
        ) AS history_int
    FROM
        today
        -- unnest the dates, and convert them into powers of 2
        CROSS JOIN UNNEST(SEQUENCE(
            DATE('2023-01-01'), DATE('2023-01-07')
            )) AS t(sequence_date)         
    GROUP BY
        user_id, 
        browser_type
)
SELECT
    user_id,
    browser_type,
    -- convert the sum to base 2
    TO_BASE(history_int, 2) AS history_base_2,
    DATE('2023-01-07') AS date
FROM date_list_int 
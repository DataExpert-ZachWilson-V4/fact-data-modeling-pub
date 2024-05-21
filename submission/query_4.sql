
-- QUERY N.4

-- User Devices Activity Int Datelist Implementation (query_4.sql)
-- Building on top of the previous question, convert the date list implementation 
-- into the base-2 integer datelist representation as shown in the fact data modeling day 2 lab.

-- Assume that you have access to a table called user_devices_cumulated with the output of the above query. 
-- To check your work, you can either load the data from your previous query (or the lab) into a user_devices_cumulated table, 
-- or you can generate the user_devices_cumulated table as a CTE in this query.

-- You can write this query in a single step, but note the three main transformations for this to work:

-- unnest the dates, and convert them into powers of 2
-- sum those powers of 2 in a group by on user_id and browser_type
-- convert the sum to base 2

WITH
    today AS (
        SELECT
            *
        FROM
            vzucher.user_devices_cumulated
        WHERE
            DATE = DATE('2021-01-04')
    ),
    TRANSFORM AS (
        SELECT
            *,
            CAST(
                CASE
                    WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 30 - DATE_DIFF('day', sequence_date, DATE))
                    ELSE 0
                END AS BIGINT
            ) AS power2
        FROM
            today
            CROSS JOIN UNNEST (SEQUENCE(DATE('2021-01-02'), DATE('2021-01-04'))) AS t (sequence_date)
    ),
    encoded AS (
        SELECT
            user_id,
            browser_type,
            sum(power2) AS power2
        FROM
            TRANSFORM
        GROUP BY
            user_id,
            browser_type
    )
    
SELECT
    user_id,
    browser_type,
    to_base(power2, 2) AS binary
FROM
    encoded

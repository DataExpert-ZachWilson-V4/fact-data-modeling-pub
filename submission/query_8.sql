INSERT INTO
    akshayjainytl54781.host_activity_reduced 
    WITH yesterday AS ( -- CTE to hold yesterday's data
        SELECT
            *
        FROM
            akshayjainytl54781.host_activity_reduced
        WHERE
            month_start = '2023-01-01'
    ),
    today AS ( -- CTE to hold today's data
        SELECT
            *
        FROM
            akshayjainytl54781.daily_web_metrics -- Which schema to use here? bootcamp is unavailable. Workflow fails without a schema name
        WHERE
            date = DATE '2023-01-02'
    )
SELECT
    COALESCE(t.host, y.host) host,
    COALESCE(t.metric_name, y.metric_name) metric_name,
    -- The `REPEAT` function is pretty cool. It helps repeat an element 'n' number of times
    -- In this case, we fill the array with existing values + NULLs for missing dates - no dates in the month would be missing now
    COALESCE(
        y.metric_array,
        REPEAT( -- When there's no historical/yesterday's data, repeat 'null' for the number 
        -- of times for the date difference between '2023-01-01' and 't.date'.
        -- This helps to fill in gaps for rows when there is no data
            null,
            CAST(
                DATE_DIFF('day', DATE('2023-01-01'), t.date) AS INTEGER
            )
        )
    ) || ARRAY [t.metric_value] AS metric_array, -- Chronological order of metric values
    '2023-01-01' AS month_start
FROM
    today t 
    FULL OUTER JOIN yesterday y ON (t.host = y.host) -- Get today and yesterday's data by full outer join
    AND (t.metric_name = y.metric_name)
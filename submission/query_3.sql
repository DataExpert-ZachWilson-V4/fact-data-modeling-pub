-- This query inserts data into the 'user_devices_cumulated' table, combining data from two different dates.

INSERT INTO luiscoelho37431.user_devices_cumulated

-- Common Table Expressions (CTEs) are used to store intermediate results for reuse in the main query.

WITH yesterday AS (
    -- This CTE selects data from the 'user_devices_cumulated' table for the date '2021-01-01'.
    SELECT * FROM luiscoelho37431.user_devices_cumulated
    WHERE date = DATE('2021-01-01')
),
today AS (
    -- This CTE selects data from the 'bootcamp.web_events' and 'bootcamp.devices' tables for the date '2021-01-02'.
    -- It performs a left outer join to combine the data based on the 'device_id' column.
    -- The result is grouped by 'user_id' and 'browser_type', and aggregates the 'event_time' column.
    SELECT 
        e.user_id,
        d.browser_type,
        array_distinct(ARRAY_AGG(CAST(event_time as DATE) ORDER BY event_time DESC)) AS dates_active,
        CAST(MAX(event_time) as DATE) as date
    FROM 
        bootcamp.web_events e
    LEFT OUTER JOIN 
        bootcamp.devices d
    ON 
        d.device_id = e.device_id
    WHERE CAST(e.event_time as DATE) = DATE('2021-01-02')
    GROUP BY e.user_id, d.browser_type
)

-- The main query combines the data from the CTEs usin a full outer join.

SELECT
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
        -- If the 'dates_active' column from the 'yesterday' CTE is not null, it is combined with the 'date' column from the 'today' CTE.
        -- Otherwise, only the 'date' column from the 'today' CTE is selected.
        WHEN y.dates_active IS NOT NULL THEN filter(ARRAY[t.date] || y.dates_active, x -> x IS NOT NULL)
        ELSE filter(ARRAY[t.date], x -> x IS NOT NULL)
    END as dates_active,
    DATE('2021-01-02') as date
FROM yesterday y 
FULL OUTER JOIN today t 
ON y.user_id = t.user_id;

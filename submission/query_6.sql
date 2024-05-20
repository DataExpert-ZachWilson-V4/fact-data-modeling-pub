-- Write a query to incrementally populate the hosts_cumulated table from the web_events table.
INSERT INTO martinaandrulli.hosts_cumulated
WITH
    --- CTE getting 'old' hosts_cumulated data where to join the new one later
    yesterday_hosts_cte AS (
        SELECT
            *
        FROM
            martinaandrulli.hosts_cumulated
        WHERE
            date = DATE('2021-01-20')
    ),
    --- CTE getting 'new' data from the web_events table
    today_hosts_cte AS (
        SELECT
            host,
            CAST(date_trunc('day', event_time) AS DATE) AS event_date
        FROM
            bootcamp.web_events
        WHERE
            date_trunc('day', event_time) = DATE('2021-01-21')
        GROUP BY
            host,
            CAST(date_trunc('day', event_time) AS DATE)
    )
SELECT
    -- If the host was already present in the past data, we use that one. If it's a new host never seen before, we user the value from the "new" data
    COALESCE(yh.host, th.host) AS host,
    CASE
        -- If we have already an entry of host_activity_datelist from the past host, we just update the list by adding the new data
        WHEN yh.host_activity_datelist IS NOT NULL THEN ARRAY[th.event_date] || yh.host_activity_datelist
        -- If the host is new, we don't have any entry of host_activity_datelist from the past of that host, we just use the new data value
        ELSE ARRAY[th.event_date]
    END AS host_activity_datelist,
    -- If new data are found for that entry, the date is the one coming from the 'today' table. But, if no new entry is found for that host in the new data, we add one year to the previous year to get the current one.
    COALESCE(th.event_date, date_add('day', 1, yh.date)) AS date 
FROM yesterday_hosts_cte AS yh
FULL OUTER JOIN today_hosts_cte AS th 
ON yh.host = th.host
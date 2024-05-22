WITH host_activity AS (
    SELECT
        host,
        ARRAY_AGG(DISTINCT date) AS host_activity_datelist,
        CURRENT_DATE AS date
    FROM
        web_events
    GROUP BY
        host
)
INSERT INTO hosts_cumulated
SELECT
    host,
    host_activity_datelist,
    date
FROM
    host_activity;

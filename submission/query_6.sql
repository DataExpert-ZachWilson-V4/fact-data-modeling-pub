-- Insert data into the hosts_cumulated table
INSERT INTO hosts_cumulated
SELECT
    we.host,
    -- Aggregate event dates into an array, ordered by date in descending order
    ARRAY_AGG(we.event_date ORDER BY we.event_date DESC) as host_activity_datelist,
    CURRENT_DATE as date
FROM web_events we
-- Group by host to get unique hosts
GROUP BY we.host
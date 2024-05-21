-- Insert data into the hosts_cumulated table
INSERT INTO hosts_cumulated
SELECT
    we.host,
    -- Aggregate event dates into an array, ordered by date in descending order
    ARRAY_AGG(DATE(we.event_time) ORDER BY DATE(we.event_time) DESC) as host_activity_datelist,
    CURRENT_DATE as date
FROM bootcamp.web_events we
-- Group by host to get unique hosts
GROUP BY we.host

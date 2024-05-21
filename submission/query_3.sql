-- Insert data into the user_devices_cumulated table
INSERT INTO user_devices_cumulated
SELECT
    we.user_id,
    d.browser_type,
    -- Aggregate event dates into an array, ordered by date in descending order
    ARRAY_AGG(DATE(we.event_time) ORDER BY DATE(we.event_time) DESC) as dates_active,
    CURRENT_DATE as date
FROM bootcamp.web_events we
-- Join web_events with devices to get browser_type
JOIN bootcamp.devices d ON we.device_id = d.device_id
-- Group by user_id and browser_type to get unique combinations
GROUP BY we.user_id, d.browser_type

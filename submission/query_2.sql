-- create cumulating user activity table by device
-- This DDL statement creates a table to store cumulating user activity by device.
-- The table is the result of joining the devices table onto the web_events table to get both the user_id and the browser_type.

-- Create the user_devices_cumulated table
CREATE TABLE user_devices_cumulated (
    user_id BIGINT,                -- User identifier
    browser_type VARCHAR,          -- Type of browser used by the user
    dates_active ARRAY(DATE),      -- Array of dates when the user was active
    date DATE                      -- The date of the latest activity
) WITH (
    format = 'PARQUET',            -- Storage format
    partitioning = ARRAY['date']   -- Partitioning by date for efficient querying
    )

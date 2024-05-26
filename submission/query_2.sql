-- The purpose of this query is to create a cumulated user activity table by device.
-- This table will be the result of joining the devices table onto the web_events table,
-- so that we can get both the user_id and the browser_type.
-- The schema of this table includes user_id, browser_type, dates_active (an array of dates when the user was active),
-- and the date field to store the most recent date of activity.
-- The partition key used is the date column to allow for more efficient querying when filtering by date.

CREATE TABLE iliamokhtarian.user_devices_cumulated (
    -- The unique identifier for the user
    user_id BIGINT,
    -- The type of browser the user is using
    browser_type VARCHAR,
    -- An array of dates when the user was active
    dates_active ARRAY(DATE),
    -- The most recent date of activity
    date DATE
) 
WITH (
    -- Use Parquet format for efficient storage and query performance
    format = 'PARQUET',
    -- Partition the table by the date column for efficient querying
    partitioning = ARRAY['date']
)

-- The purpose of this query is to create a cumulated user activity table by device.
-- This table will be the result of joining the devices table onto the web_events table,
-- so that we can get both the user_id and the browser_type.
-- The schema of this table includes user_id, browser_type, dates_active (an array of dates when the user was active),
-- and the date field to store the most recent date of activity.
-- partition key used is date column to allow for more efficient querying when filtering by date

CREATE OR REPLACE TABLE vpsjul8468082.user_devices_cumulated (
    user_id bigint,
    browser_type varchar,
    dates_active array(date),
    date date
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY['date']
)

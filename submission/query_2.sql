-- Create the user_devices_cumulated table
CREATE TABLE user_devices_cumulated (
    user_id bigint,
    browser_type varchar,
    dates_active array(date),
    date date
)
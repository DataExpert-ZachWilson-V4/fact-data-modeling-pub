-- Write a DDL statement to create a cumulating user activity table by device.


CREATE OR REPLACE TABLE user_devices_cumulated_new
(
        user_id BIGINT,             -- User identfier
        browser_type VARCHAR,       -- Browser Type of the user used for this activity
        dates_active ARRAY(date),   -- Date of the user being active 
        date DATE                   -- Current date
)
WITH
(
    partitioning = Array['date']    -- Partitioning is good on Date
)


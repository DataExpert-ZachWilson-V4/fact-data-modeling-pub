CREATE TABLE user_devices_cumulated ( -- CTE to hold cumulative user activity 
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE), -- datelist datelist that tracks how many times a user has been active with a given
    date DATE
)
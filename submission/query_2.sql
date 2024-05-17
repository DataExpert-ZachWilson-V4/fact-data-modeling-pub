CREATE TABLE user_devices_cumulated ( -- CTE to hold cumulative user activity 
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE)
    date DATE
)
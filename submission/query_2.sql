-- create table user_devices_cummulated that contains an array of dates_active for each user_id and browser_type

CREATE OR REPLACE TABLE ovoxo.user_devices_cummulated (
    user_id BIGINT,  -- user idenifier
    browser_type VARCHAR, -- browser type used by user during event
    dates_active ARRAY(DATE), -- array containing dates a user was active for a specific browser type - date list array
    date DATE
)
WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['date']
)

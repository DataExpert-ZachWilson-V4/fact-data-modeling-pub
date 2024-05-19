CREATE TABLE host_devices_cumulated (
    host_id BIGINT,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
WITH
    (FORMAT = 'PARQUET', partitioning = ARRAY['date'])

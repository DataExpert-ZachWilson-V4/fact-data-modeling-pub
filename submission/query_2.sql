CREATE OR REPLACE TABLE faraanakmirzaei15025.user_devices_cumulated
(
     user_id bigint,
        browser_type varchar,
        dates_active ARRAY(date),
        date date
        )
    WITH (
        format = 'PARQUET',
        partitioning = ARRAY['date'] )
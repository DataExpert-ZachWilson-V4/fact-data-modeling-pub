CREATE OR REPLACE TABLE malmarzooq80856.host_activity_reduced (
    host VARCHAR,                          
    metric_name VARCHAR,             
    metric_array ARRAY(INTEGER),       
    month_start VARCHAR         
) WITH (
    FORMAT = 'PARQUET',                  
    PARTITIONING = ARRAY['metric_name', 'month_start']  
)
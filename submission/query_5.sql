-- Create ovoxo.hosts_cumulated table that contains information on activity for each host + date

CREATE OR REPLACE TABLE ovoxo.hosts_cumulated (
    host VARCHAR, -- host name
    host_activity_datelist ARRAY(DATE), -- array containing dates a there was an activity for the host - date list array
    date DATE
) WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['date']
)

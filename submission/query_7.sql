--Monthly reduced fact table showing an array of counts for each host and metric_name for a given month
--Values in metric_array are in ascending order - the 1st value is for the 1st of the month, etc.
CREATE OR REPLACE TABLE host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,		--Metric name - used for partitioning
  metric_array ARRAY(INTEGER),		--Array of values in ascending order by date
  month_start VARCHAR		--Reporting month - used for partitioning
) WITH (
  FORMAT = 'PARQUET',
  PARTITIONING = ARRAY['metric_name','month_start']
)
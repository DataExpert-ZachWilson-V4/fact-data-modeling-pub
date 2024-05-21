INSERT INTO adbeyer.host_activity_reduced with yesterday as (
  SELECT 
    * 
  FROM 
    adbeyer.host_activity_reduced 
  where 
    month_start = '2023-05-01'
), 
today as (
  SELECT 
    * 
  FROM 
    adbeyer.daily_metrics 
  WHERE 
    date = DATE('2023-05-02')
) 
SELECT 
  COALESCE(yesterday.host, today.host) as host, 
  COALESCE(
    yesterday.metric_name, today.metric_name
  ) as metric_name, 
  COALESCE(
    yesterday.metric_array, 
    REPEAT(
      NULL, 
      CAST(
        DATE_DIFF(
          'day', 
          DATE(month_start), 
          today.date
        ) AS INTEGER
      )
    )
  ) || ARRAY[today.metric_value] as metric_array, 
  '2023-05-01' as month_start 
FROM 
  today FULL 
  OUTER JOIN yesterday ON today.host = yesterday.host 
  and today.metric_name = yesterday.metric_name

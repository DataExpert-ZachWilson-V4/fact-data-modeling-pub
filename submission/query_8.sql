INSERT INTO
  pratzo.host_activity_reduced  
WITH
  -- Getting data for 'yesterday'
  yesterday AS (
    SELECT
      host,                      
      metric_name,               
      metric_array,              
      month_start                
    FROM
      pratzo.host_activity_reduced
    WHERE
      month_start = '2023-08-01' -- Starting point is the start of the month
  ),
  -- CTE to fetch data for the 'current day'
  today AS (
    SELECT
      host,                      
      metric_name,             
      metric_value,              
      DATE                    
    FROM
      pratzo.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')  -- 'Current day' will get updated as we aggregate further
  )
-- Main query to insert data in the host_activity_reduced table
SELECT
  COALESCE(t.host, y.host) AS host,  -- Handling NULLs
  COALESCE(t.metric_name, y.metric_name) AS metric_name,  -- Handling NULLs
  -- We want to ensure that arrays are the same size for comparison
  COALESCE(
    y.metric_array,
    -- padding NULLS to yesterday's metric array to ensure all arrays are of similar length
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,  -- Appending the arrays 
  '2023-08-01' AS month_start  -- Keeping the month_start as 2023-08-01 for comparison
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host = y.host  
  AND t.metric_name = y.metric_name  
-- query_8 Reduced Host Fact Array Implementation
-- Already created the daily_web_metrics table and populated the data 

INSERT INTO
  aayushi.host_activity_reduced  -- Inserting data into the host_activity_reduced table
WITH
  yesterday AS (
    SELECT
        host              
      , metric_name              
      , metric_array           
      , month_start             
    FROM
      aayushi.host_activity_reduced
    WHERE
      month_start = '2023-08-01' -- Filtering for the start of the month
  ), -- CTE to fetch data for the previous month start (2023-08-01)

  today AS (
    SELECT
        host                     
      , metric_name           
      , metric_value             
      , DATE                    
    FROM
      aayushi.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')  -- Filtering for the current date
  )  -- CTE to fetch data for the current day of the minth (2023-08-02)

-- Main query to insert data in the host_activity_reduced table
SELECT
    COALESCE(t.host, y.host) AS host                         -- Handling NULL values with COALESCE
  , COALESCE(t.metric_name, y.metric_name) AS metric_name    
  , COALESCE(
        y.metric_array,  -- If the metric_array exists from yesterday
        -- If not, create an array of NULLs with length based on the difference in days
        REPEAT(
        NULL,
        CAST(
            DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
        )
        )
    ) || ARRAY[t.metric_value] AS metric_array  -- Append today's metric_value to the metric_array
  , '2023-08-01' AS month_start                 -- Setting the date as 2023-08-01 for all records  for simplified view
FROM
  today t
FULL OUTER JOIN yesterday y 
    ON t.host = y.host AND t.metric_name = y.metric_name  -- Joining today's and yesterday's data on host and metric_name
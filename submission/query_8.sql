INSERT INTO mmarquez225.host_activity_reduced
WITH yesterday AS (
    SELECT *
    FROM mmarquez225.host_activity_reduced
    WHERE month_start = '2022-12-31'  -- Assuming '2022-12-31' is the previous month's start date
),

today AS (
    SELECT 
        host,                            
        metric_name,
        metric_value,
        DATE
    FROM mmarquez225.daily_web_metrics
    WHERE DATE = DATE('2023-01-01')       

SELECT 
    COALESCE(t.host, y.host) AS host,                        
    COALESCE(t.metric_name, y.metric_name) AS metric_name,   
    COALESCE(
        y.metric_array,                                      
        REPEAT(                                              -- If no previous data, create a new array with NULL values for the days up to the current date
            NULL,
            CAST(
                DATE_DIFF('day', DATE('2022-12-31'), t.date) AS INTEGER
            )
        )
    ) || ARRAY[t.metric_value] AS metric_array,             -- Append the current metric_value to the metric_array
    '2023-01-01' AS month_start                             -- Set the month_start column to the first day of the current month
FROM 
    today t
    FULL OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name
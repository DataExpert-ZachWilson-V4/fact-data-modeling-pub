-- Insert into the host_activity_reduced table
INSERT INTO nonasj.host_activity_reduced
-- Common Table Expressions (CTEs) to handle data from previous day and current day
WITH
    -- CTE for data from the previous day
    yesterday AS (
        SELECT
            host,
            metric_name,
            metric_array,
            month_start
        FROM
            nonasj.host_activity_reduced
        WHERE
            month_start = '2023-01-01' -- Select data for the previous month
    ),
    -- CTE for data from the current day
    today AS (
        SELECT
            host,
            metric_name,
            CAST(metric_value AS INTEGER) AS metric_value, -- Convert metric_value to INTEGER
            date
        FROM
            nonasj.daily_web_metrics
        WHERE
            date = DATE '2023-01-02' -- Select data for the current month
    )
-- Main query to merge data from previous and current days
SELECT
    COALESCE(y.host, t.host) AS host, -- Choose the non-null host value between yesterday and today
    COALESCE(y.metric_name, t.metric_name) AS metric_name, -- Choose the non-null metric_name value between yesterday and today
    COALESCE(
        y.metric_array, -- Use the metric_array value from yesterday if not null
        REPEAT(
            NULL,
            CAST(
                DATE_DIFF('day', DATE '2023-01-01', t.date) AS INTEGER -- Calculate the number of days between today's date and the start of the month
            )
        )
    ) || ARRAY[t.metric_value] AS metric_array, -- Concatenate metric_array from yesterday with the current day's metric_value
    '2023-01-01' AS month_start -- Set the month_start value to the start of the month
FROM
    yesterday y
    FULL OUTER JOIN today t ON y.host = t.host AND y.metric_name = t.metric_name -- Perform a full outer join between yesterday and today on host and metric_name
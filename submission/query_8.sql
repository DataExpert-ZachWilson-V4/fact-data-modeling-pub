--Inserts rows into videet.host_activity_reduced from daily metrics table
INSERT INTO videet.host_activity_reduced
-- Define two Common Table Expressions (CTEs) to handle the processing of historical data and current daily metrics
WITH yesterday AS (
  -- Selects all entries from the 'host_activity_reduced' table for the start of the month.
  -- This data represents aggregated metrics up to the start of this period.
  SELECT *
  FROM videet.host_activity_reduced
  WHERE month_start = '2023-02-01'  -- Targeting data for February 2023.
),
today AS (
  -- Selects all entries from the 'daily_web_metrics' table for the specific day.
  -- These metrics are to be added to or create new entries in the 'host_activity_reduced' table.
  SELECT *
  FROM videet.daily_web_metrics    --Created this table so test could runs without errors.
  WHERE date = DATE('2023-02-02')  -- Focusing on metrics recorded on February 2, 2023.
)

-- Final SELECT statement to merge 'yesterday' and 'today' data and prepare the update/insert for the 'host_activity_reduced' table
SELECT
  COALESCE(t.host, y.host) AS host,  -- Ensuring no null host values by taking either today's or yesterday's host.
  COALESCE(t.metric_name, y.metric_name) AS metric_name,  -- Taking the metric name from either today or yesterday.
  COALESCE(
    y.metric_array,
    REPEAT(
      NULL,  -- Imputing empty values into the metric array for days with no metrics recorded.
      CAST(
        DATE_DIFF('day', DATE('2023-02-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,  -- Concatenating today's metric with the historical array, if any is available.
  '2023-02-01' AS month_start  -- The aggregation period start date for the record.
FROM
  today t
FULL OUTER JOIN 
  yesterday y 
ON 
  t.host = y.host AND t.metric_name = y.metric_name  -- Joining on both host and metric name to align the records.
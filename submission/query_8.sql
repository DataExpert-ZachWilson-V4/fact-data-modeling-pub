-- ## Reduced Host Fact Array Implementation (`query_8.sql`)

-- As shown in fact data modeling day 3 lab, write a query to incrementally populate the `host_activity_reduced` table from a `daily_web_metrics` table. 
-- Assume `daily_web_metrics` exists in your query. Don't worry about handling the overwrites or deletes for overlapping data.

-- Remember to leverage a full outer join, and to properly handle imputing empty values in the array for windows where a host gets a visit in the middle of the array time window.

-- Note: For this query, you will use the daily_web_metrics table, which you created in Week 2, Lab 3. 
-- Ind populate data into the daily_web_metrics table.
-- Ensure that this table is created in your schema, as you did in Week 2 Lab. Mention the schema name in your CTE/query during the submission.

INSERT INTO rgindallas.host_activity_reduced
WITH yesterday AS (
SELECT *
  FROM rgindallas.host_activity_reduced
  WHERE month_start = '2023-08-01'
)
, today AS (
SELECT *
  FROM rgindallas.daily_web_metrics
  WHERE date = DATE('2023-08-01')
)
SELECT
  COALESCE(t.host, y.host) as host,
  COALESCE(t.metric_name, y.metric_name) as metric_name,
  COALESCE(y.metric_array, REPEAT(null, CAST(DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER))) || ARRAY[t.metric_value] as metric_array,
  '2023-08-01' AS month_start
FROM
today t
FULL OUTER JOIN 
  yesterday y ON t.host = y.host AND t.metric_name = y.metric_name

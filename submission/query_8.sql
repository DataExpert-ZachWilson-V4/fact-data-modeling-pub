--For this query, you need to re-create the table with the host column and populate data into the daily_web_metrics table. ---Ensure that this table is created in your schema, as you did in Week 2 Lab. Mention the schema name in your CTE/query
--during the submission.

INSERT INTO saidaggupati.host_activity_reduced
WITH
  old_data AS (
    SELECT * FROM saidaggupati.host_activity_reduced
    WHERE month_start = '2023-06-01'
  ),
  current_day AS (
    SELECT * FROM saidaggupati.daily_web_metrics 
    WHERE DATE = DATE('2023-06-02')
  )
SELECT
  COALESCE(cd.host, od.host) AS host,
  COALESCE(cd.metric_name, od.metric_name) AS metric_name,
  COALESCE(od.metric_array,REPEAT(NULL,CAST(DATE_DIFF('day', DATE('2023-06-01'), cd.date) AS INTEGER))) || ARRAY[cd.metric_value] AS metric_array,
  '2023-06-01' AS month_start
FROM
  old_data od FULL OUTER JOIN current_day cd ON cd.host = od.host
  AND cd.metric_name = od.metric_name
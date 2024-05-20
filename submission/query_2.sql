--User Devices Activity Datelist DDL (query_2.sql)

CREATE TABLE sanniepatron.user_devices_cumulated (
  user_id BIGINT, ---- Column to store the user ID, using BIGINT to accommodate large numbers
  browser_type VARCHAR, ---- Column to store the type of browser used, as a variable character string
  dates_active ARRAY(DATE),  -- Column to store an array of dates on which the user was active
  date DATE ---- Column to store the partition date for organizing data
)
WITH
  (FORMAT = 'PARQUET', -- Set the storage format of the table to Parquet, which is efficient for analytical queries
  partitioning = ARRAY['date']) -- Partition the table by the 'date' column to improve query performance and manageability
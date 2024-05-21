-- Create the host_activity_reduced table
CREATE TABLE host_activity_reduced (
    host varchar,
    metric_name varchar,
    metric_array array(integer),
    month_start varchar
)
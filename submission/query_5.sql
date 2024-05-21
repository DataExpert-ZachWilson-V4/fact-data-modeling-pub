 CREATE TABLE IF NOT exists  adbeyer.hosts_cumulated --creating host commulated table that uses a datelistarray to get dates accessed for each host
(host varchar,
host_activity_datelist array(date),
date date)

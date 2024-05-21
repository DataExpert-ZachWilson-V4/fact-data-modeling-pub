-- query to incrementally populate the cumulative hosts activity datelist table
-- min date in web_events table is '2021-01-02'
INSERT INTO
    RGINDALLAS.HOSTS_CUMULATED
WITH
    PREV AS (
        SELECT
            *
        FROM
            RGINDALLAS.HOSTS_CUMULATED
        WHERE
            DATE=DATE('2021-01-01') -- @start_date
    ),
    CURR AS (
        SELECT
            HOST,
            DATE(EVENT_TIME) AS DATE
        FROM
            BOOTCAMP.WEB_EVENTS
        WHERE
            DATE(EVENT_TIME)=DATE('2021-01-02') --@start_date + 1
        GROUP BY -- since want one record per host/day
            1,
            2
    )
SELECT
    COALESCE(P.HOST, C.HOST) AS HOST,
    CASE
        WHEN P.HOST_ACTIVITY_DATELIST IS NULL THEN ARRAY[C.DATE] -- case when not previously in cumulative table then start array of dates with current date
        WHEN C.DATE IS NULL THEN P.HOST_ACTIVITY_DATELIST -- case when host not occuring on current date then array of dates is same as previous host_activity_datelist
        ELSE ARRAY[C.DATE]||P.HOST_ACTIVITY_DATELIST -- case when previously in cumulative tabel and host occuring on current date then add current date as first element in previous host_activity_datelist
    END AS HOST_ACTIVITY_DATELIST,
    COALESCE(P.DATE+INTERVAL '1' DAY, C.DATE) AS DATE
FROM
    PREV P
    FULL OUTER JOIN CURR C ON P.HOST=C.HOST
    AND P.DATE+INTERVAL '1' DAY=C.DATE
    -- tag for feedback

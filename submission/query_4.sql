WITH today AS ( --generate table as CTE to pull today's data
SELECT * FROM dswills94.user_devices_cumulated --cumlated table we created
WHERE date = DATE('2023-01-07') --we want today's date
),
 date_list_int AS ( --we generate date_list CTE
SELECT
	user_id, --id of the user of web event
	browser_type, --browser type used in web event
	CAST(
		SUM(
			CASE WHEN CONTAINS(dates_active, sequence_date) --check if us sequence date is within date active array
				THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date)) --if true then raise difference between 31 and the number of days between today date and active date, by power of 2, and them sum
			ELSE 0 --when no activity then don't raise
			END
		) AS BIGINT) AS history_int --we want to change data type to BIGINT to caputre large values
FROM today
CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date) --we need to explode out dates in sequential order to see activity
GROUP BY user_id, browser_type --group datelist by user id then browser_type so we can have 1 record per user per browser
)
SELECT *,
	TO_BASE(history_int, 2) AS history_in_binary --We set the active history integer list to base two binary to see activity
FROM date_list_int

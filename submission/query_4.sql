WITH today AS (
	SELECT *
	FROM aasimsani0586451.user_devices_cumulated
	WHERE DATE = DATE ('2023-01-07')
),
date_list_int AS (
	SELECT user_id,
		browser_type,
		CAST(
			SUM(
				CASE
					WHEN CONTAINS (dates_active, sequence_date) THEN POW (2, 30 - DATE_DIFF ('day', sequence_date, DATE))
					ELSE 0
				END
			) AS BIGINT
		) AS history_int
	FROM today
		CROSS JOIN UNNEST (
			SEQUENCE (DATE ('2023-01-01'), DATE ('2023-01-07'))
		) AS t (sequence_date)
	GROUP BY user_id,
		browser_type
)
SELECT user_id,
	browser_type,
	TO_BASE(history_int, 2) as bin_rep
FROM date_list_int
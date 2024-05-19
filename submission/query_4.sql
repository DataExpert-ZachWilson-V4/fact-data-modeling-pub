-- Get today's data
WITH today AS (
	SELECT *
	FROM user_devices_cumulated
	WHERE DATE = DATE ('2023-01-07')
),
date_list_int AS (
	SELECT user_id,
		browser_type,
		-- Convert the cross joined dates to a binary representation
		-- By putting up a 1 for each date the user was active by checking 
		-- if the sequence_date is in the dates_active array and 
		-- then raising 2 to the power of the difference in days
		-- Sum it to get a number that represents the unique binary number which represents
		-- the pattern of how the user was active
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
	-- Convert the integer to a binary representation using the TO_BASE function
	TO_BASE(history_int, 2) as bin_rep
FROM date_list_int
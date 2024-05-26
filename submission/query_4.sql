WITH today AS (
SELECT 
	*
FROM mamontesp.user_devices_cumulated
WHERE date = DATE('2021-01-07')
),

date_list_int AS (
SELECT 
	  user_id
	, array_agg(transform_values(
		t.dates_active_by_browser
		, (k, v) -> REDUCE(
			v
			, 0
			, (s, x) -> s + CASE 
						WHEN CONTAINS(v, sequence_date)
							THEN POW(2, 15 - DATE_DIFF('day', sequence_date, t.date))
						ELSE 0
						END
			, s -> CAST(s AS BIGINT)
			)
		)) AS date_list_base_32
FROM today AS t
CROSS JOIN UNNEST(SEQUENCE(DATE('2021-01-01'), DATE('2021-01-07'))) AS t(sequence_date)
GROUP BY 1
),

mapped_agg_browsers AS (
SELECT
	user_id
	, REDUCE(
		date_list_base_32
		, MAP()
		, (s, x) -> map(map_keys(x), 
					transform(
						zip(
							map_values(s)
							, map_values(x)
						)
						, x -> COALESCE(x[1], 0) + COALESCE(x[2], 0)
					)
				)
		, s -> s
		) map_browsers_aggregated_by_dates
FROM date_list_int AS d
)

SELECT 
	user_id
	, transform_values(
		map_browsers_aggregated_by_dates
		, (k, v) ->  TO_BASE(v, 2)
		) AS binary_browser_usage
	, transform_values(
		map_browsers_aggregated_by_dates
		, (k, v) -> BIT_COUNT(v, 32)
		) AS map_browser_day_active 
FROM mapped_agg_browsers


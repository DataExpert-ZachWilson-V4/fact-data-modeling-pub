-- Use the ROW NUMBER function to partition the data
-- Chose it over the DISTINCT keyword because it is more flexible and possibly faster
WITH duplicate_data as (
	SELECT ROW_NUMBER() OVER (
			PARTITION BY game_id,
			team_id,
			player_id
		) as rn,
		*
	FROM bootcamp.nba_game_details
)

-- SELECT only the first row of each partition
SELECT *
FROM duplicate_data
WHERE rn = 1
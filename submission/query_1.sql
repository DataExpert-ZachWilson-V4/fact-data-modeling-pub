WITH duplicate_data as (
	SELECT ROW_NUMBER() OVER (
			PARTITION BY game_id,
			team_id,
			player_id
		) as rn,
		*
	FROM bootcamp.nba_game_details
)
SELECT *
FROM duplicate_data
WHERE rn = 1
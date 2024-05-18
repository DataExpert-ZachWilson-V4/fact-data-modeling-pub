WITH window AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS row_number
    FROM bootcamp.nba_game_details
)
SELECT *
FROM window
WHERE row_number = 1
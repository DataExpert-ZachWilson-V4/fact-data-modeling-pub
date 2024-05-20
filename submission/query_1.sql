WITH game_details AS (
  SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) AS rn
  FROM bootcamp.nba_game_details
)
SELECT *
FROM game_details 
WHERE rn = 1
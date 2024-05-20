WITH unique_game_details AS (
  SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id ORDER BY some_column) AS rn
  FROM bootcamp.nba_game_details
)
SELECT 
  game_id,
  team_id,
  team_abbreviation,
  team_city,
  player_id,
  player_name,
  nickname,
  start_position
FROM unique_game_details 
WHERE rn = 1-- condition filters the result to include only the first row for each partition

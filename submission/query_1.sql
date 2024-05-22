-- query_1
WITH ranked_game_details AS (
  SELECT
    *,
    -- Ensure each combination of game_id, team_id, and player_id has a unique row number
    ROW_NUMBER() OVER (
      PARTITION BY 
        game_id,
        team_id,
        player_id
      order by GAME_ID
    ) AS row_number
    FROM bootcamp.nba_game_details
   -- Order the initial dataset by game_id, team_id, and player_id
   ORDER BY game_id, team_id, player_id
)

SELECT
  game_id,
  team_id,
  player_id, 
  team_abbreviation, 
  player_name, 
  start_position, 
  comment, 
  MIN, 
  fgm, 
  fga, 
  fg3m, 
  fg3a, 
  ftm, 
  fta, 
  oreb, 
  dreb, 
  reb, 
  ast, 
  stl, 
  blk, 
  TO, 
  pf, 
  pts, 
  plus_minus
  FROM ranked_game_details
 -- Filter to include only the first row for each combination, effectively de-duplicating the data
 WHERE row_number = 1

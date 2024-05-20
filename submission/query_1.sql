--- Establish sequential number of rows within a partition of (game_id, team_id, player_id) set
WITH window_data_cte AS (
SELECT *,
  row_number() over (partition by game_id, team_id, player_id order by game_id, team_id, player_id) as rn 
FROM bootcamp.nba_game_details
)
SELECT *
FROM window_data_cte 
WHERE rn = 1 -- selecting only the first row out of all of them, to get only one entry and avoid duplicates
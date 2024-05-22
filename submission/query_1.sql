--Write a query to de-duplicate the nba_game_details table from the day 1 lab of the fact modeling week 2 so there are no 
--duplicate values.
--You should de-dupe based on the combination of game_id, team_id and player_id, since a player cannot have more than 1 
--entry per game.
--WEEK 2 HW: QUERY1: USING ROW_NUMBER() FUNCTION iwth combo of game_id,team_id and player_id

WITH game_details AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS r_num
  FROM saidaggupati.fct_nba_game_details 
)

SELECT 
  game_id,
  team_id,
  player_id,
  dim_player_name,
  dim_start_position,
  dim_game_date,
  dim_season,
  dim_team_did_win
FROM game_details
--pick the unique top1 row for each combination.
WHERE r_num = 1 



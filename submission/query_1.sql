/*

De-dupe Query (query_1.sql)
Write a query to de-duplicate the nba_game_details table from the day 1 lab of the fact modeling week 2 so there are no duplicate values.

You should de-dupe based on the combination of game_id, team_id and player_id, since a player cannot have more than 1 entry per game.

Feel free to take the first value here.

*/

WITH nba_values as (
  SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) as rnum
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
  start_position,
  comment,
  min,
  fgm
FROM nba_values 
WHERE rnum=1

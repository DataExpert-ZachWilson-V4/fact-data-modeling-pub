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
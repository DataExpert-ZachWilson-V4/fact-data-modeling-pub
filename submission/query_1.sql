--De-dupe Query (query_1.sql)

with duplicates as (
select * ,

 ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id   ) AS rn
from bootcamp.nba_game_details

)
select 
game_id,
team_id,
team_abbreviation,
team_city,
player_id,
player_name,
nickname,
start_position,
comment,
min
from duplicates
where rn > 1

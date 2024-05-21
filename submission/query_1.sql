--HW2 query_1
/* not including order by */

with deduped_nba_game_details AS (
select 
*,
row_number() OVER (PARTITION BY game_id, team_id, player_id order by game_id, team_id, player_id ) AS rownum --de-duping based on the combination of game_id, team_id and player_id
from bootcamp.nba_game_details
)

Select *
from deduped_nba_game_details
where rownum = 1

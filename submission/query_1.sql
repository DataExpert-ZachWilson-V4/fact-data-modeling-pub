--HW2 query_1
/* not including order by */

with deduped_nba_game_details AS (
select 
*,
row_number() OVER (PARTITION BY player_id, game_id, team_id ) AS rownum
from bootcamp.nba_game_details
)

Select *
from deduped_nba_game_details
where rownum = 1

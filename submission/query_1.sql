with nba_game_details_ranked as (
SELECT game_id, team_id, player_id
,row_number() over(partition by game_id, team_id, player_id) as rownum
from bootcamp.nba_game_details. )
select game_id, team_id, player_id from nba_game_details_ranked
where rownum = 1
order by 3,1,2

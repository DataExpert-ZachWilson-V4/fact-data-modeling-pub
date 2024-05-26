--Selecting first row from cte for each game_id, team_id, player_id
with cte as (

select *,
ROW_Number() over (partition by game_id, team_id, player_id) as rn
from bootcamp.nba_game_details
)
select * from cte
where rn=1
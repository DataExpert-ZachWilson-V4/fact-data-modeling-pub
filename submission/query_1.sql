with repeatedrows as (
    select
        *,
        row_number() over (partition by game_id,team_id,player_id ) as rownum
    from bootcamp.nba_game_details
)
select *
from repeatedrows
where rownum=1



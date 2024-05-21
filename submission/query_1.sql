with deduped as (
  select *,
  row_number() OVER (
    PARTITION BY
      game_id,
      team_id,
      player_id
  ) AS rn
  from bootcamp.nba_game_details
)
  
select *
from deduped
where rn = 1

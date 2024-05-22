/*=====================================
Write a CTE that will de duplicate all the data
in nba_game_details
*/=====================================
with deduped as (
  select *,
  -- partitioned by game_id, team_id, player_id bc player gets to only play once in the game
  row_number() OVER (
    PARTITION BY
      game_id,
      team_id,
      player_id
  ) AS rn
  from bootcamp.nba_game_details
)

-- by selecting only the first one, we are selecting all unique rows
select *
from deduped
where rn = 1

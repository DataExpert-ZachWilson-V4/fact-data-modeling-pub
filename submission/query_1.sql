--Step 1: set up a CTE to count rows with same set of identifying IDs (game_id, team_id, player_id)
with rn_cte as(
  select
  game_id, team_id, player_id,
  row_number() over (partition by game_id, team_id, player_id) as row_count
  from
  bootcamp.nba_game_details
  )
--Step 2: Note for every row in the CTE above with row_count > 1 is a duplicate according to our filtering criteria
--So we could use a WHERE clause to take them out
select 
  *
from
  rn_cte
where
  row_count = 1

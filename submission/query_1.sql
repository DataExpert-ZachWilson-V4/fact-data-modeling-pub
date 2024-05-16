---this query removes any possible duplicate row for a player in a game
---CREATE CTE WITH ROW NUMBER PARTITIONED BY game_id, player_id, team_id to find possible duplicates for a player in a game
WITH cte AS (
  SELECT row_number() OVER(PARTITION BY game_id, player_id, team_id) AS rn, *
  FROM bootcamp.nba_game_details
  )
SELECT game_id,
  team_id,
  team_abbreviation,
  team_city,
  player_id,
  player_name,
  nickname,
  start_position,
  comment,
  min,
  fgm,
  fga,
  fg_pct,
  fg3m,
  fg3a,
  fg3_pct,
  ftm,
  fta,
  ft_pct,
  oreb,
  dreb,
  reb,
  ast,
  stl,
  blk,
  to,
  pf,
  pts,
  plus_minus
FROM cte
---rn is the row number for within each partition of game/player/team. selecting the 1st row
WHERE rn=1

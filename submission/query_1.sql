-- Common Table Expression (CTE) to add a row number to each player's game details
WITH
  nba_game_details_with_rn AS (
    SELECT
      row_number() OVER ( -- Generate a row number for each row in the partition
        PARTITION BY
          game_id, -- Partition by game_id
          team_id, -- Partition by team_id
          player_id -- Partition by player_id
      ) AS rn, -- Alias the row number as rn
      * -- Select all columns from the nba_game_details table
    FROM
      bootcamp.nba_game_details -- Source table containing NBA game details
  )
-- Select specific columns from the CTE where the row number is 1
SELECT
  game_id,
  team_id,
  team_abbreviation,
  team_city,
  player_id,
  player_name,
  nickname,
  start_position,
  COMMENT,
  MIN,
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
  TO,
  pf,
  pts,
  plus_minus
FROM
  nba_game_details_with_rn
WHERE
  rn = 1; -- Filter to include only the first row in each partition

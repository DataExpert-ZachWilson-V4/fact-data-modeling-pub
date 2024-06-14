-- Using a Common Table Expression (CTE) to create a temporary table named 'deduped'
WITH deduped AS (
  -- Assigning a unique row number to each row within a partition of game_id, team_id, and player_id
  SELECT
    ROW_NUMBER() OVER (
      PARTITION BY game_id, team_id, player_id
    ) AS row_id,
    *
  FROM
    bootcamp.nba_game_details
)
-- Selecting all columns from the CTE 'deduped' where row_id is 1
-- This effectively removes duplicate entries based on game_id, team_id, and player_id
SELECT
  *
FROM
  deduped
WHERE
  row_id = 1

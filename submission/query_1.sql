CREATE OR REPLACE TABLE jsgomez14.fct_nba_game_details_deduped AS 
WITH rn_marking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS rn
    -- We have to differentiate the rows with the same game_id, team_id, and player_id.
    -- That's why we use the ROW_NUMBER() function and partitioned by the columns mentioned.
  FROM jsgomez14.fct_nba_game_details -- Lab 1 - Fact Table
)
SELECT *
FROM rn_marking
WHERE rn = 1
-- We take the first repeated row and discard the rest.
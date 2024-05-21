CREATE OR REPLACE TABLE bootcamp.fct_nba_game_details_deduped AS 
WITH rn_marking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS rn
    -- This is becuase we need to remove the duplicates based on the columns mentioned
    -- Hence we are using the row_number window function
  FROM bootcamp.nba_game_details -- Lab 1 - Fact Table
)
SELECT *
FROM rn_marking
WHERE rn = 1
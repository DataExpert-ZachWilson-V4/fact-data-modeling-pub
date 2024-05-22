-- CTE to assign a row number to each row partitioned by game_id, team_id, and player_id
WITH data_ranked AS (
  -- Select all columns and assign row numbers to each row within each partition
  SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY game_id, team_id, player_id
    ) AS row_num
  FROM bootcamp.nba_game_details
)
-- Select only the rows where row_num is 1, filtering out duplicates
SELECT *
FROM data_ranked
WHERE row_num = 1

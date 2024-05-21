WITH data_ranked AS (
  -- query to get row number for each row partitioned by id columns
  SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY game_id, team_id, player_id
    ) AS row_num
  FROM bootcamp.nba_game_details
)
-- select only rows with row num = 1 while the others are duplicates
SELECT *
FROM data_ranked
WHERE row_num = 1

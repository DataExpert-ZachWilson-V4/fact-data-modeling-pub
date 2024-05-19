-- CTE to identify and rank duplicate rows based on game_id, team_id, and player_id
WITH unique_games AS (
    SELECT
        *,
        -- Assign a unique row number to each row within the partition
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS row_num
    FROM
        bootcamp.nba_game_details
)

-- Select only the first occurrence of each combination of game_id, team_id, and player_id
SELECT *
FROM unique_games
WHERE row_num = 1
-- Using a Common Table Expression (CTE) to create a temporary table with row numbers
WITH game_details_numbered AS (
    SELECT
        *,
        -- Assign a unique row number to each row within a partition of game_id, team_id, and player_id
        ROW_NUMBER() over (
            PARTITION BY game_id,
            team_id,
            player_id
        ) AS row_number
    FROM
        bootcamp.nba_game_details
)

-- Select all rows where the row number is 1, effectively removing duplicates
SELECT *
FROM game_details_numbered
WHERE row_number = 1
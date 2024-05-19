-- Common Table Expression (CTE) named 'row_numbers' to assign row numbers within each partition
WITH row_numbers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                game_id,         -- Partitioning by game ID
                team_id,         -- Then by team ID
                player_id        -- Then by player ID
        ) AS row_number       -- Assigning row numbers within each partition
    FROM
        bootcamp.nba_game_details  -- Selecting data from the 'nba_game_details' table
)

-- Main SELECT statement to retrieve data from the 'row_numbers' CTE
SELECT
    *
FROM
    row_numbers            -- Retrieving data from the 'row_numbers' CTE
WHERE
    row_number = 1          -- Filtering to include only the first row within each partition to deduplicate

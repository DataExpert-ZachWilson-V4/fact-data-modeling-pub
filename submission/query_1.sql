-- Deduplicates nba game details with CTE that selects the first row from partition of (game_id, team_id, player_id)
WITH deduped_nba_game_details AS (
        SELECT -- Selects all data over partition then labels the duplicate data by row numbers
            ROW_NUMBER() OVER ( --groups data by the 3 below columns
                PARTITION BY
                    game_id,  -- Partition the data by game_id
                    team_id,  -- Partition the data by team_id
                    player_id -- Partition the data by player_id
            ) ROW_ID, -- Adds a new column "ROW_ID" that numbers the duplicate rows
            * -- Select all columns from the "bootcamp.nba_game_details" table,
        FROM bootcamp.nba_game_details -- Source table containing NBA game details
    )
SELECT dgd.* -- Select all columns from the CTE "deduped_nba_game_details" excluding row number
FROM
    deduped_nba_game_details dgd -- Alias for the CTE
WHERE
    ROW_ID = 1 -- Filter to keep only the first row in each partition
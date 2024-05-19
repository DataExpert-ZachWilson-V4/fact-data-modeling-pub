-- De-dupe Query (query_1.sql)
-- This query de-duplicates the nba_game_details table based on the combination of game_id, team_id, and player_id.

-- Step 1: Create a new table by copying the data from the existing table
CREATE TABLE alissabdeltoro.nba_game_details AS
SELECT *
FROM bootcamp.nba_game_details

-- Step 2: Use a CTE to identify and rank duplicates in the copied table
WITH ranked_games AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS rn
    FROM
        alissabdeltoro.nba_game_details
)

-- Step 3: Delete duplicate rows, keeping only the first occurrence
-- Note: It's recommended to copy the table and perform deduplication on the copy to avoid data loss.
-- However, directly deleting duplicates from the original table is done here for the homework assignment.
DELETE FROM alissabdeltoro.nba_game_details
WHERE (game_id, team_id, player_id) IN (
    SELECT game_id, team_id, player_id
    FROM ranked_games
    WHERE rn > 1
)

-- Step 4: Verify the deduplication
-- Note: After deduplication, it's good practice to verify the results.
SELECT *
FROM alissabdeltoro.nba_game_details

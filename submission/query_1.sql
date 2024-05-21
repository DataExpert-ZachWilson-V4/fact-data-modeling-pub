-- Step 1: Create a CTE to rank the rows and identify duplicates
WITH ranked_games AS (
    -- Selects game details along with row numbers partitioned by game_id, team_id, and player_id
    SELECT
        game_id,
        team_id,
        player_id,
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS rn
    FROM
        bootcamp.nba_game_details
)
-- Step 2: Create a new table with de-duplicated data
-- Selects all columns from ranked_games where row number is 1 to deduplicate records based on game_id, team_id, and player_id
SELECT
    *
FROM
    ranked_games
WHERE
    rn = 1

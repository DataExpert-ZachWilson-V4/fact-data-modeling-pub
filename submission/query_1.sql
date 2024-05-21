-- Use a Common Table Expression (CTE) to rank rows based on the combination of game_id, team_id, and player_id
WITH ranked_game_details AS (
    SELECT
        *,
        -- Assign a row number to each row within the partition of game_id, team_id, and player_id
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) as row_num
    FROM bootcamp.nba_game_details
)
-- Select only the rows where the row number is 1, effectively de-duplicating the table
SELECT
    game_id,
    team_id,
    team_abbreviation,
    team_city,
    player_id,
    player_name,
    nickname,
    start_position,
    comment,
    min
FROM ranked_game_details
WHERE row_num = 1;

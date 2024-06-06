
WITH ranked AS (
    -- Assign a row number to each row within a group of game_id, team_id, and player_id
    SELECT *, ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id ORDER BY game_id) as rn
    FROM academy.bootcamp.nba_game_details
)
-- Select only the rows where the row number is 1, removing duplicates
SELECT * FROM ranked WHERE rn = 1
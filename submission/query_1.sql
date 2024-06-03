WITH deduped_data AS (
    -- Deduplicate the data based on game_id, team_id, and player_id
    SELECT *,
                 ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS rn
    FROM bootcamp.nba_game_details
)
-- Select only the first occurrence of each combination of game_id, team_id, and player_id
SELECT *
FROM deduped_data
WHERE rn = 1

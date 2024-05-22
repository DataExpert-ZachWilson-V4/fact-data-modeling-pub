WITH ranked_details AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS row_num
    FROM nba_game_details
)
SELECT
    game_id,
    team_id,
    player_id
FROM ranked_details
WHERE row_num = 1;

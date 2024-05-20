WITH ranked AS (
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS rankno
FROM bootcamp.nba_game_details
)

SELECT *
FROM ranked
WHERE rankno=1
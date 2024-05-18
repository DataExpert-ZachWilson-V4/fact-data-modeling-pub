-- Using row number to take the first row in case of duplicates
WITH nba_game_details_dedup AS (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS r_number,
        *
    FROM bootcamp.nba_game_details
)

SELECT
*
FROM  nba_game_details_dedup
WHERE r_number = 1
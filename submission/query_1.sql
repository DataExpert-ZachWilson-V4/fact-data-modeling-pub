WITH 

game_details_numbered AS (
    SELECT
        *,
        ROW_NUMBER() over (
            PARTITION BY game_id,
            team_id,
            player_id
        ) AS rn
    FROM
        bootcamp.nba_game_details
)

SELECT *
FROM game_details_numbered
WHERE TRUE 
    AND rn = 1

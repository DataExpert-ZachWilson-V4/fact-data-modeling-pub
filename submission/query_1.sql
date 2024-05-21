-- basic query to dedup, qualify does not exist in trino
-- we can also do a group by

WITH BASE AS (

    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY player_id, game_id, team_id ORDER BY game_id ASC) = 1 AS dup

    FROM bootcamp.nba_game_details 
    --QUALIFY ROW_NUMBER() OVER(PARTITION BY player_id, game_id, team_id ORDER BY game_id ASC) = 1 -- qualify does exist in trino

) 

SELECT
*
FROM base
WHERE dup = TRUE

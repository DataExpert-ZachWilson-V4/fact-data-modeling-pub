WITH dedup AS (
    SELECT
        *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) as rn
    FROM bootcamp.nba_game_details -- using row_number() function for combination of each game_id, team_id, player_id. Using latest dim_game_date as the 1st
)
SELECT
    *
FROM dedup
WHERE rn = 1 -- filtering out the 1st row to keep non repeating records

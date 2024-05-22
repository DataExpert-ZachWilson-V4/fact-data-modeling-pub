WITH dedup AS (
    SELECT
        *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) as rn
    FROM bootcamp.nba_game_details -- Window function to apply row number to each record
)
SELECT
    *
FROM dedup
WHERE rn = 1 -- Grab the 1st row so it filters out duplicate records

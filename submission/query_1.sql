/* A query to de-duplicate the nba_game_details table from the day 1 lab of the fact modeling week 2 so there are no duplicate values */

-- Assign row number for all records grouped by game_id, team_id and player_id
WITH row_records AS (
    SELECT 
        *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) as row_num
    FROM bootcamp.nba_game_details
)
SELECT 
    *
FROM row_records
-- Only the first row is necessary
WHERE row_num = 1
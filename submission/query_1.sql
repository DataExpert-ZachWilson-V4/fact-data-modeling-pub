/*
Write a query to de-duplicate the nba_game_details table from the day 1 lab of the fact modeling week 2 
so there are no duplicate values.
You should de-dupe based on the combination of game_id, team_id and player_id,
since a player cannot have more than 1 entry per game.
Feel free to take the first value here.
 */

-- RANKEDGAMEDETAILS CTE helps us to group by game_id , team_id and player_id and find duplicates using row_number function
WITH RankedGameDetails as
(
    SELECT 
    game_id,    -- Game identifier
    team_id ,   -- Team identifier
    player_id , -- Player identifier
    ROW_NUMBER() 
    OVER(PARTITION BY game_id, team_id , player_id)  -- Parition by these columns to find the duplicates
    as rn 
    FROM bootcamp.nba_game_details
)
-- Select the unique combination of game_id , team_id and player_id from the CTE
SELECT 
    game_id, 
    team_id, 
    player_id 
FROM RankedGameDetails
WHERE rn = 1   -- Select only the first occurence of each combination (non-duplicates)
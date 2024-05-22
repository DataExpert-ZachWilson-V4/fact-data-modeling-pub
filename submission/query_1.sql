-- 
-- Write a query to de-duplicate the nba_game_details table from the day 1 lab of the fact modeling week 2 so there are no duplicate values.

-- You should de-dupe based on the combination of game_id, team_id and player_id, since a player cannot have more than 1 entry per game.

-- Feel free to take the first value here.
-- 
WITH dedupe AS(
  SELECT *, row_number() over(partition by game_id, team_id, player_id) as rn
  FROM bootcamp.nba_game_details
)
SELECT * 
FROM dedupe
WHERE rn =1
  
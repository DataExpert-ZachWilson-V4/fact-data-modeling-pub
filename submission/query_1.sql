-- Write a query to de-duplicate the `nba_game_details` table 
-- from the day 1 lab of the fact modeling week 2 so there are no duplicate values.

-- You should de-dupe based on the combination of `game_id`, `team_id` and `player_id`, 
-- since a player cannot have more than 1 entry per game.

WITH dupes AS (
  -- game details table has a bunch of metrics
  SELECT *,
  -- create distinct partitions by game, team, player
   ROW_NUMBER() OVER(
    PARTITION BY game_id, player_id, team_id 
    ORDER BY player_id, team_id, game_id
   ) AS rn
  FROM bootcamp.nba_game_details

)
SELECT *
FROM dupes
WHERE rn = 1

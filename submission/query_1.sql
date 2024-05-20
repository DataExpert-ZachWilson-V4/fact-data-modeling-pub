-- Dedupe bootcamp.nba_game_details tables using window function and subquery
-- outer query dedupes by filtering to one instance of game_id, team_id, player_id

SELECT * 
FROM (
    -- subquery attaches a row count for each instance of game_id, team_id, player_id, no need to order by as we don't care which record we pick
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) rn 
    FROM bootcamp.nba_game_details
)
WHERE rn = 1

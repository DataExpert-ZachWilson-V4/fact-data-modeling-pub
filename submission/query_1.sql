-- QUERY N.1 
-- De-dupe Query (query_1.sql)
-- Write a query to de-duplicate the nba_game_details table from the day 1 
-- lab of the fact modeling week 2 so there are no duplicate values.

-- You should de-dupe based on the combination of
-- game_id, team_id and player_id, since a player cannot have more than 1 entry per game.

-- Feel free to take the first value here.

-- 1st Query to check which are the duplicate rows and how many times are they duplicated

-- SELECT game_id, team_id, player_id, COUNT(*) AS duplicates_count
-- FROM bootcamp.nba_game_details
-- GROUP BY game_id, team_id, player_id
-- HAVING COUNT(*) > 1

-- 2nd Query to count sum the total number of duplicates

-- SELECT SUM(occurrences - 1) AS total_duplicate_rows
-- FROM (
--     SELECT
--         game_id,
--         team_id,
--         player_id,
--         COUNT(*) AS occurrences
--     FROM bootcamp.nba_game_details
--     GROUP BY game_id, team_id, player_id
--     HAVING COUNT(*) > 1
-- ) as DuplicateCounts;

-- total_duplicate_rows
-- 289

-- 3rd Query to de-dupe the table
-- The query that will actual be ran is the following one, the previous ones are just for reference:

WITH RankedEntries AS (
    SELECT game_id, team_id, team_abbreviation, team_city, player_id, player_name, nickname, start_position, comment, min, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, stl, blk, to, pf, pts, plus_minus,
           ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY player_id) AS rn  -- Added ORDER BY for clarity in row assignment
    FROM bootcamp.nba_game_details
)
SELECT game_id, team_id, team_abbreviation, team_city, player_id, player_name, nickname, start_position, comment, min, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, stl, blk, to, pf, pts, plus_minus
FROM RankedEntries
WHERE rn = 1

-- 4th Query to count the number of rows in the original table and the deduped table

-- WITH RankedEntries AS (
--     SELECT game_id, team_id, team_abbreviation, team_city, player_id, player_name, nickname, start_position, comment, min, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, stl, blk, to, pf, pts, plus_minus,
--            ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY player_id) AS rn
--     FROM bootcamp.nba_game_details
-- ),
-- Counts AS (
--     SELECT
--         (SELECT COUNT(*) FROM bootcamp.nba_game_details) AS original_count,
--         (SELECT COUNT(*) FROM RankedEntries WHERE rn = 1) AS deduped_count
-- )

-- SELECT * FROM Count

-- original_count	deduped_count
-- 668628	668339
-- difference: 289 rows deduped
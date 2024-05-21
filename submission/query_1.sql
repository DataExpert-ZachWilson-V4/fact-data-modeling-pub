-- 0) How many rows are there in total?
-- There are 668628

-- 1) How many unique combinations of (game_id, team_id, player_id) are there in total?
-- There 668339 unique tuples of game_id, team_id, player_id

-- 2) How many records (same game_id, team_id, player_id) show up twice?
-- There are 289 tuples that have 2 rows with same game_id, team_id, player_id
-- SELECT COUNT(1) AS rows_with_multiple_entries
-- FROM (
--     SELECT COUNT(1) AS num_rep, game_id, team_id, player_id 
--     FROM bootcamp.nba_game_details
--     GROUP BY game_id, team_id, player_id
-- ) AS grouped_data
-- WHERE num_rep >= 2

-- 3) What are the different between 2 records with same game_id, team_id, player_id?
-- Let's take one for instance and see. I picked:
-- num_rep	game_id	 team_id	 player_id
-- 2	    22000028 1610612750	 201937
--
-- I found this 2 records that are the same except for fg3_pct, which is slightly different.
-- ==============================
-- Moving to resolution
SELECT * -- If you change this for COUNT(1) it returns 668339 the # of unique tuples (same game_id, team_id, player_id)
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY player_id) as rn
    FROM bootcamp.nba_game_details
) AS ranked_data
WHERE rn = 1
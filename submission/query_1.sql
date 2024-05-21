-- The goal of this SQL query is to remove duplicates for the combination of game_id, team_id, and player_id.

-- The query uses a window function to assign a row number over the combination of the three columns, 
-- selecting only the first row of each combination as unique.

WITH 
    ranked AS (
    -- assign row numbers for each unique combination of game_id, team_id, and player_id.
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS rank_num
    FROM bootcamp.nba_game_details
)

-- do not select rank_num, select remaining columns
SELECT 
    game_id,
    team_id,
    team_abbreviation,
    team_city,
    player_id,
    player_name,
    nickname,
    start_position,
    comment,
    min,
    fgm,
    fga,
    fg_pct,
    fg3m,
    fg3a,
    fg3_pct,
    ftm,
    fta,
    ft_pct,
    oreb,
    dreb,
    reb,
    ast,
    stl,
    blk,
    to,
    pf,
    pts,
    plus_minus
FROM 
    ranked 
WHERE 
    rank_num = 1 -- this ensures to keep only the first oaccurance if there are any duplicate records for `game_id, team_id, player_id` combination

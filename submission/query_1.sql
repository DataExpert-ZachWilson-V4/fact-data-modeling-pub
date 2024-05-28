-- Query to de-duplicate the nba_game_details table from the day 1 lab of 
-- the fact modeling week 2 so there are no duplicate values.
WITH
-- Give all rows numbers
    deduped_rows AS (
        SELECT 
            *,
            ROW_NUMBER() OVER (
                PARTITION BY 
                    game_id,
                    team_id,
                    player_id
            ) AS row_number
        FROM bootcamp.nba_game_details
    )
-- Keep all of the columns except row number (created above) and take only 
-- first instance to eliminate duplicates.
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
FROM deduped_rows
WHERE row_number = 1
-- Remove duplicate records from the nba_game_details table
-- Select distinct records from the common table expression (CTE)
WITH
    deduplicated AS (
        -- CTE to assign a row number to each record 
        -- partitioned by game_id, team_id, and player_id
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    game_id,
                    team_id,
                    player_id
                ORDER BY
                    player_name
            ) AS row_number
        FROM
            bootcamp.nba_game_details
    )
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
    deduplicated
    -- Retrieve only the first record for each  
    -- combination of game_id, team_id, and player_id
WHERE
    row_number = 1

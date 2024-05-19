-- de-dup nba_game_details table
-- select all distinct records from the cte
WITH
    deduped AS (
        -- CTE to add a row number to each record 
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
    deduped
    -- only the first record for each  
    -- game_id, team_id, player_id combination
WHERE
    row_number = 1 
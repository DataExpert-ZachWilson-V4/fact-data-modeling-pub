WITH Deduplicated AS ( --created a CTE called deduplicated that adds a row number partitioned by game_id, team_id and player_id, will asign different numbers to rows in which those columns are equal, starts at 1 
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS row_num
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
    plus_minus  -- explicitly selected all rows to leave out the row_num column
FROM 
    Deduplicated
WHERE 
    row_num = 1  -- selects only the first occurence eliminating duplicates

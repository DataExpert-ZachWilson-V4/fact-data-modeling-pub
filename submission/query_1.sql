WITH partitioned_data AS (
    -- CTE to partition the data by game_id, team_id, player_id
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) as rn -- Generating a row number over the window for filtering
    FROM
        bootcamp.nba_game_details
),
SELECT
    -- Query all the data from partitioned table by filtering on row number
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
    partitioned_data
WHERE
    rn = 1 -- Filtering to select only the 1st row in the partition window
    /** Stats to show number of rows between original and deduped table.
     source	    num_rows
     partitioned	668,628
     de-duped	668,339
     **/
-- This CTE (Common Table Expression) named counted_rows is used to assign row numbers to each row within partitions defined by game_id, team_id, and player_id, ordered by game_id in descending order.
WITH counted_rows AS (
    SELECT
        game_id,
        team_id,
        player_id,
        team_abbreviation,
        team_city,
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
        plus_minus,
        ROW_NUMBER() OVER (
            PARTITION BY game_id, team_id, player_id
            ORDER BY game_id DESC
        ) AS row_num
    FROM
        bootcamp.nba_game_details
    ORDER BY
        row_num DESC -- The result set from the CTE is ordered by row_num in descending order
)
-- This main query selects the columns from the counted_rows CTE where row_num equals 1, effectively selecting only the latest record for each game, team, and player.
SELECT
    game_id,
    team_id,
    player_id,
    team_abbreviation,
    team_city,
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
    counted_rows
WHERE
    row_num = 1 -- Select only rows where row_num is 1, indicating the latest record for each game, team, and player

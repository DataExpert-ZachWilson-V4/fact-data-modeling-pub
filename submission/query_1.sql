WITH counted_rows AS(
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
            PARTITION BY game_id,
            team_id,
            player_id
            ORDER BY
                game_id
        ) AS row_num
    FROM
        bootcamp.nba_game_details
    ORDER BY
        row_num desc
)
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
    row_num = 1

WITH
    first_grouped_rows AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    game_id,
                    team_id,
                    player_id
            ) as row_number
        FROM
            bootcamp.nba_game_details
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
    first_grouped_rows
WHERE
    row_number = 1
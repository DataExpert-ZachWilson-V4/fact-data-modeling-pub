-- the idea is to use a window function to have a row number over the three columns with a filter to choose only the first row
-- I do not know if I should have added a DELETE statement WHERE dup > 1 as it is a DWH and it is better to delete partitionss
with
    cte as (
        select
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    game_id,
                    team_id,
                    player_id
            ) as dup
        from
            bootcamp.nba_game_details
    )
select
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
from
    cte
where
    dup = 1
    -- 668339
    -- select count(*) from cte where dup = 1
    -- total records 668628
    -- select count(*) from bootcamp.nba_game_details
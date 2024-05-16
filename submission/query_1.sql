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
    -- 668339
select
    count(*)
from
    cte
where
    dup = 1
    -- total records 668628
select
    count(*)
from
    bootcamp.nba_game_details


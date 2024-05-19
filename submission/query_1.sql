with
    query_with_row_number as (
        SELECT
            *,
            row_number() over (
                partition by
                    game_id,
                    team_id,
                    player_id
            ) as row_num
        FROM
            bootcamp.nba_game_details
    )
select
    *
from
    query_with_row_number
where
    query_with_row_number.row_num = 1
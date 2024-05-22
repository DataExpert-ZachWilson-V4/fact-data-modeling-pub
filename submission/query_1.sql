-- Query to produce deduplicated version of nba_game_details where deduped based on game_id, team_id, and player_id
-- use row_number window function to keep only 1 row per game_id, team_id, player_id combo
with
    nba_game_details_with_row_num as (
        select
            row_number() over (
                partition by
                    game_id,
                    team_id,
                    player_id
            ) as row_num,
            *
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
    nba_game_details_with_row_num
where
    row_num = 1
    -- no feedback first commit which obviously had changes! Quote from github actions below
    -- No file changes were detected in the current push so no comments were generated. Please modify one or more of your submission files to receive LLM-generated feedback.
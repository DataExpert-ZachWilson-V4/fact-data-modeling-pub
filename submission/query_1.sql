-- Using a CTE to identify duplicates based on game_id, team_id, and player_id
WITH cte AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY game_id, team_id, player_id
            ORDER BY game_id  -- You can order by any column or leave it as is
        ) AS dup
    FROM
        bootcamp.nba_game_details
)
-- Select only unique records, keeping the first occurrence
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
    cte
WHERE
    dup = 1

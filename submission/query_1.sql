-- The purpose of this query is to remove any duplicate records in the nba_game_details table.
-- We will de-duplicate based on the combination of game_id, team_id, and player_id,
-- as a player cannot have more than one entry per game. We will retain the first occurrence of each unique combination.

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
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS row_num
    FROM academy.bootcamp.nba_game_details
) t
WHERE row_num = 1

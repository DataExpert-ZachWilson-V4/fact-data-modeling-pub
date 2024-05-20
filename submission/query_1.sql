-- Insert de-duplicated data into saismail.nba_game_details_deduped table
INSERT INTO saismail.nba_game_details_deduped

-- Common Table Expression (CTE) to rank rows based on game_id, team_id, and player_id
WITH ranked_details AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY game_id, team_id, player_id
            ORDER BY game_id, team_id, player_id
        ) AS rn
    FROM bootcamp.nba_game_details
)

-- Select de-duplicated rows where rn = 1
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
FROM ranked_details
WHERE rn = 1

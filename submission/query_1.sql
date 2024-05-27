-- Create a new table called nba_game_details_deduplicates and call all the columns in the original table

CREATE TABLE iliamokhtarian.nba_game_details_deduplicate AS
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
    -- Select all columns and assign a number to each row within each partition of game_id, team_id, player_id
    -- Order by game_id
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS row_num
    FROM bootcamp.nba_game_details
) i
-- Only select rows where the row number is 1, effectively deduplicating the dataset based on the points
WHERE row_num = 1

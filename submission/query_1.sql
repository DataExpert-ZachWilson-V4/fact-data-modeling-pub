-- Step 1: Create a CTE to rank the rows and identify duplicates
WITH ranked_games AS (
    SELECT
        game_id,
        team_id,
        player_id,
        ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id) AS rn
    FROM
        bootcamp.nba_game_details
),
-- Step 2: Create a new table with de-duplicated data
de_duplicated_table AS (
    SELECT
        r.game_id,
        r.team_id,
        r.player_id,
        MAX(n.team_abbreviation) AS team_abbreviation,
        MAX(n.team_city) AS team_city,
        MAX(n.player_name) AS player_name,
        MAX(n.nickname) AS nickname,
        MAX(n.start_position) AS start_position,
        MAX(n.comment) AS comment,
        MAX(n.min) AS min,
        MAX(n.fgm) AS fgm,
        MAX(n.fga) AS fga,
        MAX(n.fg_pct) AS fg_pct,
        MAX(n.fg3m) AS fg3m,
        MAX(n.fg3a) AS fg3a,
        MAX(n.fg3_pct) AS fg3_pct,
        MAX(n.ftm) AS ftm,
        MAX(n.fta) AS fta,
        MAX(n.ft_pct) AS ft_pct,
        MAX(n.oreb) AS oreb,
        MAX(n.dreb) AS dreb,
        MAX(n.reb) AS reb,
        MAX(n.ast) AS ast,
        MAX(n.stl) AS stl,
        MAX(n.blk) AS blk,
        MAX(n.to) AS to,
        MAX(n.pf) AS pf,
        MAX(n.pts) AS pts,
        MAX(n.plus_minus) AS plus_minus
    FROM
        ranked_games r
    JOIN
        bootcamp.nba_game_details n
    ON
        r.game_id = n.game_id
        AND r.team_id = n.team_id
        AND r.player_id = n.player_id
    WHERE
        r.rn = 1
    GROUP BY
        r.game_id,
        r.team_id,
        r.player_id
)


-- Step 3: Drop the original table
DROP TABLE bootcamp.nba_game_details

-- Step 4: Rename the final de-duplicated table
ALTER TABLE de_duplicated_table RENAME TO nba_game_details

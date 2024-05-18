-- De-duplicate the nba_game_details table based on game_id, team_id, and player_id
SELECT 
    game_id,
    team_id,
    player_id,
    MIN(team_abbreviation) AS team_abbreviation,
    MIN(team_city) AS team_city,
    MIN(player_name) AS player_name,
    MIN(nickname) AS nickname,
    MIN(start_position) AS start_position,
    MIN(comment) AS comment,
    MIN(min) AS min,
    MIN(fgm) AS fgm,
    MIN(fga) AS fga,
    MIN(fg_pct) AS fg_pct,
    MIN(fg3m) AS fg3m,
    MIN(fg3a) AS fg3a,
    MIN(fg3_pct) AS fg3_pct,
    MIN(ftm) AS ftm,
    MIN(fta) AS fta,
    MIN(ft_pct) AS ft_pct,
    MIN(oreb) AS oreb,
    MIN(dreb) AS dreb,
    MIN(reb) AS reb,
    MIN(ast) AS ast,
    MIN(stl) AS stl,
    MIN(blk) AS blk,
    MIN(to) AS to,
    MIN(pf) AS pf,
    MIN(pts) AS pts,
    MIN(plus_minus) AS plus_minus
FROM 
    bootcamp.nba_game_details
GROUP BY 
    game_id, team_id, player_id

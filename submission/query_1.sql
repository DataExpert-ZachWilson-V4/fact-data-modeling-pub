with cte as (SELECT row_number() over(partition by game_id, player_id, team_id)as rn, *
FROM
  bootcamp.nba_game_details)
select game_id, team_id, team_abbreviation, team_city, player_id, player_name, nickname, start_position, comment, min, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, reb, ast, stl, blk, to, pf, pts, plus_minus from cte
where   rn=1

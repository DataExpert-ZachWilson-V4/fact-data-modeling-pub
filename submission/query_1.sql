WITH window_cte AS ( --CTE to add row number
SELECT
  ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) as r_num,
  *
FROM
  bootcamp.nba_game_details
)
SELECT --Final query to select the first row of each group to remove dups
  game_id
  , team_id
  , team_abbreviation
  , team_city
  , player_id
  , player_name
  , nickname
  , start_position
  , comment
  , min
  , fgm
  , fga
  , fg_pct
  , fg3m
  , fg3a
  , fg3_pct
  , ftm
  , fta
  , ft_pct
  , oreb
  , dreb
  , reb
  , ast
  , stl
  , blk
  , to
  , pf
  , pts
  , plus_minus
FROM window_cte
WHERE
  r_num = 1
  

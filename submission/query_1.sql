WITH ranking_cte AS (
SELECT *
    -- compute row number for each record grouping by game_id, team_id and player_id
    -- records with same key will have row numbers serially
     , ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) row_cnt
FROM bootcamp.nba_game_details
)
-- select all columns from the ranking cte and filter for row_cnt == 1
-- This condition will filter out all duplicate records for the same key
SELECT game_id
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
     , "to"
     , pf
     , pts
     , plus_minus
FROM ranking_cte
WHERE row_cnt = 1 

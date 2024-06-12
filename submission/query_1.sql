WITH cte as (SELECT
  row_number() OVER (PARTITION BY GAME_ID,TEAM_ID, PLAYER_ID) AS ROW_ID,
  *
FROM
  bootcamp.nba_game_details)
select * from cte
WHERE ROW_ID = 1

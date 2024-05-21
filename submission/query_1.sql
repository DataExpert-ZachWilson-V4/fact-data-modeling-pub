  WITH numbered_rows --dedupes nba_players by game_id, team_id and player_id
     AS (SELECT *,
                Row_number()
                  OVER(
                    partition BY game_id, team_id, player_id) AS row_number
         FROM   bootcamp.nba_game_details)
SELECT *
FROM   numbered_rows
WHERE  row_number = 1 


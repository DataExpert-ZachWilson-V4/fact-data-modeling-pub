-- Using row number to take the first row in case of duplicates
SELECT 
    ROW_NUMBER() OVER PARTITION BY (game_id, team_id, player_id) AS r_number,
    *
FROM bootcamp.nba_game_details 
WHERE r_number = 1
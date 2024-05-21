-- de-duplicate the nba_game_details table based on the combination of game_id, team_id and player_id

WITH
    numbered_game_details AS (
        SELECT
            *,  -- get all fields from nba_game_details
            ROW_NUMBER() OVER (PARTITION by game_id, team_id, player_id) AS rn  -- group by combination of game_id, team_id and player_id and assign number to each row
        FROM bootcamp.nba_game_details
    )
SELECT * FROM numbered_game_details WHERE rn = 1    -- select first row in each combination
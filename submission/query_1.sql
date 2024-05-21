-- select all distinct records from the "bootcamp.nba_game_details"
WITH
    deduped_table AS (
        -- CTE to add a row number to each record 
        -- partitioned by game_id, team_id, and player_id
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    game_id,
                    team_id,
                    player_id
                ORDER BY
                    player_name
            ) AS row_number
        FROM
            bootcamp.nba_game_details
    )
SELECT
   *
FROM
    deduped_table
WHERE
    row_number = 1 

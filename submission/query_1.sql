-- dedup nba game details by game, team, and player
WITH
    numbered AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    game_id,
                    team_id,
                    player_id
            ) AS row_num
        FROM
            bootcamp.nba_game_details
    )
SELECT
    *
FROM
    numbered
WHERE
    row_num = 1
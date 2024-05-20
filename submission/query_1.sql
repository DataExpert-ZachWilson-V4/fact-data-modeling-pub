-- Create (CTE) that selects the first row from partition of (game_id, team_id, player_id)
WITH deduped_nba_game_details AS (
        SELECT -- Selects all data over partition then labels the duplicate data by row numbers
            ROW_NUMBER() OVER ( --groups data by the 3 below columns
                PARTITION BY
                    game_id,  -- Partition the data by game_id
                    team_id,  -- Partition the data by team_id
                    player_id -- Partition the data by player_id
            ) ROW_ID, -- Adds a new column "ROW_ID" that numbers the duplicate rows
            * -- Select all columns from the "bootcamp.nba_game_details" table,
        FROM bootcamp.nba_game_details -- Source table containing NBA game details
    )
SELECT  -- Select all columns from the CTE "deduped_nba_game_details" excluding row number
    dgd.game_id,
    dgd.team_id,
    dgd.player_id,
    dgd.team_abbreviation,
    dgd.team_city,
    dgd.player_name,
    dgd.nickname,
    dgd.start_position,
    dgd.comment,
    dgd.min,
    dgd.fgm,
    dgd.fga,
    dgd.fg_pct,
    dgd.fg3m,
    dgd.fg3a,
    dgd.fg3_pct,
    dgd.ftm,
    dgd.fta,
    dgd.ft_pct,
    dgd.oreb,
    dgd.dreb,
    dgd.reb,
    dgd.ast,
    dgd.stl,
    dgd.blk,
    dgd.to,
    dgd.pf,
    dgd.pts,
    dgd.plus_minus
FROM
    deduped_nba_game_details dgd -- Alias for the CTE
WHERE
    ROW_ID = 1 -- Filter to keep only the first row in each partition
WITH RowsRanked AS (
    -- ranking groups of unique game_id,team_id,player_id for deduplication
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY game_id,
            team_id,
            player_id
            ORDER BY game_id
        ) AS row_number
    FROM bootcamp.nba_game_details
)
SELECT *
FROM RowsRanked
WHERE row_number = 1 -- only first row in row group gets selected, all duplicates are omitted
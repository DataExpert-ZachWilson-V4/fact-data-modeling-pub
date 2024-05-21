WITH nba_game_details_distinct AS (
SELECT
  ROW_NUMBER() OVER (
    PARTITION BY
      game_id,
      team_id,
      player_id
  ) AS distinct_row_number,
  *
FROM bootcamp.nba_game_details
)
SELECT
  *
FROM nba_game_details_distinct
WHERE distinct_row_number = 1

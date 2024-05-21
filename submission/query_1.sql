-- query_1: De-dupe query

WITH fact_nba AS (
    SELECT 
        *
    ,   ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY dim_game_date) AS row_num
    FROM aayushi.fct_nba_game_details
)   -- CTE to assign a unique row number (index) to each combination of game_id, team_id, and player_id to find duplicates

-- Select all columns except row_num from the above CTE
SELECT 
    game_id
  , team_id
  , player_id
  , dim_team_abbreviation
  , dim_player_name
  , dim_start_position
  , dim_did_not_dress
  , dim_not_with_team
  , m_seconds_played
  , m_field_goals_made
  , m_field_goals_attempted
  , m_3_pointers_made
  , m_3_pointers_attempted
  , m_free_throws_made
  , m_free_throws_attempted
  , m_offensive_rebounds
  , m_defensive_rebounds
  , m_rebounds
  , m_assists
  , m_steals
  , m_blocks
  , m_turnovers
  , m_personal_fouls
  , m_points
  , m_plus_minus
  , dim_game_date
  , dim_season
  , dim_team_did_win
FROM fact_nba
WHERE row_num = 1  
-- Filter out only those rows having row number 1, filter out unique records without duplicates - de-duplication


CREATE TABLE ykshon52797255.fct_nba_game_details (
  -- game_id: stores the game id
  game_id BIGINT,
  -- team_id: stores the team id
  team_id BIGINT,
  -- player_id: stores the player id
  player_id BIGINT,
  -- dim_team_abbreviation: stores the team's abbreviation
  dim_team_abbreviation VARCHAR,
  -- dim_player_name: player name for the player id
  dim_player_name VARCHAR,
  -- dim_start_position: the starting position for the player
  dim_start_position VARCHAR,
  -- dim_did_not_dress: comment includes DND, which means the coach decided the player to be not active for the game
  dim_did_not_dress BOOLEAN,
  -- dim_not_with_team: comment includes NWT which means not with team
  dim_not_with_team BOOLEAN,
  -- m_seconds_played: total seconds that the player played
  -- converted string in min and seconds to integer seconds
  m_seconds_played INTEGER,
  -- m_field_goals_made: measure of goals made by the player
  m_field_goals_made DOUBLE,
  -- m_field_goals_attempted: measure of goals attempted by the player
  m_field_goals_attempted DOUBLE,
  -- m_3_pointers_made: measure of 3 pointers made by the player
  m_3_pointers_made DOUBLE,
  -- m_3_pointers_attempted: measure of 3 pointers points attempted by the player
  m_3_pointers_attempted DOUBLE,
  -- m_free_throws_made: measure of free throws points made by the player
  m_free_throws_made DOUBLE,
  -- m_free_throws_attempted: measure of free throws attempted by the player
  m_free_throws_attempted DOUBLE,
  -- m_offensive_rebounds: measure of offensive rebounds made by the player
  m_offensive_rebounds DOUBLE,
  -- m_defensive_rebounds: measure of defensive rebounds made by the player
  m_defensive_rebounds DOUBLE,
  -- m_rebounds: measure of rebounds made by the player
  m_rebounds DOUBLE,
  -- m_assists: measure of assists made by the plyaer
  m_assists DOUBLE,
  -- m_steals: measure of steals made by the player
  m_steals DOUBLE,
  -- m_blocks: measure of blocks made by the player
  m_blocks DOUBLE,
  -- m_turnovers: measure of turnovers made by the player
  m_turnovers DOUBLE,
  -- m_personal_fouls: measure of personal fouls made by the player
  m_personal_fouls DOUBLE,
  -- m_points: measure of points made by the player
  m_points DOUBLE,
  -- m_plus_minus: measure of plus minus (PM) of the player
  m_plus_minus DOUBLE,
  -- dim_game_date: the date of the game that the player played
  dim_game_date DATE,
  -- dim_seaosn: the season that the player played
  dim_season INTEGER,
  -- dim_team_did_win: whether the team won the game
  dim_team_did_win BOOLEAN
)
WITH
  (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['dim_season']
  )

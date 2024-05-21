-- Create a table named 'fct_nba_game_details_filtered' in the 'ningde95' schema
CREATE TABLE IF NOT EXISTS ningde95.fct_nba_game_details_filtered (
  game_id BIGINT,  -- Unique identifier for the game
  team_id BIGINT,  -- Unique identifier for the team
  player_id BIGINT,  -- Unique identifier for the player
  dim_team_abbreviation VARCHAR,  -- Abbreviation for the team
  dim_player_name VARCHAR,  -- Name of the player
  dim_start_position VARCHAR,  -- Starting position of the player
  dim_did_not_dress BOOLEAN,  -- Indicates if the player did not dress for the game
  dim_not_with_team BOOLEAN,  -- Indicates if the player was not with the team
  m_seconds_played INTEGER,  -- Number of seconds the player played
  m_field_goals_made DOUBLE,  -- Number of field goals made
  m_field_goals_attempted DOUBLE,  -- Number of field goals attempted
  m_3_pointers_made DOUBLE,  -- Number of 3-pointers made
  m_3_pointers_attempted DOUBLE,  -- Number of 3-pointers attempted
  m_free_throws_made DOUBLE,  -- Number of free throws made
  m_free_throws_attempted DOUBLE,  -- Number of free throws attempted
  m_offensive_rebounds DOUBLE,  -- Number of offensive rebounds
  m_defensive_rebounds DOUBLE,  -- Number of defensive rebounds
  m_rebounds DOUBLE,  -- Total number of rebounds
  m_assists DOUBLE,  -- Number of assists
  m_steals DOUBLE,  -- Number of steals
  m_blocks DOUBLE,  -- Number of blocks
  m_turnovers DOUBLE,  -- Number of turnovers
  m_personal_fouls DOUBLE,  -- Number of personal fouls
  m_points DOUBLE,  -- Number of points scored
  m_plus_minus DOUBLE,  -- Plus/minus statistic
  dim_game_date DATE,  -- Date of the game
  dim_season INTEGER,  -- Season of the game
  dim_team_did_win BOOLEAN,  -- Indicates if the team won the game
  rn INTEGER  -- Row number for partitioning purposes
)
-- Specify table storage format and partitioning
WITH (
  FORMAT = 'PARQUET',  -- Use the Parquet format for storage
  partitioning = ARRAY['dim_season']  -- Partition the table by 'dim_season'
)

-- Insert data into the 'fct_nba_game_details_filtered' table
INSERT INTO ningde95.fct_nba_game_details_filtered
-- Define a Common Table Expression (CTE) named 'ranked'
WITH ranked AS (
  -- Select all columns from 'fct_nba_game_details' table
  -- Generate row numbers partitioned by 'game_id', 'team_id', and 'player_id'
  -- Order the rows within each partition arbitrarily (since 'ORDER BY (SELECT NULL)' is used)
  SELECT *, ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY (SELECT NULL)) AS rn
  FROM ningde95.fct_nba_game_details
)
-- Select rows from 'ranked' where the row number is 1
SELECT * FROM ranked WHERE rn = 1

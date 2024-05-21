-- First, we define a common table expression (CTE) named 'ranked'
WITH ranked AS (
    -- Select all columns from the 'fct_nba_game_details' table
    SELECT *,
           -- Add a new column 'rn' that assigns a row number to each record
           -- The ROW_NUMBER() function is used to generate unique row numbers within each partition
           ROW_NUMBER() OVER (
               -- Partition the data by game_id, team_id, and player_id
               PARTITION BY game_id, team_id, player_id
               -- Order the rows within each partition arbitrarily
               ORDER BY (SELECT NULL)  -- Note: Using (SELECT NULL) results in no specific order
           ) AS rn
    FROM ningde95.fct_nba_game_details
)

-- Select specific columns from the 'ranked' CTE where 'rn' is 1
-- This effectively filters the data to ensure only one row per game_id, team_id, and player_id
SELECT game_id,
       team_id,
       player_id,
       dim_team_abbreviation,
       dim_player_name,
       dim_start_position,
       dim_did_not_dress,
       dim_not_with_team,
       m_seconds_played,
       m_field_goals_made,
       m_field_goals_attempted,
       m_3_pointers_made,
       m_3_pointers_attempted,
       m_free_throws_made,
       m_free_throws_attempted,
       m_offensive_rebounds,
       m_defensive_rebounds,
       m_rebounds,
       m_assists,
       m_steals,
       m_blocks,
       m_turnovers,
       m_personal_fouls,
       m_points,
       m_plus_minus,
       game_date,
       season,
       team_did_win
FROM ranked
WHERE rn = 1  -- Only include rows where 'rn' is 1 (the first row in each partition)

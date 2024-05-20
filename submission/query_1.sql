WITH
  games AS (
    SELECT
      game_id,
      game_date_est,
      season,
      home_team_wins,
      home_team_id,
      visitor_team_id
    FROM
      bootcamp.nba_games
  )
SELECT
  g.game_id,
  gd.team_id,
  gd.player_id,
  gd.player_name AS dim_player_name,
  gd.start_position AS dim_start_position,
  gd.comment LIKE '%DND%' AS dim_did_not_dress,
  gd.comment LIKE '%NWT%' AS dim_not_with_team,
  CAST(SPLIT(MIN, ':') [1] AS DOUBLE) * 60 + CAST(SPLIT(MIN, ':') [2] AS DOUBLE) AS m_seconds_played,
  CAST(fgm AS DOUBLE) AS m_field_goals_made,
  CAST(fga AS DOUBLE) AS m_field_goals_attempted,
  CAST(fg3m AS DOUBLE) AS m_3_pointers_made,
  CAST(fg3a AS DOUBLE) AS m_3_pointers_attempted,
  CAST(ftm AS DOUBLE) AS m_free_throws_made,
  CAST(fta AS DOUBLE) AS m_free_throws_attempted,
  CAST(oreb AS DOUBLE) AS m_offensive_rebounds,
  CAST(dreb AS DOUBLE) AS m_defensive_rebounds,
  CAST(reb AS DOUBLE) AS m_rebounds,
  CAST(ast AS DOUBLE) AS m_assists,
  CAST(stl AS DOUBLE) AS m_steals,
  CAST(TO AS DOUBLE) AS m_turnovers,
  CAST(pf AS DOUBLE) AS m_personal_fouls,
  CAST(pts AS DOUBLE) AS m_points,
  CAST(plus_minus AS DOUBLE) AS m_plus_minus,
  g.game_date_est AS dim_game_date,
  g.season AS dim_season,
  CASE
    WHEN gd.team_id = g.home_team_id THEN home_team_wins = 1
    ELSE home_team_wins = 0
  END AS dim_team_did_win
FROM
  games g
  JOIN bootcamp.nba_game_details gd ON g.game_id = gd.game_id
LIMIT
  10000
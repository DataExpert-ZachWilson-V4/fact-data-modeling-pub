with duplicates AS (
SELECT
	 *
	, ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id ORDER BY game_id, team_id, player_id) AS rn
FROM bootcamp.nba_game_details
)

SELECT
	 game_id
	, team_id
	, team_abbreviation
	, team_city
	, player_id
	, player_name as dim_player_name
	, start_position as dim_start_position
	, comment LIKE '%DND%' AS dim_did_not_dress
	, comment LIKE '%NWT%' AS dim_not_with_team
	, CASE
    	WHEN CARDINALITY(SPLIT(MIN, ':')) > 1 
    		THEN CAST(CAST(SPLIT(MIN, ':') [1] AS DOUBLE) * 60 + CAST(SPLIT(MIN, ':') [2] AS DOUBLE) AS INTEGER)
    	ELSE CAST(MIN AS INTEGER)
  	  END AS m_seconds_played
	, fgm AS m_field_goals_made
	, fga AS m_field_goals_attempted
	, fg3m AS m_3_pointers_made
	, fg3a AS m_3_pointers_attempted
	, ftm AS m_free_throws_made
	, fta AS m_free_throws_attempted
	, oreb AS m_offensive_rebounds
	, dreb AS m_defensive_rebounds
	, reb AS m_rebounds
	, ast AS m_assists
	, stl AS m_steals
	, to AS m_turnovers
	, pf AS m_personal_fouls
	, plus_minus as m_plus_minus
FROM duplicates
WHERE rn = 1

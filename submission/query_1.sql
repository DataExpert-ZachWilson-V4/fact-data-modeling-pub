--de-duplicate the nba_game_details table 
with unique_records as (
select *, row_number() over (partition by game_id, team_id, player_id order by dim_game_date desc)rn 
from  -- using row_number() function for combination of each game_id, team_id, player_id. Using latest dim_game_date as the 1st record.
vaishnaviaienampudi83291.fct_nba_game_details)

select game_id, --select all the columns that are in nba_game_details table
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
dim_game_date,
dim_season,
dim_team_did_win
 from 
unique_records 
where rn =1 -- here pick only record which has rn =1. It picks the first record. 

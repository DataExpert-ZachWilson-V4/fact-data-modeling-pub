-- In CTE Applying ROW_NUMBER Window function on the key columns provided in the assignment. This should generate an incremental number starting from 1 for each key combo records and reset when the key combo changes. From this subset we will fetch the records where ROW_NUMBER is 1
with dedup As
(
	Select *,ROW_NUMBER() OVER(partition by player_id, game_id, team_id order by player_id, game_id, team_id) as rnk from bootcamp.nba_game_details
)
Select 
	game_id , 
	team_id , 
	team_abbreviation , 
	team_city , 
	player_id , 
	player_name , 
	nickname , 
	start_position , 
	comment , 
	min , 
	fgm , 
	fga , 
	fg_pct , 
	fg3m , 
	fg3a , 
	fg3_pct , 
	ftm , 
	fta , 
	ft_pct , 
	oreb , 
	dreb , 
	reb , 
	ast , 
	stl , 
	blk , 
	to , 
	pf , 
	pts , 
	plus_minus  
from dedup where rnk = 1

-- Adding extra comment to force the Autograde program run on all files


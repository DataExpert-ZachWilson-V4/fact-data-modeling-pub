SELECT
	game_id, --id for each nba game
	team_id, --id for each nba team
	player_id, --id for each nab player
	COUNT(1) --to count the first value of potential dupe
FROM
	dswills94.fct_nba_game_details --pull from fact table
GROUP BY --a player cannot have more than 1 entry per game
	game_id,
	team_id,
	player_id
HAVING --filter out duplicates 
	COUNT(1) > 1

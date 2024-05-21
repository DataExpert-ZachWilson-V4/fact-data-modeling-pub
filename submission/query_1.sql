-- Deduplication of the rows based on game_id,team_id,player_id using row_number and taking first value of row number 
select *
FROM
(
SELECT *, row_number() over ( PARTITION BY game_id,team_id,player_id) rnk
FROM bootcamp.nba_game_details
)
where rnk = 1
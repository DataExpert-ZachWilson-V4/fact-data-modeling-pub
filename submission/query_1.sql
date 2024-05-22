/* De-dupe Query (query_1.sql)
Write a query to de-duplicate the nba_game_details table from the day 1 lab
of the fact modeling week 2 so there are no duplicate values.

You should de-dupe based on the combination of game_id, team_id and player_id,
since a player cannot have more than 1 entry per game.

Feel free to take the first value here.

Note: For this query, you need to filter out duplicate records and display only
unique records. To filter out duplicate records, you can use the combination of
game_id, team_id, and player_id columns. You can achieve this either by using 
ROW_NUMBER() or by using GROUP BY.
*/
-- 1) Stage: the data to label rows containing the same game_id, team_id, and player_id values as > 1
WITH deduped_stage AS (
SELECT *,
    ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) AS row_count
FROM bootcamp.nba_game_details
)
-- 2) Dedupe: only the rows with row_count = 1, thus removing duplicates
SELECT * FROM deduped_stage
WHERE row_count = 1
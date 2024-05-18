/*
This SQL query is designed to identify and handle duplicate records in the bootcamp.nba_game_details table. 
Here's a step-by-step explanation of what the query is doing:

Step 1: Creating the CTE dedup
The query first creates a Common Table Expression (CTE) named dedup
For each combination of game_id, team_id, and player_id, it groups the records.
The HAVING COUNT(*) > 1 clause ensures that only groups with more than one record are considered duplicates.
It selects the maximum value (MAX) for each field of interest to resolve the duplicates. 
This is a common strategy when deduplicating data.
*/
WITH
  dedup AS (
    SELECT
      game_id,
      team_id,
      MAX(team_abbreviation) AS team_abbreviation,
      MAX(team_city) AS team_city,
      player_id,
      MAX(player_name) AS player_name,
      MAX(nickname) AS nickname,
      MAX(start_position) AS start_position,
      MAX(COMMENT) AS COMMENT,
      MAX(MIN) AS MIN,
      MAX(fgm) AS fgm,
      MAX(fga) AS fga,
      MAX(fg_pct) AS fg_pct,
      MAX(fg3m) AS fg3m,
      MAX(fg3a) AS fg3a,
      MAX(fg3_pct) AS fg3_pct,
      MAX(ftm) AS ftm,
      MAX(fta) AS fta,
      MAX(ft_pct) AS ft_pct,
      MAX(oreb) AS oreb,
      MAX(dreb) AS dreb,
      MAX(reb) AS reb,
      MAX(ast) AS ast,
      MAX(stl) AS stl,
      MAX(blk) AS blk,
      MAX(TO) AS TO,
      MAX(pf) AS pf,
      MAX(pts) AS pts,
      MAX(plus_minus) AS plus_minus
    FROM
      bootcamp.nba_game_details
    GROUP BY
      game_id,
      team_id,
      player_id
    HAVING
      COUNT(*) > 1
  )

/*
Step 2: Selecting Non-Duplicate Records
The query then selects records from the bootcamp.nba_game_details table that are not part of the dedup CTE
*/
SELECT
  ngd.*
FROM
  bootcamp.nba_game_details AS ngd
  LEFT JOIN dedup ON ngd.game_id = dedup.game_id
  AND ngd.team_id = dedup.team_id
  AND ngd.player_id = dedup.player_id
WHERE
  dedup.game_id IS NULL
  AND dedup.team_id IS NULL
  AND dedup.player_id IS NULL
/*
Step 3: Combining Results
Finally, the query combines the non-duplicate records with the deduplicated records:
*/
UNION
SELECT
  *
FROM
  dedup

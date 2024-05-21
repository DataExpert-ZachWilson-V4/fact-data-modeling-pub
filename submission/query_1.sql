 with base as 
  ( 
    SELECT 
        game_id,
        team_id,
        team_abbreviation,
        team_city,
        player_id player_id,
        player_name,
        start_position,
        comment LIKE '%DND%' AS dim_did_not_dress,
        comment LIKE '%NWT%' AS dim_not_with_team,
        min,
        fgm,
        fga,
        fg_pct,
        fg3m,
        fg3a,
        fg3_pct,
        ftm,
        fta,
        ft_pct,
        oreb,
        dreb,
        reb,
        ast,
        stl,
        blk,
        to,
        pf,
        pts,
        plus_minus,
        ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) AS dup_row
        from 
        bootcamp.nba_game_details
  )
  select 
  game_id,
        team_id,
        team_abbreviation,
        team_city,
        player_id player_id,
        player_name,
        start_position,
        dim_did_not_dress,
        dim_not_with_team,
        min,
        fgm,
        fga,
        fg_pct,
        fg3m,
        fg3a,
        fg3_pct,
        ftm,
        fta,
        ft_pct,
        oreb,
        dreb,
        reb,
        ast,
        stl,
        blk,
        to,
        pf,
        pts,
        plus_minus
  from 
  base 
  where dup_row =1 

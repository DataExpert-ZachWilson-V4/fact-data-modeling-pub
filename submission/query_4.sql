--convert the date list implementation into the base-2 integer datelist
WITH
  today AS ( --extract today's data from user_devices_cumulated table
    SELECT
      *
    FROM
      vaishnaviaienampudi83291.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
 date_list_int AS (
    SELECT
      user_id, browser_type,
      CAST(
        SUM(
          CASE
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
            --check for every user_id, browser_type combination, check if the date from sequence is present in the dates_active. If yes, 
            --it uses a pow and date_diff function to generate the position of date.
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date) 
      --to extract the sequence of dates from 2023-01-01 to 2023-01-07, it uses cross join unnest function to generate the series.
    GROUP BY
      user_id, browser_type
  )
SELECT
  *,
  TO_BASE(history_int, 2) AS history_in_binary, --convert the history_int to base 2 using to_base combination
  TO_BASE(
    FROM_BASE('11111110000000000000000000000000', 2), 
    2
  ) AS weekly_base,
  BIT_COUNT(
    BITWISE_AND(  --using bitwise AND function to compare history_int and the sequence. If the user is active, then that position will have 1 else 0
      history_int,
      FROM_BASE('11111110000000000000000000000000', 2) -- represents the user is active for 7days because 1st 7 bits are set to 1
    ),
    64
  ) > 0 AS is_weekly_active -- if the user is active for atleast 1 day in a week, then the user is considered weekly active
FROM
  date_list_int

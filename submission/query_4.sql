/*
This query constructs a binary representation of user activity over a specific date range (January 1 to January 7, 2023).
Each bit in the binary number represents a day within that range
1 if the user was active on that day,
0 if the user was inactive.
The history_int column stores this as an integer, and history_int_binary shows it in binary format. 
This allows you to quickly see a user's activity pattern over the week.
*/
WITH
  today AS (
    SELECT
      *
    FROM
      nikhilsahni.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
  /* SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07')) generates a series of dates from January 1, 2023, to January 7, 2023.
  CROSS JOIN UNNEST(SEQUENCE(...)) AS t(sequence_date) expands each row of today by cross joining it with each date in the sequence, 
  resulting in one row for each combination of user_id, browser_type, and sequence_date.
  CASE WHEN CONTAINS(dates_active, sequence_date) THEN ... ELSE 0 END checks if each sequence_date is present in the dates_active array 
  for the user_id and browser_type. If it is, it calculates a power of 2 value; otherwise, it assigns 0.
  */
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
  /*
  POW(2, 31 - DATE_DIFF('day', sequence_date, DATE('2023-01-07'))) calculates the power of 2 based on the difference in days 
  between sequence_date and January 7, 2023, adjusting the exponent accordingly.
  By subtracting the date difference from 31, we map the sequence_date to a specific bit position
  For January 6, 2023, DATE_DIFF('day', sequence_date, DATE('2023-01-07')) is 1, so the expression becomes 31 - 1 = 30.
  */
      CAST(
        SUM(
          CASE
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, DATE))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
SELECT
  *,
  TO_BASE(history_int, 2) AS history_int_binary
FROM
  date_list_int

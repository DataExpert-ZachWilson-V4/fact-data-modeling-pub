-- This sub query is getting the data for the date we need to process
With CTE As
(
Select 
  user_id,
  browser_type,
  dates_active,
  date
from Jaswanthv.user_devices_cumulated
where date = CAST('2021-01-07' As date)
),
date_list_int As
(
Select 
  user_id,
  browser_type,
  /* We are converting the dates_active to 2 to Power of difference between the comparision range date. We are using 31 because we are trying to represent as 32 bit. Then we are Summing up the result*/
  CAST(SUM(
  CASE
    WHEN CONTAINS (dates_active, sequence_dt) Then POW(2,31 - DATE_DIFF('day',sequence_dt, date))
    Else 0
  END )As BIGINT) As History_int
from CTE C CROSS JOIN UNNEST(SEQUENCE(DATE('2021-01-01'),DATE('2021-01-07'))) As t(sequence_dt) 
GROUP BY C.user_id, C.browser_type
)
Select 
  user_id,
  browser_type,
  /* Converting the calculated column History_int from date_list_int subquery into binary representation */
  TO_BASE(History_int,2) As History_int_binary
from date_list_int


-- Adding extra comment to force the Autograde program run on all files
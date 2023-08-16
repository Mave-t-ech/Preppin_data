/*For the transactions file:
Filter the transactions to just look at DSB 
These will be transactions that contain DSB in the Transaction Code field
Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
Change the date to be the quarter 
Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) 
For the targets file:
Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter 
 Rename the fields
Remove the 'Q' from the quarter field and make the data type numeric 
Join the two datasets together 
You may need more than one join clause!
Remove unnecessary fields 
Calculate the Variance to Target for each row */

with code as (
select substring_index(transaction_code, '-', 1) as bank,
case 
when onlineorinperson = 1 then 'online'else 'in-person'end as customer, 
sum(value)as total_values,
quarter (str_to_date(transaction_date, '%d/%m/%y ')) as quarters
from dsbwk3
where substring_index(transaction_code, '-', 1) = 'DSB'
group by substring_index(transaction_code, '-', 1), quarter (str_to_date(transaction_date, '%d/%m/%y ')),
case 
when onlineorinperson = 1 then 'online'else 'in-person'end
)
, Qat as  (select OnlineOrInPerson, CAST(SUBSTRING(quarter, 2) AS UNSIGNED) as quarter, targets
 from (SELECT OnlineOrInPerson, 'Q1' AS quarter, Q1 AS targets FROM wk3_targets
UNION ALL
SELECT OnlineOrInPerson, 'Q2' AS quarter, Q2 AS targets FROM wk3_targets
UNION ALL
SELECT OnlineOrInPerson, 'Q3' AS quarter, Q3 AS targets FROM wk3_targets
UNION ALL
SELECT OnlineOrInPerson, 'Q4' AS quarter, Q4 AS  targets FROM wk3_targets) as quart
)
select OnlineOrInPerson, targets, total_values, quarters, (targets - total_values) as Variance_to_targets
from code as c
inner join qat as q on c.customer = q.OnlineOrInPerson;
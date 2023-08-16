/*Input the data 
Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction 
Rename the new field with the Bank code 'Bank'. 
Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
Change the date to be the day of the week 
Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways:
1. Total Values of Transactions by each bank
2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
3. Total Values by Bank and Customer Code
Output each data file*/

/* 1. Total Valuesof Transactions by each bank*/
select substring_index(transaction_code, '-', 1) as bank,
case when online_or_in_person = 1 then 'online'
else 'in-person'
end as customer, 
case when length (Transaction_Date) >= 9 then dayname(str_to_date(transaction_date, '%d/%m/%y ')) else '' end as day_of_the_week
from janwk_1;

/*2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)*/
select substring_index(transaction_code, '-', 1) as bank,
case 
when online_or_in_person = 1 then 'online'else 'in-person'end as customer, 
sum(value)as total_values,
case 
when length (Transaction_Date) >= 9 then dayname(str_to_date(transaction_date, '%d/%m/%y ')) else '' end as day_of_the_week
from janwk_1
group by substring_index(transaction_code, '-', 1),
case 
when online_or_in_person = 1 then 'online'else 'in-person'end,
case 
when length (Transaction_Date) >= 9 then dayname(str_to_date(transaction_date, '%d/%m/%y ')) else '' end
;

/*3. Total Values by Bank and Customer Code*/
select substring_index(transaction_code, '-', 1) as bank,
case 
when online_or_in_person = 1 then 'online'else 'in-person'end as customer, 
sum(value)as total_values
from janwk_1
group by substring_index(transaction_code, '-', 1),
case 
when online_or_in_person = 1 then 'online'else 'in-person'end;

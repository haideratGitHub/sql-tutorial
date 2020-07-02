--Union and union all in sql server - Part 17

--Differences between UNION and UNION ALL (Common Interview Question)
--From the output, it is very clear that, UNION removes duplicate rows, where as UNION ALL does not. 
--When use UNION, to remove the duplicate rows, sql server has to to do a distinct sort, which is time consuming. 
--For this reason, UNION ALL is much faster than UNION. 

--Note: If you want to see the cost of DISTINCT SORT, you can turn on the estimated query execution plan using CTRL + L.

--Note: For UNION and UNION ALL to work, the Number, Data types, and the order of the columns in the select statements should be same.

--If you want to sort, the results of UNION or UNION ALL, the ORDER BY caluse should be used on the last SELECT statement as shown below.
Select Id, Name, Email from tblIndiaCustomers
UNION ALL
Select Id, Name, Email from tblUKCustomers
UNION ALL
Select Id, Name, Email from tblUSCustomers
Order by Name

--The following query, raises a syntax error
SELECT Id, Name, Email FROM tblIndiaCustomers
ORDER BY Name
UNION ALL
SELECT Id, Name, Email FROM tblUKCustomers
UNION ALL
SELECT Id, Name, Email FROM tblUSCustomers

--Difference between JOIN and UNION
--JOINS and UNIONS are different things. However, this question is being asked very frequently now. 
--UNION combines the result-set of two or more select queries into a single result-set which includes all the rows from all the queries in the union, where as JOINS, retrieve data from two or more tables based on logical relationships between the tables. 
--In short, UNION combines rows from 2 or more tables, where JOINS combine columns from 2 or more table.

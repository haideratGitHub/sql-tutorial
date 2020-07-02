--Advanced Joins - Part 13
--Self join in sql server - Part 14

--Self Join Query:
--A MANAGER is also an EMPLOYEE. Both the, EMPLOYEE and MANAGER rows, are present in the same table. 
--Here we are joining tblEmployee with itself using different alias names, E for Employee and M for Manager. 
--We are using LEFT JOIN, to get the rows with ManagerId NULL. 
--You can see in the output TODD's record is also retrieved, but the MANAGER is NULL. 
--If you replace LEFT JOIN with INNER JOIN, you will not get TODD's record.

Select E.Name as Employee, M.Name as Manager
from tblEmployee E
Left Join tblEmployee M
On E.ManagerId = M.EmployeeId


--In short, joining a table with itself is called as SELF JOIN. SELF JOIN is not a different type of JOIN. 
--It can be classified under any type of JOIN - INNER, OUTER or CROSS Joins. The above query is, LEFT OUTER SELF Join.

--Inner Self Join tblEmployee table:
Select E.Name as Employee, M.Name as Manager
from tblEmployee E
Inner Join tblEmployee M
On E.ManagerId = M.EmployeeId

--Cross Self Join tblEmployee table:
Select E.Name as Employee, M.Name as Manager
from tblEmployee
Cross Join tblEmployee


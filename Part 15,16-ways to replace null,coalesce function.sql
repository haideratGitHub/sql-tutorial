--Different ways to replace NULL in sql server - Part 15

--Replacing NULL value using ISNULL() function: We are passing 2 parameters to IsNULL() function. 
--If M.Name returns NULL, then 'No Manager' string is used as the replacement value.

 

SELECT E.Name as Employee, ISNULL(M.Name,'No Manager') as Manager
FROM tblEmployee E
LEFT JOIN tblEmployee M
ON E.ManagerID = M.EmployeeID

--Replacing NULL value using CASE Statement:
SELECT E.Name as Employee, CASE WHEN M.Name IS NULL THEN 'No Manager' 
   ELSE M.Name END as Manager
FROM  tblEmployee E
LEFT JOIN tblEmployee M
ON   E.ManagerID = M.EmployeeID

--Replacing NULL value using COALESCE() function: COALESCE() function, returns the first NON NULL value.
SELECT E.Name as Employee, COALESCE(M.Name, 'No Manager') as Manager
FROM tblEmployee E
LEFT JOIN tblEmployee M
ON E.ManagerID = M.EmployeeID

--Coalesce() function in sql server - Part 16
--According to the MSDN Books online COALESCE() returns the first Non NULL value.

--We are passing FirstName, MiddleName and LastName columns as parameters to the COALESCE() function. 
--The COALESCE() function returns the first non null value from the 3 columns.
SELECT Id, COALESCE(FirstName, MiddleName, LastName) AS Name
FROM tblEmployee



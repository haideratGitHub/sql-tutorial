--Part 10
--To Select distinct rows use DISTINCT keyword
SELECT DISTINCT Column_List
FROM Table_Name

--Example: 
Select distinct city from tblPerson

--Filtering rows with WHERE clause
SELECT Column_List
FROM Table_Name
WHERE Filter_Condition

--Example: 
Select Name, Email from tblPerson where City = 'London'

--Note: Text values, should be present in single quotes, but not required for numeric values.

--Group By - Part 11
--In SQL Server we have got lot of aggregate functions. Examples
--1. Count()
--2. Sum()
--3. avg()
--4. Min()
--5. Max()

--Group by clause is used to group a selected set of rows into a set of summary rows by the values of one or more columns or expressions. 
--It is always used in conjunction with one or more aggregate functions.

--It is also possible to combine WHERE and HAVING
Select City, SUM(Salary) as TotalSalary
from tblEmployee
Where Gender = 'Male'
group by City
Having City = 'London'

--Difference between WHERE and HAVING clause:
--1. WHERE clause can be used with - Select, Insert, and Update statements, where as HAVING clause can only be used with the Select statement.
--2. WHERE filters rows before aggregation (GROUPING), where as, HAVING filters groups, after the aggregations are performed.

--Part 12 - Join
--In SQL server, there are different types of JOINS.
--1. CROSS JOIN
--2. INNER JOIN 
--3. OUTER JOIN 

--Outer Joins are again divided into 3 types
--1. Left Join or Left Outer Join
--2. Right Join or Right Outer Join
--3. Full Join or Full Outer Join

--General Formula for Joins
--SELECT      ColumnList
--FROM           LeftTableName
--JOIN_TYPE  RightTableName
--ON                 JoinCondition

--CROSS JOIN
--CROSS JOIN, produces the cartesian product of the 2 tables involved in the join. 
--For example, in the Employees table we have 10 rows and in the Departments table we have 4 rows. 
--So, a cross join between these 2 tables produces 40 rows. Cross Join shouldn't have ON clause. 

--CROSS JOIN Query:
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
CROSS JOIN tblDepartment

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
INNER JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--OR

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--Note: JOIN or INNER JOIN means the same. 
--It's always better to use INNER JOIN, as this explicitly specifies your intention.
 
 SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
LEFT OUTER JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--OR

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
LEFT JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--Note: You can use, LEFT JOIN or LEFT OUTER JOIN. OUTER keyowrd is optional
--LEFT JOIN, returns all the matching rows + non matching rows from the left table. In reality, INNER JOIN and LEFT JOIN are extensively used.

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
RIGHT OUTER JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--OR

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
RIGHT JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--Note: You can use, RIGHT JOIN or RIGHT OUTER JOIN. OUTER keyowrd is optional
--RIGHT JOIN, returns all the matching rows + non matching rows from the right table.

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
FULL OUTER JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--OR

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployee
FULL JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.Id

--Note: You can use, FULLJOIN or FULL OUTER JOIN. OUTER keyowrd is optional
--FULL JOIN, returns all rows from both the left and right tables, including the non matching rows.
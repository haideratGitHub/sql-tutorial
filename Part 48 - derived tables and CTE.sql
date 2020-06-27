--Derived tables and common table expressions (CTE's). 
--We will also explore the differences between Views, Table Variable, Local and Global Temp Tables, Derived tables and common table expressions.

--Let's create the required Employee and Department tables, that we will be using for this demo.

--SQL Script to create tblEmployee table:
CREATE TABLE tblEmployee
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

--SQL Script to create tblDepartment table 
CREATE TABLE tblDepartment
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)

Insert data into tblDepartment table
Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')

Insert data into tblEmployee table
Insert into tblEmployee values (1,'John', 'Male', 3)
Insert into tblEmployee values (2,'Mike', 'Male', 2)
Insert into tblEmployee values (3,'Pam', 'Female', 1)
Insert into tblEmployee values (4,'Todd', 'Male', 4)
Insert into tblEmployee values (5,'Sara', 'Female', 1)
Insert into tblEmployee values (6,'Ben', 'Male', 3)

--Now, we want to write a query which would return the following output. The query should return, the Department Name and Total Number of employees, with in the department.
-- The departments with greatar than or equal to 2 employee should only be returned.

--Obviously, there are severl ways to do this. Let's see how to achieve this, with the help of a view
--Script to create the View
Create view vWEmployeeCount
as
Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId
group by DeptName, DepartmentId

--Query using the view:
Select DeptName, TotalEmployees 
from vWEmployeeCount
where  TotalEmployees >= 2

--Note: Views get saved in the database, and can be available to other queries and stored procedures.
-- However, if this view is only used at this one place, it can be easily eliminated using other options, like CTE, Derived Tables, Temp Tables, Table Variable etc.

--Now, let's see, how to achieve the same using, temporary tables. We are using local temporary tables here.
Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
into #TempEmployeeCount
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId
group by DeptName, DepartmentId

Select DeptName, TotalEmployees
From #TempEmployeeCount
where TotalEmployees >= 2

Drop Table #TempEmployeeCount

--Note: Temporary tables are stored in TempDB.
-- Local temporary tables are visible only in the current session, and can be shared between nested stored procedure calls. 
-- Global temporary tables are visible to other sessions and are destroyed, when the last connection referencing the table is closed.

--Using Table Variable:
Declare @tblEmployeeCount table
(DeptName nvarchar(20),DepartmentId int, TotalEmployees int)

Insert @tblEmployeeCount
Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId
group by DeptName, DepartmentId

Select DeptName, TotalEmployees
From @tblEmployeeCount
where  TotalEmployees >= 2

--Note: Just like TempTables, a table variable is also created in TempDB. 
--The scope of a table variable is the batch, stored procedure, or statement block in which it is declared. 
--They can be passed as parameters between procedures.

--Using Derived Tables
Select DeptName, TotalEmployees
from 
 (
  Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
  from tblEmployee
  join tblDepartment
  on tblEmployee.DepartmentId = tblDepartment.DeptId
  group by DeptName, DepartmentId
 ) 
as EmployeeCount
where TotalEmployees >= 2

--Note: Derived tables are available only in the context of the current query.

--Using CTE
With EmployeeCount(DeptName, DepartmentId, TotalEmployees)
as
(
 Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
 from tblEmployee
 join tblDepartment
 on tblEmployee.DepartmentId = tblDepartment.DeptId
 group by DeptName, DepartmentId
)

Select DeptName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

--Note: A CTE can be thought of as a temporary result set that is defined within the execution scope of a single SELECT, INSERT, UPDATE, DELETE, or CREATE VIEW statement. 
--A CTE is similar to a derived table in that it is not stored as an object and lasts only for the duration of the query.


--1. A CTE is based on a single base table, then the UPDATE suceeds and works as expected.
--2. A CTE is based on more than one base table, and if the UPDATE affects multiple base tables, the update is not allowed and the statement terminates with an error.
--3. A CTE is based on more than one base table, and if the UPDATE affects only one base table, the UPDATE succeeds(but not as expected always)

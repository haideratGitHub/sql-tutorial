
--Grouping Sets in SQL Server - Part 101

--SQL Script to create and populate Employees table
Create Table Employees
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int,
    Country nvarchar(10)
)
Go

Insert Into Employees Values (1, 'Mark', 'Male', 5000, 'USA')
Insert Into Employees Values (2, 'John', 'Male', 4500, 'India')

 
Insert Into Employees Values (3, 'Pam', 'Female', 5500, 'USA')
Insert Into Employees Values (4, 'Sara', 'Female', 4000, 'India')
Insert Into Employees Values (5, 'Todd', 'Male', 3500, 'India')
Insert Into Employees Values (6, 'Mary', 'Female', 5000, 'UK')
Insert Into Employees Values (7, 'Ben', 'Male', 6500, 'UK')
Insert Into Employees Values (8, 'Elizabeth', 'Female', 7000, 'USA')
Insert Into Employees Values (9, 'Tom', 'Male', 5500, 'UK')
Insert Into Employees Values (10, 'Ron', 'Male', 5000, 'USA')
Go

--We can very easily achieve this using a Group By query as shown below
Select Country, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Country, Gender

--Within the same result set we also want Sum of Salary just by Country. 
--The Result should be as shown below. Notice that Gender column within the resultset is NULL as we are grouping only by Country column
--group by union all sql server

--To achieve the above result we could combine 2 Group By queries using UNION ALL as shown below.

Select Country, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Country, Gender

UNION ALL

Select Country, NULL, Sum(Salary) as TotalSalary
From Employees 
Group By Country

--Within the same result set we also want Sum of Salary just by Gender. 
--Notice that the Country column within the resultset is NULL as we are grouping only by Gender column.

--We can achieve this by combining 3 Group By queries using UNION ALL as shown below

Select Country, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Country, Gender

UNION ALL

Select Country, NULL, Sum(Salary) as TotalSalary
From Employees 
Group By Country

UNION ALL

Select NULL, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Gender

--Finally we also want the grand total of Salary. 
--In this case we are not grouping on any particular column. 
--So both Country and Gender columns will be NULL in the resultset. 

--To achieve this we will have to combine the fourth query using UNION ALL as shown below. 

Select Country, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Country, Gender

UNION ALL

Select Country, NULL, Sum(Salary) as TotalSalary
From Employees 
Group By Country

UNION ALL

Select NULL, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Gender

UNION ALL

Select NULL, NULL, Sum(Salary) as TotalSalary
From Employees 

--There are 2 problems with the above approach.
--1. The query is huge as we have combined different Group By queries using UNION ALL operator. This can grow even more if we start to add more groups
--2. The Employees table has to be accessed 4 times, once for every query.

--If we use Grouping Sets feature introduced in SQL Server 2008, the amount of T-SQL code that you have to write will be greatly reduced. 
--The following Grouping Sets query produce the same result as the above UNION ALL query.

Select Country, Gender, Sum(Salary) TotalSalary
From Employees
Group BY
      GROUPING SETS
      (
            (Country, Gender), -- Sum of Salary by Country and Gender
            (Country),               -- Sum of Salary by Country
            (Gender) ,               -- Sum of Salary by Gender
            ()                             -- Grand Total
      )

--The order of the rows in the result set is not the same as in the case of UNION ALL query. 
--To control the order use order by as shown below.

Select Country, Gender, Sum(Salary) TotalSalary
From Employees
Group BY
      GROUPING SETS
      (
            (Country, Gender), -- Sum of Salary by Country and Gender
            (Country),               -- Sum of Salary by Country
            (Gender) ,               -- Sum of Salary by Gender
            ()                             -- Grand Total
      )
Order By Grouping(Country), Grouping(Gender), Gender


--Stored procedures - Part 18

--A stored procedure is group of T-SQL (Transact SQL) statements. If you have a situation, 
--where you write the same query over and over again, 
--you can save that specific query as a stored procedure and call it just by it's name.

--Creating a simple stored procedure without any parameters: 
--This stored procedure, retrieves Name and Gender of all the employees. 
--To create a stored procedure we use, CREATE PROCEDURE or CREATE PROC statement.

Create Procedure spGetEmployees
as
Begin
  Select Name, Gender from tblEmployee
End

--Note: When naming user defined stored procedures, Microsoft recommends not to use "sp_" as a prefix. 
--All system stored procedures, are prefixed with "sp_". 
--This avoids any ambiguity between user defined and system stored procedures and any conflicts, with some future system procedure.

--To execute the stored procedure, you can just type the procedure name and press F5, or use EXEC or EXECUTE keywords followed by the procedure name as shown below.
--1. spGetEmployees
--2. EXEC spGetEmployees
--3. Execute spGetEmployees

--Note: You can also right click on the procedure name, in object explorer in SQL Server Management Studio and select EXECUTE STORED PROCEDURE.

--Creating a stored procedure with input parameters: This SP, accepts GENDER and DEPARTMENTID parameters. 
--Parameters and variables have an @ prefix in their name.

--To view the text, of the stored procedure
--1. Use system stored procedure sp_helptext 'SPName'
--OR
--2. Right Click the SP in Object explorer -> Scrip Procedure as -> Create To -> New Query Editor Window

--To encrypt the text of the SP, use WITH ENCRYPTION option. 
--Once, encrypted, you cannot view the text of the procedure, using sp_helptext system stored procedure. 
--There are ways to obtain the original text, which we will talk about in a later session.

Alter Procedure spGetEmployeesByGenderAndDepartment 
@Gender nvarchar(50),
@DepartmentId int
WITH ENCRYPTION
as
Begin
  Select Name, Gender from tblEmployee Where Gender = @Gender and DepartmentId = @DepartmentId
End

--To delete the SP, use DROP PROC 'SPName' or DROP PROCEDURE 'SPName'

--Stored procedures with output parameters - Part 19

--To create an SP with output parameter, we use the keywords OUT or OUTPUT. 
--@EmployeeCount is an OUTPUT parameter. 
--Notice, it is specified with OUTPUT keyword. 

Create Procedure spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int Output
as
Begin
 Select @EmployeeCount = COUNT(Id) 
 from tblEmployee 
 where Gender = @Gender
End

--To execute this stored procedure with OUTPUT parameter

--1. First initialise a variable of the same datatype as that of the output parameter. 
--We have declared @EmployeeTotal integer variable. 

--2. Then pass the @EmployeeTotal variable to the SP. You have to specify the OUTPUT keyword.
-- If you don't specify the OUTPUT keyword, the variable will be NULL. 

--3. Execute

Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender 'Female', @EmployeeTotal output
Print @EmployeeTotal

--If you don't specify the OUTPUT keyword, when executing the stored procedure, the @EmployeeTotal variable will be NULL. 
--Here, we have not specified OUTPUT keyword. When you execute, you will see '@EmployeeTotal is null' printed.

Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender 'Female', @EmployeeTotal
if(@EmployeeTotal is null)
 Print '@EmployeeTotal is null'
else
 Print '@EmployeeTotal is not null'

--You can pass parameters in any order, when you use the parameter names. 
--Here, we are first passing the OUTPUT parameter and then the input @Gender parameter.

Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender @EmployeeCount = @EmployeeTotal OUT, @Gender = 'Male'
Print @EmployeeTotal

--The following system stored procedures, are extremely useful when working procedures.

--sp_help SP_Name : View the information about the stored procedure, like parameter names, their datatypes etc. 
--sp_help can be used with any database object, like tables, views, SP's, triggers etc. Alternatively, you can also press ALT+F1, when the name of the object is highlighted.

--sp_helptext SP_Name : View the Text of the stored procedure

--sp_depends SP_Name : View the dependencies of the stored procedure. 
--This system SP is very useful, especially if you want to check, if there are any stored procedures that are referencing a table that you are abput to drop. 
--sp_depends can also be used with other database objects like table etc.

--Stored procedure output parameters or return values - Part 20 

--What are stored procedure status variables?
--Whenever, you execute a stored procedure, it returns an integer status variable. 
--Usually, zero indicates success, and non-zero indicates failure. To see this yourself, execute any stored procedure from the object explorer, in sql server management studio. 
--1. Right Click and select 'Execute Stored Procedure
--2. If the procedure, expects parameters, provide the values and click OK.
--3. Along with the result that you expect, the stored procedure, also returns a Return Value = 0

--The following procedure returns total number of employees in the Employees table, using output parameter - @TotalCount.
Create Procedure spGetTotalCountOfEmployees1
@TotalCount int output
as
Begin
 Select @TotalCount = COUNT(ID) from tblEmployee
End

--Executing spGetTotalCountOfEmployees1 returns 3.
Declare @TotalEmployees int
Execute spGetTotalCountOfEmployees @TotalEmployees Output
Select @TotalEmployees

--Re-written stored procedure using return variables
Create Procedure spGetTotalCountOfEmployees2
as
Begin
 return (Select COUNT(ID) from Employees)
End

--Executing spGetTotalCountOfEmployees2 returns 3.
Declare @TotalEmployees int
Execute @TotalEmployees = spGetTotalCountOfEmployees2
Select @TotalEmployees

--So, we are able to achieve what we want, using output parameters as well as return values. Now, 
--let's look at example, where return status variables cannot be used, but Output parameters can be used.

--In this SP, we are retrieving the Name of the employee, based on their Id, using the output parameter @Name.
Create Procedure spGetNameById1
@Id int,
@Name nvarchar(20) Output
as
Begin
 Select @Name = Name from tblEmployee Where Id = @Id
End

--Executing spGetNameById1, prints the name of the employee
Declare @EmployeeName nvarchar(20)
Execute spGetNameById1 3, @EmployeeName out
Print 'Name of the Employee = ' + @EmployeeName

--Now let's try to achieve the same thing, using return status variables.
Create Procedure spGetNameById2
@Id int
as
Begin
 Return (Select Name from tblEmployee Where Id = @Id)
End

--Executing spGetNameById2 returns an error stating 'Conversion failed when converting the nvarchar value 'Sam' to data type int.'. 
--The return status variable is an integer, and hence, when we select Name of an employee and try to return that we get a converion error. 

Declare @EmployeeName nvarchar(20)
Execute @EmployeeName = spGetNameById2 1
Print 'Name of the Employee = ' + @EmployeeName

--So, using return values, we can only return integers, and that too, only one integer. 
--It is not possible, to return more than one value using return values, where as output parameters, can return any datatype and an sp can have more than one output parameters. 
--I always prefer, using output parameters, over RETURN values.

--In general, RETURN values are used to indicate success or failure of stored procedure, especially when we are dealing with nested stored procedures.
--Return a value of 0, indicates success, and any nonzero value indicates failure.


--Advantages of using stored procedures - Part 21
--The following advantages of using Stored Procedures over adhoc queries (inline SQL)

--1. Execution plan retention and reusability - 

--2. Reduces network traffic - 

--3. Code reusability and better maintainability - 

--4. Better Security - 

--5. Avoids SQL Injection attack - 
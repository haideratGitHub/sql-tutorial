--Scalar User Defined Functions in sql server - Part 30

--In SQL Server there are 3 types of User Defined functions
--1. Scalar functions
--2. Inline table-valued functions
--3. Multistatement table-valued functions

--Scalar functions may or may not have parameters, but always return a single (scalar) value. 
--The returned value can be of any data type, except text, ntext, image, cursor, and timestamp.

--To create a function, we use the following syntax:
--CREATE FUNCTION Function_Name(@Parameter1 DataType, @Parameter2 DataType,..@Parametern Datatype)
--RETURNS Return_Datatype
--AS
--BEGIN
--    Function Body
--    Return Return_Datatype
--END

--Let us now create a function which calculates and returns the age of a person. 
--To compute the age we require, date of birth. So, let's pass date of birth as a parameter. 
--So, AGE() function returns an integer and accepts date parameter.
CREATE FUNCTION Age(@DOB Date)  
RETURNS INT  
AS  
BEGIN  
 DECLARE @Age INT  
 SET @Age = DATEDIFF(YEAR, @DOB, GETDATE()) - CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END  
 RETURN @Age  
END

--When calling a scalar user-defined function, you must supply a two-part name, OwnerName.FunctionName. dbo stands for database owner.
--Select dbo.Age( dbo.Age('10/08/1982')

--You can also invoke it using the complete 3 part name, DatabaseName.OwnerName.FunctionName.
--Select SampleDB.dbo.Age('10/08/1982')

--A stored procedure also can accept DateOfBirth and return Age, 
--but you cannot use stored procedures in a select or where clause. 
--This is just one difference between a function and a stored procedure.

--Inline table valued functions - Part 31

--From Part 30, We learnt that, a scalar function, returns a single value. 
--on the other hand, an Inline Table Valued function, return a table. 

--Syntax for creating an inline table valued function
--CREATE FUNCTION Function_Name(@Param1 DataType, @Param2 DataType..., @ParamN DataType)
--RETURNS TABLE
--AS
--RETURN (Select_Statement)

--Create a function that returns EMPLOYEES by GENDER.
CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
RETURNS TABLE
AS
RETURN (Select Id, Name, DateOfBirth, Gender, DepartmentId
      from tblEmployees
      where Gender = @Gender)

--If you look at the way we implemented this function, it is very similar to SCALAR function, with the following differences
--1. We specify TABLE as the return type, instead of any scalar data type
--2. The function body is not enclosed between BEGIN and END block. Inline table valued function body, cannot have BEGIN and END block.
--3. The structure of the table that gets returned, is determined by the SELECT statement with in the function.

--Calling the user defined function
Select * from fn_EmployeesByGender('Male')

--Where can we use Inline Table Valued functions
--1. Inline Table Valued functions can be used to achieve the functionality of parameterized views. 
--2. The table returned by the table valued function, can also be used in joins with other tables.



--Multi-Statement Table Valued Functions in SQL Server - Part 32

--Inline Table Valued function(ILTVF):
Create Function fn_ILTVF_GetEmployees()
Returns Table
as
Return (Select Id, Name, Cast(DateOfBirth as Date) as DOB
        From tblEmployees)

--Calling the Inline Table Valued Function:
Select * from fn_ILTVF_GetEmployees()

--Multi-statement Table Valued function(MSTVF):
Create Function fn_MSTVF_GetEmployees()
Returns @Table Table (Id int, Name nvarchar(20), DOB Date)
as
Begin
 Insert into @Table
 Select Id, Name, Cast(DateOfBirth as Date)
 From tblEmployees
 
 Return
End

--Calling the Multi-statement Table Valued Function:
Select * from fn_MSTVF_GetEmployees()


--Now let's understand the differences between Inline Table Valued functions and Multi-statement Table Valued functions
--1. In an Inline Table Valued function, the RETURNS clause cannot contain the structure of the table, the function returns. 
--Where as, with the multi-statement table valued function, we specify the structure of the table that gets returned

--2. Inline Table Valued function cannot have BEGIN and END block, where as the multi-statement function can have.

--3. Inline Table valued functions are better for performance, than multi-statement table valued functions. 
--If the given task, can be achieved using an inline table valued function, always prefer to use them, over multi-statement table valued functions.

--4. It's possible to update the underlying table, using an inline table valued function, but not possible using multi-statement table valued function.

--Updating the underlying table using inline table valued function: 
--This query will change Sam to Sam1, in the underlying table tblEmployees. 
--When you try do the same thing with the multi-statement table valued function, you will get an error stating 'Object 'fn_MSTVF_GetEmployees' cannot be modified.'
--Update fn_ILTVF_GetEmployees() set Name='Sam1' Where Id = 1

--Reason for improved performance of an inline table valued function:
--Internally, SQL Server treats an inline table valued function much like it would a view and treats a multi-statement table valued function similar to how it would a stored procedure.
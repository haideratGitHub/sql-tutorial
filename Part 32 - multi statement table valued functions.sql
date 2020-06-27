--Inline Table Valued function(ILTVF):
Create Function fn_ILTVF_GetEmployees()
Returns Table
as
Return (Select Id, Name, Cast(DateOfBirth as Date) as DOB
        From tblEmployees)


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

--Calling the Inline Table Valued Function:
Select * from fn_ILTVF_GetEmployees()

--Calling the Multi-statement Table Valued Function:
Select * from fn_MSTVF_GetEmployees()

--Now let's understand the differences between Inline Table Valued functions and Multi-statement Table Valued functions
--1. In an Inline Table Valued function, the RETURNS clause cannot contain the structure of the table, the function returns.
-- Where as, with the multi-statement table valued function, we specify the structure of the table that gets returned
--2. Inline Table Valued function cannot have BEGIN and END block, where as the multi-statement function can have.
--3. Inline Table valued functions are better for performance, than multi-statement table valued functions.
-- If the given task, can be achieved using an inline table valued function, always prefer to use them, over multi-statement table valued functions.
--4. It's possible to update the underlying table, using an inline table valued function, but not possible using multi-statement table valued function.
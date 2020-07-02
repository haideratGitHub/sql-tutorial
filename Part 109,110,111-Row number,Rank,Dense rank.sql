--Row_Number function in SQL Server - Part 109

--Row_Number function
--Introduced in SQL Server 2005
--Returns the sequential number of a row starting at 1
--ORDER BY clause is required
--PARTITION BY clause is optional
--When the data is partitioned, row number is reset to 1 when the partition changes
--Syntax : ROW_NUMBER() OVER (ORDER BY Col1, Col2)

--Row_Number function without PARTITION BY : 
--In this example, data is not partitioned, so ROW_NUMBER will provide a consecutive numbering for all the rows in the table based on the order of rows imposed by the ORDER BY clause.

SELECT Name, Gender, Salary,
        ROW_NUMBER() OVER (ORDER BY Gender) AS RowNumber
FROM Employees

--Please note : If ORDER BY clause is not specified you will get the following error
--The function 'ROW_NUMBER' must have an OVER clause with ORDER BY

--Row_Number function with PARTITION BY : In this example, data is partitioned by Gender, so ROW_NUMBER will provide a consecutive numbering only for the rows with in a parttion. 
--When the partition changes the row number is reset to 1.

SELECT Name, Gender, Salary,
        ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Gender) AS RowNumber
FROM Employees




--Rank and Dense_Rank in SQL Server - Part 110

--Rank and Dense_Rank functions
--Introduced in SQL Server 2005
--Returns a rank starting at 1 based on the ordering of rows imposed by the ORDER BY clause
--ORDER BY clause is required
--PARTITION BY clause is optional
--When the data is partitioned, rank is reset to 1 when the partition changes
--Difference between Rank and Dense_Rank functions
--Rank function skips ranking(s) if there is a tie where as Dense_Rank will not.

--Difference between Rank and Dense_Rank functions
--Rank function skips ranking(s) if there is a tie where as Dense_Rank will not.

--For example : If you have 2 rows at rank 1 and you have 5 rows in total.
--RANK() returns - 1, 1, 3, 4, 5
--DENSE_RANK returns - 1, 1, 2, 3, 4

--Syntax : 
--RANK() OVER (ORDER BY Col1, Col2, ...)
--DENSE_RANK() OVER (ORDER BY Col1, Col2, ...)

--SQl Script to create Employees table
Create Table Employees
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int
)
Go

Insert Into Employees Values (1, 'Mark', 'Male', 8000)
Insert Into Employees Values (2, 'John', 'Male', 8000)
Insert Into Employees Values (3, 'Pam', 'Female', 5000)
Insert Into Employees Values (4, 'Sara', 'Female', 4000)
Insert Into Employees Values (5, 'Todd', 'Male', 3500)
Insert Into Employees Values (6, 'Mary', 'Female', 6000)
Insert Into Employees Values (7, 'Ben', 'Male', 6500)
Insert Into Employees Values (8, 'Jodi', 'Female', 4500)
Insert Into Employees Values (9, 'Tom', 'Male', 7000)
Insert Into Employees Values (10, 'Ron', 'Male', 6800)
Go

--RANK() and DENSE_RANK() functions without PARTITION BY clause : 
--In this example, data is not partitioned, so RANK() function provides a consecutive numbering except when there is a tie. 
--Rank 2 is skipped as there are 2 rows at rank 1. The third row gets rank 3.

--DENSE_RANK() on the other hand will not skip ranks if there is a tie. The first 2 rows get rank 1. Third row gets rank 2.

SELECT Name, Salary, Gender,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees

--RANK() and DENSE_RANK() functions with PARTITION BY clause : 
--Notice when the partition changes from Female to Male Rank is reset to 1

SELECT Name, Salary, Gender,
RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC)
AS DenseRank
FROM Employees


--Use case for RANK and DENSE_RANK functions : Both these functions can be used to find Nth highest salary. 
--However, which function to use depends on what you want to do when there is a tie. Let me explain with an example.

--If there are 2 employees with the FIRST highest salary, there are 2 different business cases
--If your business case is, not to produce any result for the SECOND highest salary, then use RANK function
--If your business case is to return the next Salary after the tied rows as the SECOND highest Salary, then use DENSE_RANK function
--Since we have 2 Employees with the FIRST highest salary. Rank() function will not return any rows for the SECOND highest Salary.

WITH Result AS
(
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

--Though we have 2 Employees with the FIRST highest salary. 
--Dense_Rank() function returns, the next Salary after the tied rows as the SECOND highest Salary

WITH Result AS
(
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

--You can also use RANK and DENSE_RANK functions to find the Nth highest Salary among Male or Female employee groups. 
--The following query finds the 3rd highest salary amount paid among the Female employees group

WITH Result AS
(
    SELECT Salary, Gender,
           DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC)
           AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 3
AND Gender = 'Female'




--Difference between rank dense_rank and row_number in SQL - Part 111

--Similarities between RANK, DENSE_RANK and ROW_NUMBER functions
--Returns an increasing integer value starting at 1 based on the ordering of rows imposed by the ORDER BY clause (if there are no ties)
--ORDER BY clause is required
--PARTITION BY clause is optional
--When the data is partitioned, the integer value is reset to 1 when the partition changes


--Difference between RANK, DENSE_RANK and ROW_NUMBER functions
--ROW_NUMBER : Returns an increasing unique number for each row starting at 1, even if there are duplicates.
--RANK : Returns an increasing unique number for each row starting at 1. 
--When there are duplicates, same rank is assigned to all the duplicate rows, but the next row after the duplicate rows will have the rank it would have been assigned if there had been no duplicates. 
--So RANK function skips rankings if there are duplicates. 
--DENSE_RANK : Returns an increasing unique number for each row starting at 1. When there are duplicates, same rank is assigned to all the duplicate rows but the DENSE_RANK function will not skip any ranks. 
--This means the next row after the duplicate rows will have the next rank in the sequence.
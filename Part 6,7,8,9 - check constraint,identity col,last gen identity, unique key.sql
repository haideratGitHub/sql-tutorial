--Part 6
--CHECK constraint is used to limit the range of the values, that can be entered for a column.

--The following check constraint, limits the age between ZERO and 150.
--ALTER TABLE tblPerson
--ADD CONSTRAINT CK_tblPerson_Age CHECK (Age > 0 AND Age < 150)


--The general formula for adding check constraint in SQL Server:
--ALTER TABLE { TABLE_NAME }
--ADD CONSTRAINT { CONSTRAINT_NAME } CHECK ( BOOLEAN_EXPRESSION )


--Part 7
Create Table tblPerson
(
PersonId int Identity(1,1) Primary Key,
Name nvarchar(20)
)

--In the following 2 insert statements, we only supply values for Name column and not for PersonId column. 
Insert into tblPerson values ('Sam')
Insert into tblPerson values ('Sara')

--If you select all the rows from tblPerson table, you will see that, 'Sam' and 'Sara' rows have got 1 and 2 as PersonId.

--Now, if I try to execute the following query, I get an error stating - 
--An explicit value for the identity column in table 'tblPerson' can only be specified when a column list is used and IDENTITY_INSERT is ON. 
Insert into tblPerson values (1,'Todd')

--So if you mark a column as an Identity column, you dont have to explicitly supply a value for that column when you insert a new row. The value is automatically calculated and provided by SQL server. 
--So, to insert a row into tblPerson table, just provide value for Name column.
Insert into tblPerson values ('Todd')

--Delete the row, that you have just inserted and insert another row. You see that the value for PersonId is 2. Now if you insert another row, PersonId is 3. A record with PersonId = 1, does not exist, and I want to fill this gap. To do this, we should be able to explicitly supply the value for identity column. To explicitly supply a value for identity column
--1. First turn on identity insert - SET Identity_Insert tblPerson ON
--2. In the insert query specify the column list
Insert into tblPerson(PersonId, Name) values(2, 'John')

--As long as the Identity_Insert is turned on for a table, you need to explicitly provide the value for that column. 
--If you don't provide the value, you get an error - Explicit value must be specified for identity column in table 'tblPerson1' either when IDENTITY_INSERT is set to ON or when a replication user is inserting into a NOT FOR REPLICATION identity column. 

 
--After, you have the gaps in the identity column filled, and if you wish SQL server to calculate the value, turn off Identity_Insert.
SET Identity_Insert tblPerson OFF

--Part 8
--From the previous session, we understood that identity column values are auto generated. 
--There are several ways in sql server, to retrieve the last identity value that is generated. 
--The most common way is to use SCOPE_IDENTITY() built in function.

--Apart, from using SCOPE_IDENTITY(), you also have @@IDENTITY and IDENT_CURRENT('TableName') function.

--Example queries for getting the last generated identity value
Select SCOPE_IDENTITY()
Select @@IDENTITY
Select IDENT_CURRENT('tblPerson')

--SCOPE_IDENTITY() - returns the last identity value that is created in the same session and in the same scope.
--@@IDENTITY - returns the last identity value that is created in the same session and across any scope.
--IDENT_CURRENT('TableName') - returns the last identity value that is created for a specific table across any session and any scope.


--Part 9
--To create the unique key using a query:
Alter Table Table_Name
Add Constraint Constraint_Name Unique(Column_Name)

--Both primary key and unique key are used to enforce, the uniqueness of a column. So, when do you choose one over the other?
--A table can have, only one primary key. If you want to enforce uniqueness on 2 or more columns, then we use unique key constraint.

--Difference between primary and unique constraint
--1. A table can have only one primary key but may have more than one unique keys
--2. Primary key does not allow nulls whereas unique key allows one null



 

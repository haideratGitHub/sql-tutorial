--Transactions in SQL Server - Part 57

--What is a Transaction?
--A transaction is a group of commands that change the data stored in a database. 
--A transaction, is treated as a single unit. A transaction ensures that, either all of the commands succeed, or none of them. 
--If one of the commands in the transaction fails, all of the commands fail, and any data that was modified in the database is rolled back. 
--In this way, transactions maintain the integrity of data in a database.

--Transaction processing follows these steps:
--1. Begin a transaction.
--2. Process database commands.
--3. Check for errors. 
--   If errors occurred, 
--       rollback the transaction, 
--   else, 
--       commit the transaction

--Let's understand transaction processing with an example. 
--For this purpose, let's Create and populate, tblMailingAddress and tblPhysicalAddress tables
Create Table tblMailingAddress
(
   AddressId int NOT NULL primary key,
   EmployeeNumber int,
   HouseNumber nvarchar(50),
   StreetAddress nvarchar(50),
   City nvarchar(10),
   PostalCode nvarchar(50)
)

Insert into tblMailingAddress values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

Create Table tblPhysicalAddress
(
 AddressId int NOT NULL primary key,
 EmployeeNumber int,
 HouseNumber nvarchar(50),
 StreetAddress nvarchar(50),
 City nvarchar(10),
 PostalCode nvarchar(50)
)

Insert into tblPhysicalAddress values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

--An employee with EmployeeNumber 101, has the same address as his physical and mailing address. 
--His city name is mis-spelled as Londoon instead of London. 
--The following stored procedure 'spUpdateAddress', updates the physical and mailing addresses. 
--Both the UPDATE statements are wrapped between BEGIN TRANSACTION and COMMIT TRANSACTION block, which in turn is wrapped between BEGIN TRY and END TRY block. 


--So, if both the UPDATE statements succeed, without any errors, then the transaction is committed. 
--If there are errors, then the control is immediately transferred to the catch block. 
--The ROLLBACK TRANSACTION statement, in the CATCH block, rolls back the transaction, and any data that was written to the database by the commands is backed out.

Create Procedure spUpdateAddress
as
Begin
 Begin Try
  Begin Transaction
   Update tblMailingAddress set City = 'LONDON' 
   where AddressId = 1 and EmployeeNumber = 101
   
   Update tblPhysicalAddress set City = 'LONDON' 
   where AddressId = 1 and EmployeeNumber = 101
  Commit Transaction
 End Try
 Begin Catch
  Rollback Transaction
 End Catch
End

--Let's now make the second UPDATE statement, fail. CITY column length in tblPhysicalAddress table is 10. 
--The second UPDATE statement fails, because the value for CITY column is more than 10 characters.
Alter Procedure spUpdateAddress
as
Begin
 Begin Try
  Begin Transaction
   Update tblMailingAddress set City = 'LONDON12' 
   where AddressId = 1 and EmployeeNumber = 101
   
   Update tblPhysicalAddress set City = 'LONDON LONDON' 
   where AddressId = 1 and EmployeeNumber = 101
  Commit Transaction
 End Try
 Begin Catch
  Rollback Transaction
 End Catch
End

--Now, if we execute spUpdateAddress, the first UPDATE statements succeeds, but the second UPDATE statement fails. 
--As, soon as the second UPDATE statement fails, the control is immediately transferred to the CATCH block. 
--The CATCH block rolls the transaction back. 
--So, the change made by the first UPDATE statement is undone.



--Transaction Acid Tests - Part 58

--A transaction is a group of database commands that are treated as a single unit. 
--A successful transaction must pass the "ACID" test, that is, it must be
--A - Atomic
--C - Consistent
--I - Isolated
--D - Durable

--Atomic - All statements in the transaction either completed successfully or they were all rolled back. 
--The task that the set of operations represents is either accomplished or not, but in any case not left half-done. 
--For example, in the spUpdateInventory_and_Sell stored procedure, both the UPDATE statements, should succeed. 
--If one UPDATE statement succeeds and the other UPDATE statement fails, the database should undo the change made by the first UPDATE statement, by rolling it back. 
--In short, the transaction should be ATOMIC.

Create Procedure spUpdateInventory_and_Sell
as
Begin
  Begin Try
    Begin Transaction
      Update tblProduct set QtyAvailable = (QtyAvailable - 10)
      where ProductId = 1

      Insert into tblProductSales values(3, 1, 10)
    Commit Transaction
  End Try
  Begin Catch 
    Rollback Transaction
  End Catch 
End

--Consistent - All data touched by the transaction is left in a logically consistent state. 
--For example, if stock available numbers are decremented from tblProductTable, then, there has to be a related entry in tblProductSales table. 
--The inventory can't just disappear.

--Isolated - The transaction must affect data without interfering with other concurrent transactions, or being interfered with by them. 
--This prevents transactions from making changes to data based on uncommitted information, for example changes to a record that are subsequently rolled back. 
--Most databases use locking to maintain transaction isolation.

--Durable - Once a change is made, it is permanent. 
--If a system error or power failure occurs before a set of commands is complete, those commands are undone and the data is restored to its original state once the system begins running again.

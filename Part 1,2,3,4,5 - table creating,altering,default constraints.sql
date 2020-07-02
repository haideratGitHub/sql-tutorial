--Part 2
--To Create the database using a query
Create database DatabaseName


--Whether, you create a database graphically using the designer or, using a query, the following 2 files gets generated.
--.MDF file - Data File (Contains actual data)
--.LDF file - Transaction Log file (Used to recover the database)


--To alter a database, once it's created 
Alter database DatabaseName Modify Name = NewDatabaseName


--Alternatively, you can also use system stored procedure
Execute sp_renameDB 'OldDatabaseName','NewDatabaseName'


--To Delete or Drop a database
Drop Database DatabaseThatYouWantToDrop


--Dropping a database, deletes the LDF and MDF files.

--Part 3
--The following statement creates tblGender table, with ID and Gender columns.
--The following statement creates tblGender table, with ID and Gender columns. ID column, is the primary key column. 
--The primary key is used to uniquely identify each row in a table. Primary key does not allow nulls.
Create Table tblGender
(ID int Not Null Primary Key,
Gender nvarchar(50))

--Part 4
--Altering an existing column to add a default constraint:
--ALTER TABLE { TABLE_NAME }
--ADD CONSTRAINT { CONSTRAINT_NAME }
--DEFAULT { DEFAULT_VALUE } FOR { EXISTING_COLUMN_NAME }


--Adding a new column, with default value, to an existing table:
--ALTER TABLE { TABLE_NAME } 
--ADD { COLUMN_NAME } { DATA_TYPE } { NULL | NOT NULL } 
--CONSTRAINT { CONSTRAINT_NAME } DEFAULT { DEFAULT_VALUE }

--The following command will add a default constraint, DF_tblPerson_GenderId.
--ALTER TABLE tblPerson
--ADD CONSTRAINT DF_tblPerson_GenderId
--DEFAULT 1 FOR GenderId

--Part 5
--1. No Action: This is the default behaviour. 
--No Action specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, an error is raised and the DELETE or UPDATE is rolled back.

 
--2. Cascade: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are also deleted or updated.


--3. Set NULL: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to NULL.  


--4. Set Default: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to default values.
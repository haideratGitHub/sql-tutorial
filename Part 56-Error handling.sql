--Error handling in sql server 2005, and later versions - Part 56

--Syntax:
--BEGIN TRY
--     { Any set of SQL statements }
--END TRY
--BEGIN CATCH
--     [ Optional: Any set of SQL statements ]
--END CATCH
--[Optional: Any other SQL Statements]

--Any set of SQL statements, that can possibly throw an exception are wrapped between BEGIN TRY and END TRY blocks. 
--If there is an exception in the TRY block, the control immediately, jumps to the CATCH block. 
--If there is no exception, CATCH block will be skipped, and the statements, after the CATCH block are executed.

--Errors trapped by a CATCH block are not returned to the calling application. 
--If any part of the error information must be returned to the application, the code in the CATCH block must do so by using RAISERROR() function.

--1. In procedure spSellProduct, Begin Transaction and Commit Transaction statements are wrapped between Begin Try and End Try block. 
--If there are no errors in the code that is enclosed in the TRY block, then COMMIT TRANSACTION gets executed and the changes are made permanent. 
--On the other hand, if there is an error, then the control immediately jumps to the CATCH block. 
--In the CATCH block, we are rolling the transaction back. 
--So, it's much easier to handle errors with Try/Catch construct than with @@Error system function.

--2. Also notice that, in the scope of the CATCH block, there are several system functions, that are used to retrieve more information about the error that occurred. 
--These functions return NULL if they are executed outside the scope of the CATCH block.

--3. TRY/CATCH cannot be used in a user-defined functions.

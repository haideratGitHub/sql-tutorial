--Cast and Convert functions in SQL Server - Part 28

--Syntax of CAST and CONVERT functions from MSDN:
--CAST ( expression AS data_type [ ( length ) ] )
--CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

--From the syntax, it is clear that CONVERT() function has an optional style parameter, where as CAST() function lacks this capability.

--Note: To control the formatting of the Date part, DateTime has to be converted to NVARCHAR using the styles provided. 
--When converting to DATE data type, the CONVERT() function will ignore the style parameter.

--The following are the differences between the 2 functions.
--1. Cast is based on ANSI standard and Convert is specific to SQL Server. 
--So, if portability is a concern and if you want to use the script with other database applications, use Cast(). 
--2. Convert provides more flexibility than Cast. For example, it's possible to control how you want DateTime datatypes to be converted using styles with convert function.
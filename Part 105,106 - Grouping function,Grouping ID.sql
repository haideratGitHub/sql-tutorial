--Grouping function in SQL Server - Part 105

--What is Grouping function 
--Grouping(Column) indicates whether the column in a GROUP BY list is aggregated or not. 
--Grouping returns 1 for aggregated or 0 for not aggregated in the result set. 

--The following query returns 1 for aggregated or 0 for not aggregated in the result set

SELECT   Continent, Country, City, SUM(SaleAmount) AS TotalSales,
         GROUPING(Continent) AS GP_Continent,
         GROUPING(Country) AS GP_Country,
         GROUPING(City) AS GP_City
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)

--What is the use of Grouping function in real world
--When a column is aggregated in the result set, the column will have a NULL value. 
--If you want to replace NULL with All then this GROUPING function is very handy.

SELECT  
    CASE WHEN
         GROUPING(Continent) = 1 THEN 'All' ELSE ISNULL(Continent, 'Unknown')
    END AS Continent,
    CASE WHEN
         GROUPING(Country) = 1 THEN 'All' ELSE ISNULL(Country, 'Unknown')
    END AS Country,
    CASE
         WHEN GROUPING(City) = 1 THEN 'All' ELSE ISNULL(City, 'Unknown')
    END AS City,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)

--Can't I use ISNULL function instead as shown below

SELECT   ISNULL(Continent, 'All') AS Continent,
         ISNULL(Country, 'All') AS Country,
         ISNULL(City, 'All') AS City,
         SUM(SaleAmount) AS TotalSales
FROM Sales

GROUP BY ROLLUP(Continent, Country, City)

--Well, you can, but only if your data does not contain NULL values. Let me explain what I mean.

--At the moment the raw data in our Sales has no NULL values. Let's introduce a NULL value in the City column of the row where Id = 1

Update Sales Set City = NULL where Id = 1

Now execute the following query with ISNULL function

SELECT   ISNULL(Continent, 'All') AS Continent,
         ISNULL(Country, 'All') AS Country,
         ISNULL(City, 'All') AS City,
         SUM(SaleAmount) AS TotalSales
FROM Sales

GROUP BY ROLLUP(Continent, Country, City)




--GROUPING_ID function in SQL Server - Part 106

--GROUPING_ID function computes the level of grouping.

--Difference between GROUPING and GROUPING_ID

--Syntax : GROUPING function is used on single column, where as the column list for GROUPING_ID function must match with GROUP BY column list.

--GROUPING(Col1)
--GROUPING_ID(Col1, Col2, Col3,...)

--GROUPING indicates whether the column in a GROUP BY list is aggregated or not. Grouping returns 1 for aggregated or 0 for not aggregated in the result set. 

--GROUPING_ID() function concatenates all the GOUPING() functions, perform the binary to decimal conversion, and returns the equivalent integer. In short
--GROUPING_ID(A, B, C) =  GROUPING(A) + GROUPING(B) + GROUPING(C)

--Let us understand this with an example. 

SELECT   Continent, Country, City, SUM(SaleAmount) AS TotalSales,
         CAST(GROUPING(Continent) AS NVARCHAR(1)) +
         CAST(GROUPING(Country) AS NVARCHAR(1)) +
         CAST(GROUPING(City) AS NVARCHAR(1)) AS Groupings,
         GROUPING_ID(Continent, Country, City) AS GPID
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)

--Use of GROUPING_ID function : GROUPING_ID function is very handy if you want to sort and filter by level of grouping.

--Sorting by level of grouping : 

SELECT   Continent, Country, City, SUM(SaleAmount) AS TotalSales,
         GROUPING_ID(Continent, Country, City) AS GPID
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)
ORDER BY GPID

--Filter by level of grouping : The following query retrieves only continent level aggregated data
SELECT   Continent, Country, City, SUM(SaleAmount) AS TotalSales,
         GROUPING_ID(Continent, Country, City) AS GPID
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)
HAVING GROUPING_ID(Continent, Country, City) = 3
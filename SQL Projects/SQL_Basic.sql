--Table 1- Employees

CREATE TABLE Employees(
  EmployeeID int, 
  FirstName varchar(50), 
  LastName varchar(50), 
  Age int, 
  Gender varchar(50)
)

      --Table 2: Salaries

CREATE TABLE Salaries(
  EmployeeID int, 
  JobTitle varchar(50), 
  Salary int
)


        ---- INSERT INTO TABLES---
INSERT INTO Employees VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')


INSERT INTO Salaries VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)


      --- SELECT STATEMENT--

SELECT * FROM Employees; 
SELECT * FROM Salaries

/* Selecting with Top, Distinct, Count, As, Max, Min, Avg */

-- Select Top 5 rows
SELECT TOP 5 * FROM Employees

-- Distinct: Select unique values e.g Employee ID
SELECT Distinct(EmployeeID) 
FROM Employees

-- COUNT: Counting rows
SELECT COUNT(EmployeeID) FROM Employees

SELECT COUNT(*) FROM Employees


/* Max, Min & Avg: maximum, minimum, and average values respectively
 Find maximum/Minimum/Average salary */

SELECT MAX(Salary) FROM Salaries
SELECT MIN(Salary) FROM Salaries
SELECT AVG(Salary) FROM Salaries


-----------------------------------------------
/* WHERE Statement: +
   =, <>, >, <, AND, OR, LIKE, NULL, NOT NULL, IN
   (<> = not equal)
   */

-- =
SELECT * FROM Employees
WHERE FirstName = 'Jim'
 
-- <> 
SELECT * FROM Employees
WHERE FirstName <> 'Jim'

-- >=
SELECT * FROM Employees
WHERE Age >= 30

-- IN
SELECT * FROM Employees
WHERE FirstName IN ('Jim', 'Toby', 'Angela')

-- LIKE +  WILDCAT
SELECT * FROM Employees
WHERE FirstName LIKE '%S%'

-------------------------------------------------------

                    GROUP BY, ORDER BY
SELECT 
    Gender, 
    Age,
    COUNT(Gender) AS GenderCount
FROM BY Employees
GROUP BY Gender
ORDER BY GenderCount			
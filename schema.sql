-- 1. Create the Database
CREATE DATABASE IF NOT EXISTS employee_management_system;

-- 2. Select the newly created database
USE employee_management_system;

-- 3. Create Tables
-- Table 1: Job Department (Parent table for Employee and SalaryBonus)
CREATE TABLE JobDepartment (
		Job_ID INT PRIMARY KEY,
        JobDept VARCHAR(50), 
        Name VARCHAR(100),
        Description TEXT,
        SalaryRange VARCHAR(50) 
);
        
-- Table 2: Salary/Bonus (Child of JobDepartment)
CREATE TABLE SalaryBonus (
    Salary_ID INT PRIMARY KEY,
    Job_ID INT,
    Amount DECIMAL(10,2),
    Annual DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (Job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 3: Employee (Child of JobDepartment, Parent of Qualification, Leaves, Payroll)
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Contact_Add VARCHAR(100),
    Emp_Email VARCHAR(100) UNIQUE, -- Important UNIQUE constraint
    Emp_Pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL -- Note the SET NULL action here
        ON UPDATE CASCADE
);

-- Table 4: Qualification (Child of Employee)
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(Emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves (Child of Employee, Parent of Payroll)
CREATE TABLE Leaves (
    Leave_ID INT PRIMARY KEY,
    Emp_ID INT,
    Date DATE,
    Reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll (Child of Employee, JobDepartment, SalaryBonus, and Leaves)
CREATE TABLE Payroll (
    Payroll_ID INT PRIMARY KEY,
    Emp_ID INT,
    Job_ID INT,
    Salary_ID INT,
    Leave_ID INT,
    Date DATE,
    Report TEXT,
    Total_Amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (Job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (Salary_ID) REFERENCES SalaryBonus(Salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (Leave_ID) REFERENCES Leaves(Leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE -- Note the SET NULL action here
);

USE employee_management_system;

SELECT * FROM JobDepartment;

-- Check row counts (ensure all tables imported correctly)
SELECT 'JobDepartment' AS TableName, COUNT(*) FROM JobDepartment
UNION ALL
SELECT 'SalaryBonus', COUNT(*) FROM SalaryBonus
UNION ALL
SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL
SELECT 'Qualification', COUNT(*) FROM Qualification
UNION ALL
SELECT 'Leaves', COUNT(*) FROM Leaves
UNION ALL
SELECT 'Payroll', COUNT(*) FROM Payroll;

-- Spot-check data integrity (ensure foreign keys link up)
SELECT e.FirstName, jd.JobDept
FROM Employee e
JOIN JobDepartment jd ON e.Job_ID = jd.Job_ID
LIMIT 5;
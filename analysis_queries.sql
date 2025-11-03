-- Analysis Questions
-- 1. EMPLOYEE INSIGHTS

USE employee_management_system;

-- Q1. How many unique employees are currently in the system?
SELECT
    '1. Total Unique Employees' AS Question,
    COUNT(Emp_ID) AS Answer
FROM
    Employee;

-- Q2. Which departments have the highest number of employees?
SELECT
    '2. Employees per Department' AS Question,
    jd.JobDept AS Department_Name,
    COUNT(e.Emp_ID) AS Number_of_Employees
FROM
    Employee e
JOIN
    JobDepartment jd ON e.Job_ID = jd.Job_ID
GROUP BY
    jd.JobDept
ORDER BY
    Number_of_Employees DESC;

-- Q3. What is the average salary per department?
SELECT
    '3. Average Salary per Department' AS Question,
    jd.JobDept AS Department_Name,
    AVG(sb.Amount) AS Average_Monthly_Salary
FROM
    Employee e
JOIN
    JobDepartment jd ON e.Job_ID = jd.Job_ID
JOIN
    SalaryBonus sb ON jd.Job_ID = sb.Job_ID
GROUP BY
    jd.JobDept
ORDER BY
    Average_Monthly_Salary DESC;

-- Q4. Who are the top 5 highest-paid employees?
SELECT
    '4. Top 5 Highest-Paid Employees' AS Question,
    e.FirstName,
    e.LastName,
    sb.Amount AS Monthly_Salary
FROM
    Employee e
JOIN
    JobDepartment jd ON e.Job_ID = jd.Job_ID
JOIN
    SalaryBonus sb ON jd.Job_ID = sb.Job_ID
ORDER BY
    Monthly_Salary DESC
LIMIT 5;

-- Q5. What is the total salary expenditure across the company?
SELECT
    '5. Total Monthly Salary Expenditure' AS Question,
    SUM(sb.Amount) AS Total_Monthly_Salary_Expenditure
FROM
    Employee e
JOIN
    JobDepartment jd ON e.Job_ID = jd.Job_ID
JOIN
    SalaryBonus sb ON jd.Job_ID = sb.Job_ID;
    
-- 2. JOB ROLE AND DEPARTMENT ANALYSIS
-- Q1. How many different job roles exist in each department?
SELECT
    '1. Job Roles per Department' AS Question,
    JobDept AS Department,
    COUNT(DISTINCT Name) AS Number_of_Job_Roles
FROM
    JobDepartment
GROUP BY
    JobDept
ORDER BY
    Number_of_Job_Roles DESC;

-- Q2. What is the average salary range per department?
-- Note: Since SalaryRange is VARCHAR, we list all unique ranges found in each department.
SELECT
    '2. Unique Salary Ranges per Department' AS Question,
    JobDept AS Department,
    GROUP_CONCAT(DISTINCT SalaryRange ORDER BY SalaryRange SEPARATOR ' | ') AS Unique_Salary_Ranges
FROM
    JobDepartment
GROUP BY
    JobDept
ORDER BY
    JobDept;

-- Q3. Which job roles offer the highest salary?
SELECT
    '3. Top 5 Highest-Salaried Job Roles' AS Question,
    jd.Name AS Job_Role,
    sb.Amount AS Monthly_Salary
FROM
    SalaryBonus sb
JOIN
    JobDepartment jd ON sb.Job_ID = jd.Job_ID
ORDER BY
    sb.Amount DESC
LIMIT 5;

-- Q4. Which departments have the highest total salary allocation?
-- This sums the standard monthly salary (Amount) defined for each job role within a department.
SELECT
    '4. Department Total Salary Allocation' AS Question,
    jd.JobDept AS Department_Name,
    SUM(sb.Amount) AS Total_Monthly_Salary_Allocation
FROM
    SalaryBonus sb
JOIN
    JobDepartment jd ON sb.Job_ID = jd.Job_ID
GROUP BY
    jd.JobDept
ORDER BY
    Total_Monthly_Salary_Allocation DESC;
    
    
-- 3. Qualification and Skills Analysis: MySQL Script

-- Q1. How many employees have at least one qualification listed?
SELECT
    '1. Employees with at least one Qualification' AS Question,
    COUNT(DISTINCT Emp_ID) AS Employees_With_Qualifications
FROM
    Qualification;

-- Q2. Which positions require the most qualifications?
-- This query identifies which *type* of qualification (Position in the Qualification table) is held by the most employees.
SELECT
    '2. Most Common Qualification Types' AS Question,
    Position AS Qualification_Name,
    COUNT(Emp_ID) AS Number_of_Employees_Holding_This_Qualification
FROM
    Qualification
GROUP BY
    Position
ORDER BY
    Number_of_Employees_Holding_This_Qualification DESC
LIMIT 5;

-- Q3. Which employees have the highest number of qualifications?
SELECT
    '3. Employees with Highest Number of Qualifications' AS Question,
    e.FirstName,
    e.LastName,
    COUNT(q.QualID) AS Total_Qualifications
FROM
    Employee e
JOIN
    Qualification q ON e.Emp_ID = q.Emp_ID
GROUP BY
    e.Emp_ID, e.FirstName, e.LastName
ORDER BY
    Total_Qualifications DESC
LIMIT 5;

-- 4. Leave and Absence Patterns: MySQL Script

-- Q1. Which year had the most employees taking leaves?
SELECT
    '1. Year with Most Employees Taking Leave' AS Question,
    YEAR(Date) AS Leave_Year,
    COUNT(DISTINCT Emp_ID) AS Employees_Taking_Leave
FROM
    Leaves
GROUP BY
    Leave_Year
ORDER BY
    Employees_Taking_Leave DESC
LIMIT 1;

-- Q2. What is the average number of leave days taken by its employees per department?
SELECT
    '2. Average Leave Days per Employee by Dept' AS Question,
    jd.JobDept AS Department_Name,
    -- Calculate the average of the total leaves taken by each employee in that department
    AVG(T1.Total_Leaves_Taken) AS Avg_Leaves_Per_Employee
FROM
    JobDepartment jd
JOIN
    Employee e ON jd.Job_ID = e.Job_ID
JOIN
    (
        -- Subquery: Counts total leaves taken by each employee
        SELECT
            Emp_ID,
            COUNT(Leave_ID) AS Total_Leaves_Taken
        FROM
            Leaves
        GROUP BY
            Emp_ID
    ) AS T1 ON e.Emp_ID = T1.Emp_ID
GROUP BY
    jd.JobDept
ORDER BY
    Avg_Leaves_Per_Employee DESC;

-- Q3. Which employees have taken the most leaves?
SELECT
    '3. Employees with the Most Leaves' AS Question,
    e.FirstName,
    e.LastName,
    COUNT(l.Leave_ID) AS Total_Leaves_Taken
FROM
    Employee e
JOIN
    Leaves l ON e.Emp_ID = l.Emp_ID
GROUP BY
    e.Emp_ID, e.FirstName, e.LastName
ORDER BY
    Total_Leaves_Taken DESC
LIMIT 5;

-- Q4. What is the total number of leave days taken company-wide?
SELECT
    '4. Total Leave Days Company-Wide' AS Question,
    COUNT(Leave_ID) AS Total_Leave_Days_Company_Wide
FROM
    Leaves;

-- Q5. How do leave days correlate with payroll amounts?
-- This query analyzes the relationship by grouping payroll records based on whether a leave was associated (Leave_ID IS NOT NULL) and calculating the average net pay.
SELECT
    '5. Payroll vs. Leave Correlation' AS Question,
    CASE
        WHEN p.Leave_ID IS NULL THEN 'No Leave Taken (Full Pay)'
        ELSE 'At Least One Leave Associated'
    END AS Leave_Status_In_Pay_Period,
    AVG(p.Total_Amount) AS Average_Net_Pay_Amount
FROM
    Payroll p
GROUP BY
    Leave_Status_In_Pay_Period;
    
    
-- 5. Payroll and Compensation Analysis: MySQL Script

-- Q1. What is the total monthly payroll processed?
-- Sums the net payment amounts (Total_Amount) from all records in the Payroll table.
SELECT
    '1. Total Monthly Payroll Processed' AS Question,
    SUM(Total_Amount) AS Total_Monthly_Payroll
FROM
    Payroll;

-- Q2. What is the average bonus given per department?
-- Calculates the average standard bonus (from SalaryBonus) for all job roles within each department.
SELECT
    '2. Average Bonus per Department' AS Question,
    jd.JobDept AS Department_Name,
    AVG(sb.Bonus) AS Average_Bonus
FROM
    JobDepartment jd
JOIN
    SalaryBonus sb ON jd.Job_ID = sb.Job_ID
GROUP BY
    jd.JobDept
ORDER BY
    Average_Bonus DESC;

-- Q3. Which department receives the highest total bonuses?
-- Sums the standard bonus allocation (from SalaryBonus) for all job roles within each department.
SELECT
    '3. Department with Highest Total Bonus Allocation' AS Question,
    jd.JobDept AS Department_Name,
    SUM(sb.Bonus) AS Total_Bonus_Allocation
FROM
    JobDepartment jd
JOIN
    SalaryBonus sb ON jd.Job_ID = sb.Job_ID
GROUP BY
    jd.JobDept
ORDER BY
    Total_Bonus_Allocation DESC
LIMIT 1;

-- Q4. What is the average value of total_amount after considering leave deductions?
-- Calculates the average of the net payment (Total_Amount) ONLY for payroll records where a deduction occurred (indicated by a non-NULL Leave_ID).
SELECT
    '4. Average Net Pay After Leave Deductions' AS Question,
    AVG(Total_Amount) AS Average_Total_Amount_After_Deductions
FROM
    Payroll
WHERE
    Leave_ID IS NOT NULL;




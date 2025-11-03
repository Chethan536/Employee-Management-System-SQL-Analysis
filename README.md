# Employee Management System (EMS) Database Project: Data Analysis & Insights 📈

## Project Summary

This project involved designing, implementing, and analyzing a robust **Employee Management System (EMS)** database using MySQL. The primary goal was to create a reliable relational schema capable of tracking complex HR and payroll data, and then performing comprehensive SQL analysis to deliver actionable business intelligence.

---

## Key Analysis Highlights

This analysis answers 21 core business questions across five domains, providing critical insights into the organization's resource allocation, compensation fairness, and operational efficiency.

| Area | Key Insight Delivered | Primary SQL Technique |
| :--- | :--- | :--- |
| **Workforce Distribution** | Identified **Finance** and **IT** as the largest departments by headcount (9 employees each) and determined they consume the highest salary budget allocation. | `JOIN`s, `COUNT()`, `GROUP BY` |
| **Compensation Benchmarks** | Established that **Legal** and **Engineering** have the highest average monthly salaries, while **Director-level** roles receive the highest individual pay. | `AVG()`, `ORDER BY...DESC`, `LIMIT` |
| **Payroll Validation** | Quantified the average net pay after a deduction ($46,300), **validating the financial impact of the leave policy** on employee take-home pay. | `AVG()`, `WHERE...IS NOT NULL` |
| **Data Gaps Identified** | Highlighted the uniform, low data entries for qualifications and leaves, suggesting a need to audit and improve the data collection process to accurately track skills and specialized leave records. | `COUNT(DISTINCT...)`, `GROUP BY` |

---

## Data Model (ER Diagram)

The system manages six interrelated tables designed to ensure referential integrity using Primary Key (PK) and Foreign Key (FK) constraints.



| Table Name | Description | Key Relationships |
| :--- | :--- | :--- |
| **`JobDepartment`** | Stores job roles and salary range descriptions. (Parent) | PK: `Job_ID` |
| **`Employee`** | Stores personal details and links employees to their job role. | FK: `Job_ID` |
| **`SalaryBonus`** | Stores base pay, annual salary, and bonus linked to job roles. | FK: `Job_ID` |
| **`Leaves`** | Tracks individual employee leave records (dates, reasons). | FK: `Emp_ID` |
| **`Qualification`** | Records employee professional qualifications and certifications. | FK: `Emp_ID` |
| **`Payroll`** | Combines all factors (salary, job, leaves) to calculate net payment. | FKs: `Emp_ID`, `Job_ID`, `Salary_ID`, `Leave_ID` |

---

## Project Execution & Files

### Tools Used
* **Database:** MySQL
* **Environment:** MySQL Workbench

### Repository Contents

| File/Folder | Purpose |
| :--- | :--- |
| **`README.md`** | This executive summary of the project. |
| **`EMS_Final_Report.pdf`** | **The complete analysis document** (Step 4 output), including all visual representations, interpretation, and findings. |
| **`schema.sql`** | The database creation script (`CREATE TABLE` statements). |
| **`analysis_queries.sql`** | The full executable script containing all **21** `SELECT` queries used for analysis. |
| **`data/`** | Contains the initial CSV files used to populate the database. |

---

## Getting Started

To replicate this analysis:

1.  Clone this repository: `git clone https://github.com/Chethan536/Employee-Management-System-SQL-Analysis`
2.  In MySQL Workbench, create the schema using the commands in `schema.sql`.
3.  Import the data from the `data/` folder into the corresponding tables (e.g., using the Table Data Import Wizard).
4.  Execute the queries in `analysis_queries.sql` to verify the findings documented in the final report.

---
Created by: Chethan Vakiti

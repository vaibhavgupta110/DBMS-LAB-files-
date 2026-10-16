# Experiment 5: Employee–Department–Project Database

## Aim
To practice advanced SQL concepts using an employee, department, and project database, including aggregate queries, joins, subqueries, execution plans, views, employee-manager relationships, and recursive common table expressions (CTEs).

## Requirements
- MySQL 8.0 or later
- A database containing the tables `Employee`, `Department`, `Project`, `Employee_Project`, and `Salaries`
- The columns referenced in the SQL script below

> **Important:** Run this script against a test database first. It inserts assignment rows, creates/replaces views, updates employee salaries and manager relationships, and alters the `Employee` table. The script assumes the listed tables and referenced columns already exist. If you run it more than once, the `INSERT` statements or `ALTER TABLE` statements may fail because of duplicate rows or an already-existing column/constraint.

## Topics Covered
1. Inserting employee-project assignments
2. Salary summaries and department-level aggregation
3. `CASE` expressions for salary categories
4. Project reports and joins
5. Correlated subqueries, `EXISTS`, and `NOT EXISTS`
6. `EXPLAIN` execution plans
7. Views, including an aggregate summary view and an updatable employee view
8. Self-referencing foreign keys for employee-manager relationships
9. Recursive CTEs for organizational hierarchy and reporting chains

## SQL Source Code

```sql
/* =========================================================
   EMPLOYEE–DEPARTMENT–PROJECT SQL SCRIPT
   Assumes MySQL 8+ and these tables:
   Employee, Department, Project, Employee_Project, Salaries
   ========================================================= */

/* -------------------------
   INSERT PROJECT ASSIGNMENTS
   ------------------------- */
INSERT INTO Employee_Project (emp_id, project_id, hours_worked) VALUES
    (101, 201, 120),
    (102, 201, 100),
    (103, 202, 150),
    (104, 202, 110),
    (105, 201, 130),
    (106, 202, 90),
    (107, 203, 100),
    (108, 203, 120),
    (109, 203, 80),
    (110, 203, 110),
    (111, 203, 90),
    (112, 203, 130),
    (113, 204, 140),
    (114, 204, 150),
    (115, 204, 120),
    (116, 204, 135),
    (117, 204, 100),
    (118, 204, 145),
    (119, 205, 110),
    (120, 205, 100),
    (121, 206, 120),
    (122, 205, 140),
    (123, 206, 90),
    (124, 206, 130),
    (125, 207, 160),
    (126, 207, 140),
    (127, 208, 150),
    (128, 208, 160),
    (129, 207, 120),
    (130, 208, 135);

/* -------------------------
   SALARY QUERIES
   ------------------------- */

-- Overall salary summary
SELECT
    COUNT(DISTINCT employee_id) AS total_employees,
    SUM(amount) AS total_salary,
    AVG(amount) AS average_salary,
    MAX(amount) AS highest_salary,
    MIN(amount) AS lowest_salary
FROM Salaries;

-- Employee count by department
SELECT
    dept_id,
    COUNT(*) AS employee_count
FROM Employee
GROUP BY dept_id;

-- Average salary by department
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- Departments with average salary above 75,000
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 75000;

-- Salary categories using CASE
SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    CASE
        WHEN e.salary >= 90000 THEN 'High Salary'
        WHEN e.salary >= 70000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee e;

/* -------------------------
   PROJECT REPORTS
   ------------------------- */

-- Complete project-department report
SELECT
    p.project_id,
    p.project_name,
    d.dept_name,
    p.budget
FROM Project p
JOIN Department d
    ON p.dept_id = d.dept_id
ORDER BY p.budget DESC;

-- Employees working on projects
SELECT
    e.emp_name,
    p.project_name,
    ep.hours_worked
FROM Employee_Project ep
JOIN Employee e
    ON ep.emp_id = e.emp_id
JOIN Project p
    ON ep.project_id = p.project_id
ORDER BY ep.hours_worked DESC;

/* -------------------------
   JOIN QUERIES
   ------------------------- */

-- INNER JOIN
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;

-- LEFT JOIN
SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;

-- 3-WAY JOIN
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
JOIN Employee_Project ep
    ON e.emp_id = ep.emp_id
JOIN Project p
    ON ep.project_id = p.project_id;

-- Employee, department, and department project details
SELECT
    e.emp_name,
    d.dept_name,
    e.salary,
    p.project_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
JOIN Project p
    ON d.dept_id = p.dept_id;

/* -------------------------
   SUBQUERIES
   ------------------------- */

-- Employees earning above their department average
SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    e.dept_id
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

-- Employees assigned to at least one project
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.emp_id = e.emp_id
);

-- Simulated INTERSECT:
-- Department 1 employees assigned to project 201
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE e.dept_id = 1
  AND EXISTS (
      SELECT 1
      FROM Employee_Project ep
      WHERE ep.emp_id = e.emp_id
        AND ep.project_id = 201
  );

-- Simulated EXCEPT:
-- Department 1 employees not assigned to project 201
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE e.dept_id = 1
  AND NOT EXISTS (
      SELECT 1
      FROM Employee_Project ep
      WHERE ep.emp_id = e.emp_id
        AND ep.project_id = 201
  );

/* -------------------------
   EXECUTION PLANS
   ------------------------- */

EXPLAIN SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;

EXPLAIN SELECT
    d.dept_name,
    e.emp_name
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;

EXPLAIN SELECT
    e.emp_name,
    e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

EXPLAIN SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.emp_id = e.emp_id
);

/* -------------------------
   VIEWS
   ------------------------- */

-- Department salary summary view
CREATE OR REPLACE VIEW Department_Salary_Summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    COALESCE(SUM(e.salary), 0) AS total_salary,
    AVG(e.salary) AS average_salary,
    MAX(e.salary) AS highest_salary,
    MIN(e.salary) AS lowest_salary
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT * FROM Department_Salary_Summary;

-- Departments with average salary above 75,000
SELECT
    dept_name,
    average_salary
FROM Department_Salary_Summary
WHERE average_salary > 75000;

-- Updatable employee view
CREATE OR REPLACE VIEW Employee_Basic AS
SELECT
    emp_id,
    emp_name,
    salary,
    dept_id
FROM Employee;

-- Update employee salary through Employee_Basic view
UPDATE Employee_Basic
SET salary = 78000
WHERE emp_id = 101;

SELECT * FROM Employee WHERE emp_id = 101;

-- This update is expected to fail because aggregate views are non-updatable
UPDATE Department_Salary_Summary
SET average_salary = 80000
WHERE dept_id = 1;

/* -------------------------
   EMPLOYEE HIERARCHY
   ------------------------- */

ALTER TABLE Employee ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);

-- Clear old hierarchy assignments
UPDATE Employee SET manager_id = NULL;

-- IT hierarchy
UPDATE Employee SET manager_id = 105 WHERE emp_id IN (103, 104);
UPDATE Employee SET manager_id = 103 WHERE emp_id IN (101, 102);
UPDATE Employee SET manager_id = 104 WHERE emp_id = 106;

-- Finance hierarchy
UPDATE Employee SET manager_id = 112 WHERE emp_id IN (107, 108);
UPDATE Employee SET manager_id = 107 WHERE emp_id = 109;
UPDATE Employee SET manager_id = 108 WHERE emp_id IN (110, 111);

-- Marketing hierarchy
UPDATE Employee SET manager_id = 114 WHERE emp_id IN (113, 115, 116, 117, 118);

-- HR hierarchy
UPDATE Employee SET manager_id = 122 WHERE emp_id IN (119, 120, 121, 123, 124);

-- Research hierarchy
UPDATE Employee SET manager_id = 125 WHERE emp_id IN (126, 127, 128);
UPDATE Employee SET manager_id = 126 WHERE emp_id = 129;
UPDATE Employee SET manager_id = 128 WHERE emp_id = 130;

-- Employee hierarchy view
CREATE OR REPLACE VIEW Employee_Hierarchy AS
SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    e.manager_id,
    m.emp_name AS manager_name,
    e.salary,
    e.dept_id
FROM Employee e
LEFT JOIN Employee m
    ON e.manager_id = m.emp_id;

SELECT * FROM Employee_Hierarchy;

/* -------------------------
   RECURSIVE CTE QUERIES
   ------------------------- */

-- Complete organizational reporting hierarchy
WITH RECURSIVE EmployeeChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        CAST(emp_name AS CHAR(500)) AS reporting_chain
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1,
        CONCAT(ec.reporting_chain, ' -> ', e.emp_name)
    FROM Employee e
    JOIN EmployeeChain ec
        ON e.manager_id = ec.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level,
    reporting_chain
FROM EmployeeChain
ORDER BY reporting_chain;

-- Upward reporting chain for employee 101
WITH RECURSIVE ReportingChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE emp_id = 101

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1
    FROM Employee e
    JOIN ReportingChain rc
        ON e.emp_id = rc.manager_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level
FROM ReportingChain;
```

## How to Run
1. Open MySQL Workbench or another MySQL 8+ client.
2. Select the database that contains the required tables.
3. Confirm the tables and column names match the script.
4. Run the script in sections, reviewing each result before moving on.
5. Inspect the output of each `EXPLAIN` query to see how MySQL plans to execute it.

## Important Notes
- The script expects `Employee.emp_id`, `Employee.emp_name`, `Employee.dept_id`, and `Employee.salary`; `Department.dept_id` and `Department.dept_name`; `Project.project_id`, `Project.project_name`, `Project.dept_id`, and `Project.budget`; and `Employee_Project.emp_id`, `project_id`, and `hours_worked`.
- The salary summary query uses `Salaries.employee_id` and `Salaries.amount`. This table is separate from the `Employee.salary` values used in the other salary queries.
- The query joining projects through `d.dept_id = p.dept_id` lists projects associated with the employee's department; it does not prove that an individual employee is assigned to each listed project. Use `Employee_Project` for employee-specific project assignments.
- The `ALTER TABLE Employee ADD COLUMN manager_id` and foreign-key creation are one-time schema changes. If `manager_id` or `fk_employee_manager` already exists, adjust or skip those statements.
- The view `Department_Salary_Summary` contains aggregate expressions and is not directly updatable in MySQL. The attempted update is included to demonstrate this limitation and may stop execution if the client halts on SQL errors.
- The employee hierarchy updates assume employee IDs 101–130 exist. The manager IDs must also exist in `Employee`.
- The recursive CTEs require MySQL 8.0 or later.

## Result
This experiment demonstrates how to combine SQL aggregation, joins, subqueries, views, foreign keys, query execution plans, and recursive CTEs to report on employees, departments, salaries, projects, and organizational reporting relationships.

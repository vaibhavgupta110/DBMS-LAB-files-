# Experiment 3: SQL Queries on Employees, Departments, Salaries, and Projects

## Aim
To practice inserting employee–project assignment records and using SQL aggregate functions, `GROUP BY`, `HAVING`, `CASE`, joins, and sorting to generate reports.

## Database Tables Used
The supplied SQL refers to these tables and columns:

- `Employee_Project`: `emp_id`, `project_id`, `hours_worked`
- `employees`: `employee_id`, `first_name`, `last_name`, `dept_id` / `department_id`
- `salaries`: `employee_id`, `amount`
- `departments`: `department_id`, `department_name`
- `project`: `project_id`, `project_name`, `dept_id`, `budget`

> **Note:** The provided queries use both `dept_id` and `department_id` for employee department references, and `Employee_Project` / `employee_project` with different capitalization. Depending on your database, use the exact table and column names defined in your schema. The SQL below follows the supplied statements.

## 1. Insert Employee Project Assignments

```sql
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
```

## 2. Salary Summary

Uses aggregate functions to calculate the number of employees represented in the salary table, total salary, average salary, highest salary, and lowest salary.

```sql
SELECT
    COUNT(DISTINCT employee_id) AS total_employees,
    SUM(amount) AS total_salary,
    AVG(amount) AS average_salary,
    MAX(amount) AS highest_salary,
    MIN(amount) AS lowest_salary
FROM salaries;
```

## 3. Employee Count by Department

```sql
SELECT
    dept_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id;
```

## 4. Average Salary by Department

```sql
SELECT
    d.department_name,
    AVG(s.amount) AS average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN salaries s
    ON e.employee_id = s.employee_id
GROUP BY d.department_name;
```

## 5. Departments with Average Salary Above 75,000

`HAVING` filters grouped results after the average salary is calculated.

```sql
SELECT
    d.department_name,
    AVG(s.amount) AS average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN salaries s
    ON e.employee_id = s.employee_id
GROUP BY d.department_name
HAVING AVG(s.amount) > 75000;
```

## 6. Salary Categories Using CASE

```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
    s.amount AS salary,
    CASE
        WHEN s.amount >= 90000 THEN 'High Salary'
        WHEN s.amount >= 70000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM employees e
JOIN salaries s
    ON e.employee_id = s.employee_id;
```

## 7. Complete Project–Department Report

Lists projects with their department and budget, ordered from highest budget to lowest.

```sql
SELECT
    p.project_id,
    p.project_name,
    d.department_name,
    p.budget
FROM project p
JOIN departments d
    ON p.dept_id = d.department_id
ORDER BY p.budget DESC;
```

## 8. Project Details

```sql
SELECT
    p.project_name,
    d.department_name,
    p.budget
FROM project p
JOIN departments d
    ON p.dept_id = d.department_id
ORDER BY p.budget DESC;
```

## 9. Employees Working on Projects

Shows each employee's name, project name, and hours worked, ordered by hours worked from highest to lowest.

```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
    p.project_name,
    ep.hours_worked
FROM employee_project ep
JOIN employees e
    ON ep.emp_id = e.employee_id
JOIN project p
    ON ep.project_id = p.project_id
ORDER BY ep.hours_worked DESC;
```

## Concepts Practiced

- `INSERT INTO` for adding multiple assignment records
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `MAX`, and `MIN`
- `GROUP BY` for department-wise summaries
- `HAVING` for filtering grouped results
- `JOIN` for combining related tables
- `CASE` for classifying salaries into categories
- `CONCAT` for displaying full employee names
- `ORDER BY ... DESC` for sorting reports

## Result
The experiment demonstrates how SQL can insert employee project assignments and produce salary, department, and project reports using aggregate functions, joins, conditional expressions, grouping, and sorting.

## Important Checks
1. Create the referenced tables and populate them with matching employee, department, salary, and project IDs before running these queries.
2. Ensure each inserted `emp_id` and `project_id` matches a record in the related tables if foreign keys are enabled.
3. Confirm the department column names and table-name capitalization in your schema before executing the queries.
4. The expected output depends on the data already present in the database.

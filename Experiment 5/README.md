# Experiment 5: Advanced SQL Queries, Views, and Employee Hierarchy

## Aim
To practice SQL operations on an employee–department–project database using MySQL 8+, including aggregate queries, joins, subqueries, views, hierarchical relationships, and recursive common table expressions (CTEs).

## Requirements
- MySQL 8.0 or later
- A SQL client such as MySQL Workbench or the MySQL command-line client
- Existing tables: `Employee`, `Department`, `Project`, `Employee_Project`, and `Salaries`

## Topics Covered

### 1. Project assignments
Insert employee-to-project assignments into `Employee_Project`, recording `emp_id`, `project_id`, and `hours_worked`.

### 2. Salary and department analysis
The script demonstrates:
- Overall salary statistics: employee count, total, average, highest, and lowest salary
- Employee count grouped by department
- Average salary per department
- Filtering departments whose average salary exceeds 75,000 with `HAVING`
- Salary classification with `CASE` (`High Salary`, `Medium Salary`, or `Low Salary`)

### 3. Project reports
Join `Project` with `Department` to list project details and budgets in descending budget order. Join `Employee_Project`, `Employee`, and `Project` to list employees assigned to projects and their recorded hours.

### 4. Joins
- `INNER JOIN`: employees matched with their departments
- `LEFT JOIN`: all departments, including departments without employees
- Multi-table join: employees, departments, assignments, and projects
- Department/project details alongside employee salary

### 5. Subqueries and existence checks
- Correlated subquery to find employees earning above their department's average salary
- `EXISTS` to find employees assigned to at least one project
- `EXISTS` to simulate an intersection: department 1 employees assigned to project 201
- `NOT EXISTS` to simulate an exclusion: department 1 employees not assigned to project 201

### 6. Query execution plans
`EXPLAIN` is used with join and subquery examples to inspect how MySQL plans to execute the queries.

### 7. Views
- `Department_Salary_Summary`: department-level employee and salary aggregates
- Query the view for departments with average salaries above 75,000
- `Employee_Basic`: a simple employee view
- Update an employee's salary through `Employee_Basic`
- Attempt to update an aggregate view to demonstrate that aggregate views are generally not updatable

### 8. Employee management hierarchy
Add `manager_id` to `Employee`, create a self-referencing foreign key, and populate reporting relationships. The `Employee_Hierarchy` view shows each employee with their manager.

### 9. Recursive CTEs
- Build the complete organizational reporting hierarchy with levels and a readable reporting chain
- Find the upward reporting chain for employee `101`

## How to Run
1. Start MySQL 8.0+ and select the database containing the required tables.
2. Confirm that table and column names match the script.
3. Run the script in sections, checking the result of each query.
4. Run the `INSERT` statements only if the assignment rows do not already exist.
5. Review each `EXPLAIN` output in your SQL client.

## Important Notes
- The script assumes all referenced tables and columns already exist and contain compatible data.
- The assignment rows use employee IDs `101`–`130` and project IDs `201`–`208`; those referenced records must exist first.
- Running the insert section repeatedly may cause duplicate-key errors if the table has a primary key or unique constraint on the same assignment.
- `ALTER TABLE Employee ADD COLUMN manager_id ...` and the foreign-key addition are one-time schema changes. If `manager_id` or the constraint already exists, those statements may fail.
- The self-referencing foreign key requires each non-NULL `manager_id` to match an existing `Employee.emp_id`.
- The attempted update to `Department_Salary_Summary` is intentionally included to illustrate that a view containing aggregate functions and `GROUP BY` is not directly updatable in MySQL.
- The query joining `Project` through `d.dept_id = p.dept_id` returns projects belonging to the employee's department; it does not necessarily show only projects assigned to that individual employee.
- The script uses `Salaries` for the overall salary summary, while department-level analysis uses `Employee.salary`. Ensure both sources are intentional and consistent with your schema.

## Expected Result
After successful execution, the queries should return salary summaries, department statistics, project reports, employee-project assignments, join and subquery results, view contents, manager relationships, and recursive reporting chains. Exact rows depend on the data already present in the database.

## Conclusion
This experiment demonstrates how to combine SQL aggregation, joins, subqueries, views, execution-plan inspection, self-referencing foreign keys, and recursive CTEs to analyze project assignments and represent an employee reporting hierarchy.

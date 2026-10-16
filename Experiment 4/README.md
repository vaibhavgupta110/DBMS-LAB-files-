# Experiment 4: SQL Joins, Subqueries, Set Operations, and EXPLAIN

## Aim
To practice SQL joins, correlated subqueries, `EXISTS` and `NOT EXISTS`, simulated set operations, and inspecting query execution plans with `EXPLAIN`.

## Requirements
- A relational database that supports the SQL syntax used in this experiment.
- Tables: `Employee`, `Department`, `Project`, and `Employee_Project`.
- The table and column names must match the schema used in your database.

## Queries Covered

### 1. INNER JOIN — Employees and Departments
Returns employees with their matching department details.

```sql
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;
```

### 2. LEFT JOIN — All Departments
Returns every department, including departments that have no employees.

```sql
SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;
```

### 3. Multi-table JOIN — Employees, Departments, and Projects
Returns employees and the projects to which they are assigned, along with department names.

```sql
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
```

### 4. Employee and Department/Project Details
Joins employees to their department and projects associated with that department.

```sql
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
```

### 5. Correlated Subquery — Salary Above Department Average
Finds employees whose salary is higher than the average salary of their own department.

```sql
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
```

### 6. EXISTS — Employees Assigned to a Project
Returns employees with at least one matching assignment in `Employee_Project`.

```sql
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.emp_id = e.emp_id
);
```

### 7. Simulated INTERSECT — Department 1 Employees on Project 201
Returns employees who belong to department 1 and are assigned to project 201.

```sql
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
```

### 8. Simulated EXCEPT — Department 1 Employees Not on Project 201
Returns employees in department 1 who do not have an assignment to project 201.

```sql
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
```

### 9. EXPLAIN — INNER JOIN
Displays the database's execution plan for the employee/department inner join.

```sql
EXPLAIN
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;
```

### 10. EXPLAIN — LEFT JOIN
Displays the execution plan for the department/employee left join.

```sql
EXPLAIN
SELECT
    d.dept_name,
    e.emp_name
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;
```

### 11. EXPLAIN — Correlated Subquery
Displays the execution plan for the query that compares each employee's salary with their department average.

```sql
EXPLAIN
SELECT
    e.emp_name,
    e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);
```

### 12. EXPLAIN — EXISTS
Displays the execution plan for the employee assignment existence check.

```sql
EXPLAIN
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.emp_id = e.emp_id
);
```

## Concepts Practiced
- `INNER JOIN` and `LEFT JOIN`
- Joining multiple tables
- Correlated subqueries and aggregate functions
- `EXISTS` and `NOT EXISTS`
- Simulating intersection and difference conditions
- Reading query execution plans using `EXPLAIN`

## Important Notes
- The SQL above follows the supplied queries; it assumes the listed tables and columns exist.
- Query 4 joins `Project` to `Department` through `dept_id`, rather than linking projects to employees through `Employee_Project`. This reports projects associated with a department, not necessarily the projects to which each employee is individually assigned.
- `EXPLAIN` output and supported syntax vary by database system.
- Ensure that `Employee_Project` contains valid employee and project IDs and that the relevant join columns use compatible data types.

## Result
The experiment demonstrates SQL joins, subqueries, existence checks, set-operation-style filtering, and execution-plan inspection.

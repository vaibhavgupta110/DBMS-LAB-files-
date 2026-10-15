-- Insert employee project assignments
INSERT INTO Employee_Project (emp_id, project_id, hours_worked)
VALUES
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

-- Salary summary
SELECT
    COUNT(DISTINCT employee_id) AS total_employees,
    SUM(amount) AS total_salary,
    AVG(amount) AS average_salary,
    MAX(amount) AS highest_salary,
    MIN(amount) AS lowest_salary
FROM salaries;

-- Employee count by department
SELECT
    dept_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id;

-- Average salary by department
SELECT
    d.department_name,
    AVG(s.amount) AS average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN salaries s
    ON e.employee_id = s.employee_id
GROUP BY d.department_name;

-- Departments with an average salary above 75,000
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

-- Salary categories using CASE
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

-- Complete project-department report
SELECT
    p.project_id,
    p.project_name,
    d.department_name,
    p.budget
FROM project p
JOIN departments d
    ON p.dept_id = d.department_id
ORDER BY p.budget DESC;

-- Project details
SELECT
    p.project_name,
    d.department_name,
    p.budget
FROM project p
JOIN departments d
    ON p.dept_id = d.department_id
ORDER BY p.budget DESC;

-- Employees working on projects
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
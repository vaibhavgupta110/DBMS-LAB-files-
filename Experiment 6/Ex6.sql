/* =========================================================
   EMPLOYEE–DEPARTMENT–PROJECT COMPLETE MYSQL SCRIPT
   ========================================================= */


/* -------------------------
   INSERT EMPLOYEE PROJECT DATA
   ------------------------- */
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


/* -------------------------
   SALARY QUERIES
   ------------------------- */

SELECT
    COUNT(DISTINCT employee_id) AS total_employees,
    SUM(amount) AS total_salary,
    AVG(amount) AS average_salary,
    MAX(amount) AS highest_salary,
    MIN(amount) AS lowest_salary
FROM Salaries;

SELECT
    dept_id,
    COUNT(*) AS employee_count
FROM Employee
GROUP BY dept_id;

SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 75000;

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

SELECT
    p.project_id,
    p.project_name,
    d.dept_name,
    p.budget
FROM Project p
JOIN Department d
    ON p.dept_id = d.dept_id
ORDER BY p.budget DESC;

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
   JOINS
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

-- Employee, Department, and Project details
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

-- Correlated Subquery
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

-- EXISTS
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.emp_id = e.emp_id
);

-- Simulated INTERSECT
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

-- Simulated EXCEPT
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
   EXPLAIN EXECUTION PLANS
   ------------------------- */

EXPLAIN
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;

EXPLAIN
SELECT
    d.dept_name,
    e.emp_name
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;

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


/* -------------------------
   VIEWS
   ------------------------- */

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

SELECT *
FROM Department_Salary_Summary;

SELECT
    dept_name,
    average_salary
FROM Department_Salary_Summary
WHERE average_salary > 75000;

CREATE OR REPLACE VIEW Employee_Basic AS
SELECT
    emp_id,
    emp_name,
    salary,
    dept_id
FROM Employee;

UPDATE Employee_Basic
SET salary = 78000
WHERE emp_id = 101;

SELECT *
FROM Employee
WHERE emp_id = 101;

-- This query will fail because aggregate views cannot be updated
-- UPDATE Department_Salary_Summary
-- SET average_salary = 80000
-- WHERE dept_id = 1;


/* -------------------------
   EMPLOYEE HIERARCHY
   ------------------------- */

ALTER TABLE Employee
ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id)
REFERENCES Employee(emp_id);

UPDATE Employee
SET manager_id = NULL;

-- IT Hierarchy
UPDATE Employee
SET manager_id = 105
WHERE emp_id IN (103, 104);

UPDATE Employee
SET manager_id = 103
WHERE emp_id IN (101, 102);

UPDATE Employee
SET manager_id = 104
WHERE emp_id = 106;

-- Finance Hierarchy
UPDATE Employee
SET manager_id = 112
WHERE emp_id IN (107, 108);

UPDATE Employee
SET manager_id = 107
WHERE emp_id = 109;

UPDATE Employee
SET manager_id = 108
WHERE emp_id IN (110, 111);

-- Marketing Hierarchy
UPDATE Employee
SET manager_id = 114
WHERE emp_id IN (113, 115, 116, 117, 118);

-- HR Hierarchy
UPDATE Employee
SET manager_id = 122
WHERE emp_id IN (119, 120, 121, 123, 124);

-- Research Hierarchy
UPDATE Employee
SET manager_id = 125
WHERE emp_id IN (126, 127, 128);

UPDATE Employee
SET manager_id = 126
WHERE emp_id = 129;

UPDATE Employee
SET manager_id = 128
WHERE emp_id = 130;

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

SELECT *
FROM Employee_Hierarchy;


/* -------------------------
   RECURSIVE CTE
   ------------------------- */

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


/* -------------------------
   RECURSIVE CTE FOR EMPLOYEE 101
   ------------------------- */

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


/* -------------------------
   STORED PROCEDURE:
   TRANSFER EMPLOYEE
   ------------------------- */

DROP PROCEDURE IF EXISTS transfer_employee;

DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_employee_count INT DEFAULT 0;
    DECLARE v_department_count INT DEFAULT 0;
    DECLARE v_current_dept INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred. Transaction rolled back.' AS message;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_employee_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_employee_count = 0 THEN
        ROLLBACK;
        SELECT 'Error: Employee does not exist.' AS message;

    ELSE
        SELECT COUNT(*)
        INTO v_department_count
        FROM Department
        WHERE dept_id = p_new_dept_id;

        IF v_department_count = 0 THEN
            ROLLBACK;
            SELECT 'Error: Department does not exist.' AS message;

        ELSE
            SELECT dept_id
            INTO v_current_dept
            FROM Employee
            WHERE emp_id = p_emp_id;

            IF v_current_dept = p_new_dept_id THEN
                ROLLBACK;
                SELECT 'Error: Employee is already in this department.' AS message;

            ELSE
                UPDATE Employee
                SET dept_id = p_new_dept_id
                WHERE emp_id = p_emp_id;

                COMMIT;
                SELECT 'Employee transferred successfully.' AS message;
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;

-- Test Stored Procedure
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
WHERE e.emp_id = 101;

CALL transfer_employee(101, 3);

SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee e
JOIN Department d
    ON e.dept_id = d.dept_id
WHERE e.emp_id = 101;

-- Edge Cases
CALL transfer_employee(999, 3);
CALL transfer_employee(101, 99);
CALL transfer_employee(101, 3);


/* -------------------------
   SALARY VALIDATION TRIGGERS
   ------------------------- */

DROP TRIGGER IF EXISTS validate_employee_salary;
DROP TRIGGER IF EXISTS validate_employee_salary_update;
DROP TRIGGER IF EXISTS salary_audit_trigger;

DELIMITER //

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary IS NULL OR NEW.salary < 15000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be NULL and must be at least 15000';
    END IF;
END //

CREATE TRIGGER validate_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary IS NULL OR NEW.salary < 15000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be NULL and must be at least 15000';
    END IF;
END //

DELIMITER ;

-- Invalid salary test: expected to fail
-- INSERT INTO Employee
-- (emp_id, emp_name, gender, salary, hire_date, dept_id)
-- VALUES
-- (131, 'Test Employee', 'M', 10000, '2026-09-25', 1);

-- Valid salary test
INSERT INTO Employee
(emp_id, emp_name, gender, salary, hire_date, dept_id)
VALUES
(131, 'Test Employee', 'M', 30000, '2026-09-25', 1);

SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE emp_id = 131;

-- Invalid update test: expected to fail
-- UPDATE Employee
-- SET salary = 5000
-- WHERE emp_id = 131;


/* -------------------------
   SALARY AUDIT TABLE & TRIGGER
   ------------------------- */

CREATE TABLE IF NOT EXISTS Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(30) NOT NULL
);

DELIMITER //

CREATE TRIGGER salary_audit_trigger
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NOT (OLD.salary <=> NEW.salary) THEN
        INSERT INTO Salary_Audit (
            emp_id,
            old_salary,
            new_salary,
            action
        )
        VALUES (
            NEW.emp_id,
            OLD.salary,
            NEW.salary,
            'SALARY UPDATED'
        );
    END IF;
END //

DELIMITER ;

-- Test audit trigger
UPDATE Employee
SET salary = 35000
WHERE emp_id = 131;

SELECT *
FROM Salary_Audit;

-- Test multiple salary changes
UPDATE Employee
SET salary = 40000
WHERE emp_id = 131;

UPDATE Employee
SET salary = 45000
WHERE emp_id = 131;

SELECT
    audit_id,
    emp_id,
    old_salary,
    new_salary,
    action
FROM Salary_Audit
WHERE emp_id = 131;

-- Salary unchanged: no new audit record
UPDATE Employee
SET salary = 45000
WHERE emp_id = 131;

-- NULL salary test: expected to fail
-- INSERT INTO Employee
-- (emp_id, emp_name, gender, salary, hire_date, dept_id)
-- VALUES
-- (132, 'Null Salary', 'F', NULL, '2026-09-25', 1);

SHOW TRIGGERS;

SHOW PROCEDURE STATUS
WHERE Db = DATABASE();
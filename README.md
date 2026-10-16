# SQL Experiments Repository

A collection of SQL database experiments, with experiment-wise folders containing practical write-ups, SQL scripts (where applicable), and PDF records. The repository progresses from database design and relational constraints to analytical queries and advanced SQL features.

## Repository Structure

```text
.
├── README.md
├── Experiment 1/
│   ├── README.md
│   └── experiment 1.pdf
├── Experiment 2/
│   ├── Ex2.sql
│   ├── README.md
│   └── experiment 2.pdf
├── Experiment 3/
│   ├── Ex3.sql
│   ├── README.md
│   └── experiment 3.pdf
├── Experiment 4/
│   ├── Ex4.sql
│   ├── README.md
│   └── experiment 4.pdf
├── Experiment 5/
│   ├── Ex5.sql
│   ├── README.md
│   └── experiment 5.pdf
└── Experiment 6/
    ├── Ex6.sql
    ├── README.md
    └── experiment 6.pdf
```

> The tree above is a guide based on the repository's experiment folders and the visible file names. Keep each folder's actual file names as they appear in your repository. If a script is not present for an experiment, use the SQL included in its README or practical record where available.

## Experiments at a Glance

| Experiment | Main subject | What it covers |
|---|---|---|
| **Experiment 1** | E-commerce ER diagram | Entities, attributes, relationships, and a conceptual model for customers, orders, products, sellers, categories, payments, and deliveries. |
| **Experiment 2** | Relational schema and constraints | Creating e-commerce tables; primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `DEFAULT`, referential integrity, and sample data. |
| **Experiment 3** | SQL reporting and aggregation | Employee/project data, aggregate functions, grouping, `HAVING`, `CASE`, joins, sorting, and salary/project summaries. |
| **Experiment 4** | Joins, subqueries, and query plans | `INNER JOIN`, `LEFT JOIN`, multi-table joins, correlated subqueries, `EXISTS`, `NOT EXISTS`, set-operation-style queries, and `EXPLAIN`. |
| **Experiment 5** | Advanced SQL, views, and hierarchy | Salary analysis, project reports, joins, subqueries, views, employee hierarchy, and recursive CTEs. |
| **Experiment 6** | Advanced database programming | Reporting queries, joins and subqueries, `EXPLAIN`, views, hierarchy/recursive CTEs, a stored procedure for employee salary transfer, salary validation triggers, and salary audit logging. |

## Technologies and Tools

- **SQL / MySQL** — database definition, data manipulation, queries, and database programming.
- **MySQL Server** — recommended database engine for the MySQL-specific syntax used in the later experiments.
- **MySQL Workbench** or another compatible SQL editor — for executing scripts and inspecting results.
- **PDF reader** — for viewing practical records.

Some syntax—such as recursive CTEs, stored procedures, triggers, and `EXPLAIN` output—can vary between database engines. MySQL 8.0 or later is recommended for the advanced experiments.

## How to Use This Repository

1. **Open an experiment folder.** Each experiment has its own README and practical PDF; some folders also include a standalone `.sql` file.
2. **Read the experiment README first.** Check its aim, prerequisites, table names, and notes before running any code.
3. **Set up the database.** Create or select the database required by that experiment and ensure the referenced tables exist.
4. **Run the SQL script.** Open the `.sql` file in MySQL Workbench (or a compatible client), review it, and execute it in the order shown.
5. **Verify the output.** Run the included `SELECT` statements and compare the results with the expected behavior described in the experiment.
6. **Keep experiments separate.** Experiments may use different database names, table definitions, or sample data. Do not assume one experiment's schema automatically satisfies another's requirements.

### Suggested execution order

Run Experiments 1 and 2 first to understand the e-commerce model and relational constraints. Experiments 3–6 focus on employee, department, salary, and project data and may require a separate schema prepared for those examples.

## Important Notes

- **Back up your database** before running scripts that insert, update, delete, alter, or drop data.
- Some scripts are designed as classroom demonstrations. Running the same `INSERT`, `CREATE`, or `ALTER` statement more than once may produce duplicate-key or already-exists errors unless the script includes safeguards.
- Verify table and column names against your local schema. SQL identifiers and capitalization behavior can vary by operating system and database configuration.
- Use the correct SQL dialect. The later experiments use MySQL-oriented features; they may need changes to run on PostgreSQL, SQL Server, SQLite, or other systems.
- Stored procedures and triggers can change data. Test them on sample records first and inspect the affected rows afterward.
- Do not put real passwords, connection strings, or other secrets in repository files.

## Learning Outcomes

By completing the experiments, a learner should be able to:

- Design an ER model and translate it into relational tables.
- Define primary keys, foreign keys, and integrity constraints.
- Write and interpret `SELECT`, `INSERT`, `UPDATE`, and other common SQL statements.
- Summarize data using aggregate functions, `GROUP BY`, and `HAVING`.
- Combine tables using joins and answer questions using subqueries.
- Create and query views.
- Explore hierarchical data using recursive CTEs.
- Inspect query plans with `EXPLAIN`.
- Write basic stored procedures and triggers and record audit information.

## Contribution and Maintenance

When adding or updating an experiment:

1. Keep each experiment's files inside its matching folder.
2. Use a clear file naming convention, such as `Ex7.sql`, `README.md`, and `experiment 7.pdf`.
3. Include the aim, requirements, topics, run instructions, and important warnings in each experiment README.
4. Update the **Repository Structure** and **Experiments at a Glance** sections in this root README.
5. Ensure the documentation describes what the SQL actually does and does not claim that untested code has been verified.

## License

No license is specified in this repository. Add a `LICENSE` file if you intend to publish or distribute the work under a particular license.

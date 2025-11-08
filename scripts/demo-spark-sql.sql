-- Créer une base de données
CREATE DATABASE IF NOT EXISTS demo_db;
USE demo_db;

-- Créer une table à partir de données CSV
CREATE TABLE IF NOT EXISTS employees (
    id INT,
    name STRING,
    department STRING,
    salary DOUBLE
) USING CSV
OPTIONS (
    path 'hdfs://namenode:9000/data/employees.csv',
    header 'true'
);

-- Ou créer une table managée par Spark
CREATE TABLE IF NOT EXISTS departments (
    dept_id INT,
    dept_name STRING
) USING PARQUET;

-- Insérer des données
INSERT INTO departments VALUES 
(1, 'Engineering'),
(2, 'Marketing'),
(3, 'Sales');

-- Requête SQL
SELECT d.dept_name, AVG(e.salary) as avg_salary
FROM employees e
JOIN departments d ON e.department = d.dept_name
GROUP BY d.dept_name;
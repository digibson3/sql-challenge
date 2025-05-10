# sql-challenge
Module 9 Homework

## Pewlett Hackard Employee Data Analysis

### Background

This project invloves designing a database schema, importing the CSV files into a SQL database, creating an ERD, and preforming data analysis to extract meaningful insights.

### Project Scope

The project includes three main phases

1. Data Modeling: Designing the SQL database schema to store the employee data.

2. Data Engineering: Importing the CSV data into the database.

3. Creating an effective Entity-Relationship Diagram (ERD).

4. Data Analysis: Writing SQL queries to analyze the data.

### Database Schema

The database consists of the following tables:

- employees - Stores employee details, including employee number, name, birth data, sex, and hire date.

- departments - Stores department names and department numbers.

- dept_emp - Maps employees to their respective departments.

- dept_manager - Stores department manager asignments.

- salarie - Records employee salaries.

- titles - Store employee job titles.

### Entity- Relationship Diagram (ERD)

### Setup Instructions

1. Create Tables

```sql
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_no CHAR(40) PRIMARY KEY,
    dept_name VARCHAR(40) UNIQUE 
);

SELECT * FROM departments

DROP TABLE IF EXISTS dept_emp;

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no CHAR(40) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),  
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no), 
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)   
);

SELECT * FROM dept_emp;

DROP TABLE IF EXISTS dept_mangers;

CREATE TABLE dept_managers (
    dept_no CHAR(40) NOT NULL,
    emp_no INT NOT NULL,
    PRIMARY KEY (dept_no, emp_no),  
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),  
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no) 
);

SELECT * FROM dept_managers

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_no INT PRIMARY KEY,  
    emp_title_id VARCHAR(40),
    birth_date DATE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    sex CHAR(1),
);

SELECT * FROM employees;

DROP TABLE IF EXISTS salaries;

CREATE TABLE salaries (
   emp_no INT NOT NULL,
   salary INT,
   PRIMARY KEY (emp_no),  
   FOREIGN KEY (emp_no) REFERENCES employees(emp_no) 
);

SELECT * FROM salaries

DROP TABLE IF EXISTS titles;

CREATE TABLE titles (
    title_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(50) NOT NULL  
);
```
### Import Data from CSV Files

```sql
COPY employees FROM 'path_to_csv/employees.csv' DELIMITER ',' CSV HEADER;
COPY departments FROM 'path_to_csv/departments.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM 'path_to_csv/dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY dept_manager FROM 'path_to_csv/dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM 'path_to_csv/salaries.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM 'path_to_csv/titles.csv' DELIMITER ',' CSV HEADER;
```

### Data Analysis Queries

1. List the employee number, last name, first name, sex, and salary of each employee.

```sql
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON
salaries.emp_no=employees.emp_no;
```

2. List employees hired in 1986
```sql
SELECT employees.first_name,employees.last_name, employees.hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;
```

3. List department mangers with their department details
```sql
SELECT dept_managers.dept_no, departments.dept_name,dept_managers.emp_no, employees.last_name, employees.first_name
FROM dept_managers
INNER JOIN departments ON
dept_managers.dept_no=departments.dept_no
INNER JOIN employees ON
dept_managers.emp_no=employees.emp_no;
```

4. List each each employee's department details
```sql
SELECT dept_emp.emp_no, dept_emp.dept_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
INNER JOIN departments ON
dept_emp.dept_no=departments.dept_no
INNER JOIN employees ON
dept_emp.emp_no=employees.emp_no;
```

5. Find employees named Hercules whose last name starts with 'B'
```sql
SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE employees.first_name='Hercules' AND employees.last_name LIKE 'B%';
```

6. List employees in the sales department
```sql
SELECT departments.dept_name, employees.emp_no, employees.last_name, employees.first_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';
```

7. List employee's in Sales and Development departments
```sql
SELECT departments.dept_name, employees.last_name, employees,first_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no=departments.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');
```

8. Count occurences of last names, sorted in decending order
```sql
SELECT employees.last_name, COUNT(*) AS frequency
FROM employees
GROUP BY employees.last_name
ORDER BY frequency DESC;
```





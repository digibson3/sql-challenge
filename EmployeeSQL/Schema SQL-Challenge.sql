-- ##SCHEMA

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

-- ##ERD

departments
-
dept_no CHAR PK
dept_name VARCHAR

dept_emp
-
emp_no INT PK FK >- employees.emp_no
dept_no CHAR PK FK >- departments.dept_no

dept_managers
-
emp_no INT PK FK >- employees.emp_no
dept_no CHAR PK FK >- departments.dept_no

employees
-
emp_no INT PK
emp_title_id VARCHAR
birth_date DATE
first_name VARCHAR
last_name VARCHAR
sex CHAR
hire_date DATE

salaries
-
emp_no INT PK FK >- employees.emp_no
salary INT

titles
-
 title_id VARCHAR PK
 title VARCHAR

--  ##DATA ANALYSIS

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON
salaries.emp_no=employees.emp_no;

-- 2. List the first name, last name, hire date for the employees who were hired in 1986.
SELECT employees.first_name,employees.last_name, employees.hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- 3. List the manager of each department along with their department number, department name, 
-- employee number, last name, and first name.
SELECT dept_managers.dept_no, departments.dept_name,dept_managers.emp_no, employees.last_name, employees.first_name
FROM dept_managers
INNER JOIN departments ON
dept_managers.dept_no=departments.dept_no
INNER JOIN employees ON
dept_managers.emp_no=employees.emp_no

-- 4.List the manager of each department along with their department number, department name, employee number,
--last name, and first name.
SELECT dept_emp.emp_no, dept_emp.dept_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
INNER JOIN departments ON
dept_emp.dept_no=departments.dept_no
INNER JOIN employees ON
dept_emp.emp_no=employees.emp_no

-- 5. List the first name, last name, and sex of each employee whose first name is Hercules and 
-- whose last name begins with the letter B.
SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE employees.first_name='Hercules' AND employees.last_name LIKE 'B%';

-- 6. List each employee in the sales department, including their employee number, last name and 
-- first name.
SELECT departments.dept_name, employees.emp_no, employees.last_name, employees.first_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- 7. List each employee in the sales and development departments, including their employee number
-- last name, first name, and department name.
SELECT departments.dept_name, employees.last_name, employees,first_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no=departments.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');

-- 8.List the frequency counts, in decending order, of all the employee last names (that is, how many 
-- employees share each last name).
SELECT employees.last_name, COUNT(*) AS frequency
FROM employees
GROUP BY employees.last_name
ORDER BY frequency DESC;

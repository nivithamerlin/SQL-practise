-- Find department with the maximum average salary (JOIN + GROUP BY).
SELECT e.name, d.dept_name, AVG(e.salary) AS avg_salary
FROM Employees e
RIGHT JOIN Departments d 
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC
LIMIT 1;

-- List projects with total number of employees assigned.
SELECT p.project_id, p.project_name, COUNT(e.emp_id) AS total_employees
FROM Projects p
LEFT JOIN Employees e ON e.emp_id = p.emp_id
GROUP BY p.project_id, p.project_name;

-- Show the highest salary employee in each department
SELECT d.dept_name, e.name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e.dept_id
);

-- Find employees who earn above average salary of their department (JOIN + HAVING)
SELECT e.emp_id, e.name, d.dept_name, e.salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN (
  SELECT dept_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY dept_id
 ) AS dept_avg ON e.dept_id = dept_avg.dept_id
WHERE e.salary > dept_avg.avg_salary;

-- Get employees whose salary is higher than average salary (subquery in WHERE)
SELECT name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Find employees who work in the department that has the maximum budget
SELECT e.emp_id, e.name, p.project_name
FROM Employees e
JOIN Projects p ON e.emp_id = p.emp_id
WHERE p.project_id = (
  SELECT project_id
  FROM Projects
  ORDER BY budget DESC
  LIMIT 1
);

-- employee with morethan 1 in department
SELECT e.emp_id, e.name, d.dept_name, COUNT(e.emp_id) AS emp_count
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > 1;

-- Employees earning more than avg in their department
SELECT e.emp_id, e.name, e.salary, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.salary > (
  SELECT AVG(salary)
  FROM Employees
  WHERE dept_id = e.dept_id
);

-- Each manager and total salary of employees under them
SELECT m.emp_name AS manager_name, SUM(e.salary) AS total_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY m.emp_name;

-- Employees with departmnet and project
SELECT p.proj_name, d.dept_name, COUNT(ep.emp_id) AS emp_count
FROM Employees e
JOIN Departments d ON p.dept_id = d.dept_id
LEFT JOIN Projects p ON p.emp_id = e.emp_id
GROUP BY p.proj_name, d.dept_name;

-- employees with more than 1 or equal to 1 project
SELECT e.name, COUNT(p.project_id) AS project_count
FROM Employees e
JOIN Projects p ON e.emp_id = p.emp_id
GROUP BY e.emp_id, e.name
HAVING COUNT(p.project_id) = 1;

-- Find the average marks of students in each department.
SELECT d.dept_id, d.dept_name, AVG(e.marks) AS avg_marks
FROM Students s
JOIN Departments d ON s.dept_id = d.dept_id
JOIN Enrollments e ON e.student_id = s.student_id
GROUP BY d.dept_id, d.dept_name;

--  List each department with total number of students enrolled in courses.
SELECT d.dept_name, c.course_name, COUNT(s.student_id) AS student_count
FROM Students s
JOIN Departments d ON d.dept_id = s.dept_id
JOIN Courses c ON d.dept_id = c.dept_id
GROUP BY d.dept_name, c.course_name;
 
-- find the highest marks obtained in each course, along with course name and student name.
SELECT s.student_id, c.course_name, MAX(e.marks) AS highest_mark
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id
GROUP BY c.course_name, s.name;

-- show all students, their department names and their courses joined after 2020
SELECT s.student_id, s.name AS student_name, d.dept_name, c.course_name
FROM Students s
JOIN Departments d ON s.dept_id = d.dept_id
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE (s.year_of_join) = 2020;

-- course with department budget
SELECT c.course_id, c.course_name, d.dept_name, d.budget
FROM Courses c
JOIN Departments d ON c.dept_id = d.dept_id;

-- Get students who scored more than the average marks in their course.
SELECT s.name AS student_name, s.student_id, e.marks, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.marks > (
  SELECT AVG(e2.marks)
  FROM Enrollments e2
  WHERE e2.course_id = e.course_id
);

-- Find students who belong to the department with the maximum budget.
SELECT s.name AS student_name, d.dept_name
FROM Students s
JOIN Departments d ON s.dept_id = d.dept_id
WHERE d.budget = (
  SELECT MAX(budget)
  FROM Departments
);

-- List students who are enrolled in the same course as 'Anu'
SELECT DISTINCT s.student_id, s.name AS student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.course_id IN (
    SELECT e2.course_id
    FROM Enrollments e2
    JOIN Students s2 ON e2.student_id = s2.student_id
    WHERE s2.name = 'Anu'
)
AND s.name <> 'Anu';   -- exclude Anu if only "others" are needed

-----------------SELECT-----------------------

-- 1757. Recyclable and Low Fat Products
SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';


-- 584. Find Customer Referee
SELECT name FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;


-- 595. Big Countries
SELECT name, population, area FROM World
WHERE area >= 3000000 OR population >= 25000000;


-- 1148. Article Views I
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY author_id;


-- 1683. Invalid Tweets
SELECT tweet_id FROM Tweets
WHERE CHAR_LENGTH(content) > 15;






-----------------BASIC JOINS-----------------------
-- 1378. Replace Employee ID With The Unique Identifier
SELECT unique_id, name FROM Employees
LEFT JOIN EmployeeUNI
ON EmployeeUNI.id = Employees.id;


-- 1068. Product Sales Analysis I
SELECT product_name, year, price FROM Sales
JOIN Product
ON Sales.product_id = Product.product_id;


-- 1581. Customer Who Visited but Did Not Make Any Transactions
SELECT customer_id, COUNT(*) AS count_no_trans
FROM Visits 
LEFT JOIN Transactions ON Visits.visit_id = Transactions.visit_id
WHERE transaction_id IS NULL
GROUP BY customer_id
ORDER BY count_no_trans DESC;


-- 197. Rising Temperature
SELECT current.id AS id FROM Weather AS current
JOIN Weather AS yesterday ON current.recordDate = DATE_ADD(yesterday.recordDate, INTERVAL 1 DAY)
WHERE current.temperature > yesterday.temperature;


-- 1661. Average Time of Process per Machine
SELECT m1.machine_id, ROUND(AVG(m2.timestamp - m1.timestamp),3) AS processing_time
FROM Activity AS m1
JOIN Activity AS m2
ON m1.machine_id = m2.machine_id
WHERE m1.activity_type = 'start' AND m2.activity_type = 'end'
GROUP BY m1.machine_id;


-- 577. Employee Bonus
SELECT name, bonus FROM Employee
LEFT JOIN Bonus 
ON Employee.empId = Bonus.empId
WHERE bonus < 1000 || bonus IS NULL;

-- 1280. Students and Examinations
SELECT Students.student_id AS student_id, Students.student_name AS student_name, Subjects.subject_name AS subject_name, 
    CASE
        WHEN Examinations.subject_name IS NULL THEN 0
        ELSE COUNT(*)
    END AS attended_exams 
FROM Subjects
CROSS JOIN Students
LEFT JOIN Examinations ON Examinations.student_id = Students.student_id AND Subjects.subject_name = Examinations.subject_name
GROUP BY Students.student_id, Students.student_name, Subjects.subject_name
ORDER BY Students.student_id, Subjects.subject_name;


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



-- 570. Managers with at Least 5 Direct Reports
SELECT e1.name FROM Employee as e1
JOIN Employee as e2
ON e1.id = e2.managerId
GROUP BY e1.id
HAVING COUNT(*) >= 5;

-- 1934. Confirmation Rate
SELECT Signups.user_id, 
IFNULL(ROUND(SUM(CASE WHEN Confirmations.action = 'confirmed' THEN 1 ELSE 0 END) / COUNT(*),2),0.00) AS confirmation_rate
FROM Signups
LEFT JOIN Confirmations
ON Signups.user_id = Confirmations.user_id
GROUP BY Signups.user_id;



-- 620. Not Boring Movies
SELECT id, movie, description, rating FROM Cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;


-- 1251. Average Selling Price
SELECT Prices.product_id, 
    CASE
        WHEN ROUND(SUM(Prices.price * UnitsSold.units)/SUM(UnitsSold.units),2) IS NULL THEN 0
        ELSE ROUND(SUM(Prices.price * UnitsSold.units)/SUM(UnitsSold.units),2)
    END AS average_price 
FROM Prices
LEFT JOIN UnitsSold ON Prices.product_id = UnitsSold.product_id AND UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date
GROUP BY Prices.product_id;

-- 1075. Project Employees I
SELECT Project.project_id, ROUND(SUM(Employee.experience_years)/COUNT(*),2) AS average_years FROM Project
JOIN Employee ON Project.employee_id = Employee.employee_id
GROUP BY Project.project_id;


-- 1633. Percentage of Users Attended a Contest
SELECT contest_id, ROUND(COUNT(*) / (SELECT COUNT(*) FROM Users) * 100,2) AS percentage FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id;


-- 1211. Queries Quality and Percentage
SELECT query_name, ROUND(SUM(rating/position)/COUNT(*),2) AS quality, 
ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name;


-- 1193. Monthly Transactions I
SELECT SUBSTR(trans_date,1,7) AS month,
        country, 
        COUNT(*) AS trans_count, 
        SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
        SUM(amount) AS trans_total_amount, 
        SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY country, MONTH(trans_date), YEAR(trans_date);

-- 1174. Immediate Food Delivery II
SELECT ROUND(100 *
((SELECT 
    COUNT(DISTINCT customer_id) FROM (
        SELECT customer_id, order_date, 
        MIN(order_date) OVER(PARTITION BY customer_id) AS pref_order,
        MIN(customer_pref_delivery_date) OVER(PARTITION BY customer_id) AS pref_date
        FROM Delivery
    ) AS helper
    WHERE helper.order_date = helper.pref_date && helper.order_date = helper.pref_order) 
    / 
    (SELECT COUNT(DISTINCT customer_id) FROM Delivery)),2)
AS immediate_percentage


-- 550. Game Play Analysis IV
SELECT ROUND((
   SELECT COUNT(DISTINCT player_id) FROM 
    (
        SELECT player_id, event_date, MIN(event_date) OVER(PARTITION BY player_id) AS first_day
        FROM Activity
    ) AS helper
    WHERE DATE_ADD(helper.first_day,INTERVAL 1 DAY) = event_date 
)
/ 
(SELECT COUNT(DISTINCT player_id) FROM Activity)
,2) AS fraction






-----------------SORTING AND GROUPING-----------------------


-- 2356. Number of Unique Subjects Taught by Each Teacher
SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt FROM Teacher
GROUP BY teacher_id;


-- 1141. User Activity for the Past 30 Days I
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE DATE_ADD(activity_date, INTERVAL 30 DAY) >  '2019-07-27' AND activity_date <= '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date;



-- 1070. Product Sales Analysis III
SELECT helper.product_id, first_year, helper.quantity, helper.price FROM
(
    SELECT product_id, year, quantity, price, MIN(year) OVER(PARTITION BY product_id) AS first_year
    FROM Sales
) AS helper
INNER JOIN Product
ON helper.product_id = Product.product_id
WHERE helper.year = helper.first_year;



-- 596. Classes More Than 5 Students
SELECT class FROM Courses
GROUP BY class 
HAVING COUNT(*) >= 5;

-- 1729. Find Followers Count
SELECT user_id, COUNT(*) AS followers_count FROM Followers
GROUP BY user_id
ORDER BY user_id;

-- 619. Biggest Single Number
SELECT
    CASE 
        WHEN COUNT(*) = 1 THEN num
        ELSE NULL
    END AS num
FROM (
    SELECT num FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
    ORDER BY num DESC LIMIT 1
) AS derived_table;


-- 1045. Customers Who Bought All Products
SELECT customer_id FROM Customer
INNER JOIN Product
ON Customer.product_key = Product.product_key
GROUP BY customer_id
HAVING COUNT(DISTINCT Customer.product_key) = (SELECT COUNT(*) FROM Product);






-----------------ADVANCED SELECT AND JOINS----------------------

-- 1731. The Number of Employees Which Report to Each Employee
SELECT e1.employee_id, e1.name, COUNT(*) AS reports_count, ROUND(AVG(e2.age)) AS average_age
FROM Employees AS e1
INNER JOIN Employees AS e2
WHERE e1.employee_id = e2.reports_to
GROUP BY e1.employee_id
ORDER BY e1.employee_id;

-- 1789. Primary Department for Each Employee
SELECT employee_id, department_id
FROM
(
    SELECT employee_id, department_id, primary_flag, COUNT(*) OVER(PARTITION BY employee_id) AS cnt FROM Employee
) AS derived
WHERE derived.cnt = 1 OR derived.primary_flag = 'Y';


-- 610. Triangle Judgement
SELECT *, 
CASE 
    WHEN x + y > z AND x + z > y AND y + z > x THEN "Yes"
    ELSE "No"
END AS triangle
FROM Triangle;

-- 180. Consecutive Numbers














-----------------Subqueries----------------------

-- 1978. Employees Whose Manager Left the Company
SELECT employee_id FROM Employees
WHERE manager_id NOT IN (SELECT DISTINCT employee_id FROM Employees) AND salary < 30000
ORDER BY employee_id;



-- 626. Exchange Seats


-----------------Advanced String Functions / Regex / Clause----------------------
-- 1667. Fix Names in a Table
SELECT user_id, CONCAT(UPPER(SUBSTR(name,1,1)),LOWER(SUBSTR(name,2))) AS name 
FROM Users
ORDER BY user_id;

-- 1527. Patients With a Condition

SELECT patient_id, patient_name, conditions FROM Patients
WHERE conditions LIKE "% DIAB1%" || conditions LIKE "DIAB1%";

-- 196. Delete Duplicate Emails
DELETE FROM Person 
WHERE id NOT IN
(
    SELECT min_id FROM
    (
        SELECT id, email, MIN(id) OVER(PARTITION BY email) AS min_id FROM Person
    ) AS helper
    WHERE helper.id = helper.min_id
);

-- 176. Second Highest Salary
# Write your MySQL query statement below
SELECT
    CASE 
        WHEN COUNT(*) = 1 THEN salary
        ELSE NULL
    END AS SecondHighestSalary
FROM (
    SELECT salary FROM Employee
    GROUP BY salary
    ORDER BY salary DESC LIMIT 1 OFFSET 1
) AS derived_table;

-- 1484. Group Sold Products By The Date
# Write your MySQL query statement below
SELECT sell_date, COUNT(DISTINCT product) AS num_sold, GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY sell_date;

-- 1327. List the Products Ordered in a Period
# Write your MySQL query statement below
SELECT Products.product_name, SUM(unit) as unit FROM Orders
JOIN Products
ON Products.product_id = Orders.product_id
WHERE order_date BETWEEN "2020-02-01" AND "2020-02-29"
GROUP BY Products.product_id
HAVING SUM(unit) >= 100;

-- 1517. Find Users With Valid E-Mails
SELECT user_id, name, mail FROM Users
WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_\\.-]*@leetcode\\.com$';
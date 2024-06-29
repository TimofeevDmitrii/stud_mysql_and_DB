CREATE DATABASE lesson5;
#ALTER DATABASE lesson5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci; 
USE lesson5;

-- задача в конце лекции 5

/*
Задача на 5 минут: создайте представление, которое
показывало бы всех заказчиков, имеющих самые высокие
рейтинги. Привязке к таблице нет, колонки таблицы
воображаемые
*/

DROP TABLE IF EXISTS sales_2024;
CREATE TABLE sales_2024 (
	id_customer SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    ordered_product VARCHAR(50) NOT NULL,
    order_cost DECIMAL NOT NULL
);

INSERT INTO sales_2024 (customer_name, ordered_product, order_cost)
VALUES
('Igor', 'Samsung A50 - 3 шт', 42000),
('Igor', 'Samsung A15 - 3 шт', 50000),
('Alena', 'Xiaomi REDMI 12 - 2 шт', 32000),
('Sergey', 'Xiaomi REDMI 13 - 1 шт', 16000),
('Alena', 'iPhone 12 pro - 2 шт', 70000),
('Oleg', 'Huawei 10S - 4 шт', 80000);

SELECT * FROM sales_2024;


CREATE VIEW orders AS
SELECT customer_name, COUNT(customer_name) AS customer_order_count 
FROM sales_2024 
GROUP BY customer_name;

DROP VIEW orders;

SELECT customer_name, customer_order_count 
FROM orders 
WHERE customer_order_count > (SELECT AVG(customer_order_count) FROM orders)
GROUP BY customer_name;

-- Решение из лекции этой задачи

CREATE VIEW Highratings
	AS SELECT *
    FROM Customers
    WHERE rating = 
    (SELECT MAX(rating)
    FROM Customers);





-- Пример 1. Вывести список всех сотрудников и указать место в рейтинге по зарплатам
SELECT CONCAT(first_name, ' ', last_name) AS 'ФИО', salary,
DENSE_RANK() OVER(ORDER BY salary DESC) AS rank_salary
FROM lesson3.staff;



-- Пример 2. Вывести список всех сотрудников и указать место в рейтинге по зарплатам, но по каждой должности
SELECT CONCAT(first_name, ' ', last_name) AS 'ФИО', post, salary,
DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary
FROM lesson3.staff;


-- 3. Найти самых высокооплачиваемых сотрудников по каждой должности
SELECT *
FROM (SELECT CONCAT(first_name, ' ', last_name) AS 'ФИО', post, salary, 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary 
	FROM lesson3.staff) AS tab
WHERE rank_salary = 1;


-- 4. Вывести список всех сотрудников, отсортировав по зарплатам в порядке убывания и указать на сколько процентов ЗП меньше, 
-- чем у сотрудника со следующей (по значению) зарплатой

SELECT CONCAT(first_name, ' ', last_name) AS ФИО, post, salary,
LEAD(salary, 1, 0) OVER(ORDER BY salary DESC) AS next_salary, 
ROUND(100 -  ((LEAD(salary, 1, 0) OVER(ORDER BY salary DESC) / salary)  * 100), 2) AS percent_diff
FROM lesson3.staff;


-- 5. Вывести всех сотрудников, сгруппировав по должностям и рассчитать:
-- 1)общую сумму зарплат для каждой должности
-- 2)процентное соотношение каждой зарплаты от общей суммы по должности
-- 3)среднюю зарплату по каждой должности 
-- 4)процентное соотношение каждой зарплаты к средней зарплате по должности Вывести список всех сотрудников и указать 
-- 5)место в рейтинге по зарплатам, но по каждой должности

SELECT CONCAT(first_name, ' ', last_name) AS ФИО, post, salary,
SUM(salary) OVER w AS salary_post,
ROUND(salary / SUM(salary) OVER w * 100, 2) AS percent_sum,
ROUND(AVG(salary) OVER w, 2) AS avg_salary,
ROUND(salary / AVG(salary) OVER w * 100, 2) AS percent_avg,
DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary 
FROM lesson3.staff
WINDOW w AS (PARTITION BY post);


USE lesson5;

DROP TABLE IF EXISTS academic_record;

CREATE TABLE academic_record (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	first_name VARCHAR(30),
    quartal VARCHAR(30),
    subject_name VARCHAR(30),
    grade INT
);

INSERT INTO academic_record (first_name, quartal, subject_name, grade)
values
	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '2 четверть', 'математика', 3),
	('Петя', '3 четверть', 'математика', 4),
	('Петя', '4 четверть', 'физика', 5);

SELECT * FROM academic_record;

-- Задача 1. Получить с помощью оконных функции: средний балл ученика 
-- наименьшую оценку ученика
-- наибольшую оценку ученика
-- сумму всех оценок ученика
-- количество всех оценок ученика

SELECT first_name,
	AVG(grade) OVER w AS grade_avg,
	MIN(grade) OVER w AS grade_min,
	MAX(grade) OVER w AS grade_max,
	SUM(grade) OVER w AS grade_sum,
	COUNT(grade )OVER w AS grade_count
FROM academic_record
WINDOW w AS (PARTITION BY first_name);



-- Задача 2. Получить информацию об оценках Пети по физике по четвертям: 
--  текущая успеваемость 
-- оценка в следующей четверти
-- оценка в предыдущей четверти

SELECT first_name, quartal, subject_name, grade,
	LEAD(grade, 1, 'not grade') OVER w AS next_grade,
    LAG(grade, 1, 'not grade') OVER w AS prev_grade
FROM academic_record
WHERE first_name = 'Петя' AND subject_name = 'физика'
WINDOW w AS (PARTITION BY first_name);


-- Задача 3. Для базы lesson_4 решите :

-- создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id = 1;

-- найдите друзей у  друзей пользователя с id = 1 и поместите выборку в представление; (решение задачи с помощью CTE)

-- найдите друзей у  друзей пользователя с id = 1. (решение задачи с помощью представления “друзья”)

-- WITH
--  cte1 AS (SELECT a, b FROM table1),
--  cte2 AS (SELECT c, d FROM table2)
-- SELECT b, d FROM cte1 JOIN cte2
-- WHERE cte1.a = cte2.c;


-- создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id = 1;

USE lesson4;
CREATE OR REPLACE VIEW messages_user_1 AS
SELECT *
FROM messages
WHERE from_user_id = 1 OR to_user_id = 1;

SELECT * FROM messages_user_1;



-- найдите друзей у друзей пользователя с id = 1 и поместите выборку в представление; (решение задачи с помощью CTE)


CREATE OR REPLACE VIEW friends_of_friends_user_1 AS
WITH friends AS (
	SELECT initiator_user_id AS id
	FROM friend_requests
	WHERE status = 'approved' AND target_user_id = 1
	UNION
	SELECT target_user_id AS id
	FROM friend_requests
	WHERE status = 'approved' AND initiator_user_id = 1
)
SELECT friend_requests.initiator_user_id AS friend_id
FROM friends
JOIN friend_requests ON friend_requests.target_user_id = friends.id
WHERE friend_requests.`status` = 'approved' AND friend_requests.initiator_user_id != 1
UNION
SELECT friend_requests.target_user_id
FROM friends
JOIN friend_requests ON friend_requests.initiator_user_id = friends.id
WHERE friend_requests.`status` = 'approved' AND friend_requests.target_user_id != 1;

SELECT * FROM friends_of_friends_user_1;

# друзья единички
SELECT id FROM( 
	SELECT initiator_user_id AS id
	FROM friend_requests
	WHERE status = 'approved' AND target_user_id = 1
	UNION
	SELECT target_user_id AS id
	FROM friend_requests
	WHERE status = 'approved' AND initiator_user_id = 1
    ) friends_user1;

# Проверяю друзей друзей    
SELECT initiator_user_id, target_user_id, `status`
FROM friend_requests 
WHERE (initiator_user_id IN (3, 4, 10) OR target_user_id IN (3, 4, 10));



-- найдите друзей у друзей пользователя с id = 1. (решение задачи с помощью представления “друзья”)

CREATE OR REPLACE VIEW friend_friends_2 AS
(SELECT initiator_user_id AS id, target_user_id AS friend_id
FROM friend_requests
WHERE status = 'approved'
UNION
SELECT target_user_id, initiator_user_id
FROM friend_requests
WHERE status = 'approved'
);

SELECT * FROM friend_friends_2
WHERE id = 1 OR friend_id = 1;

SELECT friend_requests.initiator_user_id AS friend_id
FROM friend_friends_2 AS fr2
JOIN friend_requests ON friend_requests.target_user_id = fr2.friend_id
WHERE friend_requests.`status` = 'approved' AND friend_requests.initiator_user_id != 1 AND fr2.id = 1
UNION
SELECT friend_requests.target_user_id
FROM friend_friends_2 AS fr2
JOIN friend_requests ON friend_requests.initiator_user_id = fr2.id
WHERE friend_requests.`status` = 'approved' AND friend_requests.target_user_id != 1 AND fr2.friend_id = 1;




-- ДЗ

-- Задача 1

USE lesson4;

SELECT DENSE_RANK() OVER(ORDER BY COUNT(messages.id) DESC) AS message_rank,
users.first_name, users.last_name, COUNT(messages.id) AS count_messages
FROM users 
LEFT JOIN messages 
ON users.id = messages.from_user_id
GROUP BY users.id;





-- Задача 2

SELECT id, created_at, 
LEAD(created_at, 1) OVER(),
TIMESTAMPDIFF(MINUTE, created_at, LEAD(created_at, 1) OVER())
FROM messages
ORDER BY created_at;



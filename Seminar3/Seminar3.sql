CREATE DATABASE lesson3;
#ALTER DATABASE lesson3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci; 
USE lesson3;

CREATE TABLE staff (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    post VARCHAR(50) NOT NULL,
    seniority INT UNSIGNED NOT NULL,
    salary INT UNSIGNED NOT NULL,
    age INT UNSIGNED NOT NULL
);

INSERT INTO staff (first_name, last_name, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 19),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Иван', 'Иванов', 'Рабочий', '40', 30000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49);


-- ORDER BY. Задачи Выведите все записи, отсортированные по полю "age" по возрастанию

SELECT * FROM staff ORDER BY age;

-- Выведите все записи, отсортированные по полю “firstname"

SELECT * FROM staff ORDER BY first_name;

-- Выведите записи полей "firstname ", “lastname", "age", отсортированные по полю "firstname " в алфавитном порядке по убыванию

SELECT first_name, last_name, age FROM staff 
ORDER BY first_name DESC;

-- Выполните сортировку по полям " firstname " и "age" по убыванию

SELECT * FROM staff ORDER BY first_name DESC, age DESC;




-- DISTINCT, LIMIT. Задачи 1. Выведите уникальные (неповторяющиеся) значения полей "firstname"

SELECT DISTINCT first_name FROM staff;

-- 2. Отсортируйте записи по возрастанию значений поля "id". Выведите первые две записи данной выборки

SELECT * FROM staff ORDER BY id
LIMIT 2;

--  3. Отсортируйте записи по возрастанию значений поля "id". Пропустите первые 4 строки данной выборки и извлеките следующие 3

SELECT * FROM staff ORDER BY id
LIMIT 4,3;

SELECT * FROM staff ORDER BY id
LIMIT 3 OFFSET 4;

-- 4. Отсортируйте записи по убыванию поля "id". Пропустите две строки данной выборки и извлеките следующие за ними 3 строки

SELECT * FROM staff ORDER BY id DESC
LIMIT 2,3;




-- Агрегатные функции. Задачи 1. Найдите количество сотрудников с должностью «Рабочий»

SELECT COUNT(*) AS workers_count FROM staff
WHERE post = 'Рабочий';

-- 2. Посчитайте ежемесячную зарплату начальников

SELECT SUM(salary) AS cheifs_salary_sum 
FROM staff
WHERE post = 'Начальник';

-- 3. Выведите средний возраст сотрудников, у которых заработная плата больше 30000

SELECT AVG(age) AS average_age
FROM staff
WHERE salary > 30000;

-- 4. Выведите максимальную и минимальную заработные платы

SELECT MAX(SALARY), MIN(SALARY) FROM staff;






CREATE TABLE activity_staff (
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	staff_id INT NOT NULL,
	date_activity DATE NOT NULL,
	count_page INT UNSIGNED NOT NULL,
	FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO activity_staff (staff_id, date_activity, count_page)
VALUES
(1, '2022-01-01', 250),
(2, '2022-01-01', 220),
(3, '2022-01-01', 170),
(1, '2022-01-02', 100),
(2, '2022-01-02', 220),
(3, '2022-01-02', 300),
(7, '2022-01-02', 350),
(1, '2022-01-03', 168),
(2, '2022-01-03', 62),
(3, '2022-01-03', 84);



-- GROUP BY. Задачи\

-- 1. Выведите общее количество напечатанных страниц каждым сотрудником

SELECT staff_id, SUM(count_page) AS total_pages FROM activity_staff 
GROUP BY staff_id;

-- 2. Посчитайте количество страниц за каждый день

SELECT date_activity, SUM(count_page) AS total_pages FROM activity_staff 
GROUP BY date_activity;


-- 3. Найдите среднее арифметическое по количеству страниц, напечатанных сотрудниками за каждый день

SELECT date_activity, ROUND(AVG(count_page)) AS averege_count_pages FROM activity_staff 
GROUP BY date_activity;
-- ROUND для округления значения



-- Сгруппируйте данные о сотрудниках по возрасту:
-- 1 группа – младше 20 лет
-- 2 группа – от 20 до 40 лет
-- 3 группа – старше 40 лет
-- Для каждой группы найдите суммарную зарплату

-- как сделал я (потом на семинаре вторым вариантом это сделали, но почему то решили SUM(salary) 
-- после CASE написать):
SELECT SUM(salary),
CASE 
	WHEN age < 20 THEN 'Группа 1 (младше 20 лет)'
    WHEN age >= 20 AND age <= 40 THEN 'Группа 2 (от 20 до 40 лет)'
    WHEN age > 40 THEN 'Группа 3 (старше 40 лет)'
    ELSE 'Возраст неизвестен'
END AS age_group
FROM staff
GROUP BY age_group;

-- как сделали на семинаре (с вложенным запросом):

SELECT name_age, SUM(salary)
FROM (SELECT salary,
	CASE 
		WHEN age < 20 THEN 'Группа 1 (младше 20 лет)'
		WHEN age >= 20 AND age <= 40 THEN 'Группа 2 (от 20 до 40 лет)'
		WHEN age > 40 THEN 'Группа 3 (старше 40 лет)'
		ELSE 'Возраст неизвестен'
	END AS name_age
	FROM staff) AS table_name_age
GROUP BY name_age;





-- HAVING. Задачи 1. Выведите id сотрудников, которые напечатали более 500 страниц за все дни

SELECT staff_id, SUM(count_page) AS total_pages
FROM activity_staff
GROUP BY staff_id
HAVING SUM(count_page) > 500;

-- 2. Выведите дни, когда работало более 3 сотрудников Также укажите кол-во сотрудников, которые работали в выбранные дни.

SELECT date_activity, COUNT(*) AS workers
FROM activity_staff
GROUP BY date_activity
HAVING workers > 3;

-- 3. Выведите должности, у которых средняя заработная плата составляет более 30000

SELECT post, AVG(salary) AS avg_salary
FROM staff
GROUP BY post
HAVING avg_salary > 30000;

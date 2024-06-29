-- Задание 1

DROP DATABASE IF EXISTS lesson1;
CREATE DATABASE lesson1;

#ALTER DATABASE lesson1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci; 

USE lesson1;

DROP TABLE IF EXISTS students;
CREATE TABLE students(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name_student VARCHAR(45) NOT NULL,
email VARCHAR(45) NOT NULL,
phone BIGINT UNSIGNED
);

DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers (
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name_teacher VARCHAR(45) NOT NULL,
post VARCHAR(45) NOT NULL
);

DROP TABLE IF EXISTS courses;
CREATE TABLE courses (
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name_course VARCHAR(45) NOT NULL,
name_teacher VARCHAR(45) NOT NULL,
name_student VARCHAR(45) NOT NULL
);

INSERT INTO students (name_student, email, phone)
VALUES
("Миша", "misha@mail.ru", 9876543221),
("Антон", "anton@mail.ru", 9876543222),
("Маша", "masha@mail.ru", 9876543223),
("Паша", "pasha@mail.ru", 9876543224);

INSERT INTO teachers (name_teacher, post)
VALUES
('Иванов И.И.', 'Профессор'),
('Петров П.П.', 'Преподаватель'),
('Сидоров С.С.', 'Доцент');

INSERT INTO courses (name_course, name_teacher, name_student)
VALUES
('БД', 'Иванов И.И.', 'Миша'),
('PHP', 'Петров П.П.', 'Антон'),
('Аналитика', 'Сидоров С.С.', 'Маша');


-- 2. Получить список всех студентов с именем "Антон"

SELECT * FROM students WHERE (name_student = 'Антон');

-- 3. Вывести имя и почту из таблички "Студенты"

SELECT name_student, email FROM students;

-- 4*. Выбрать студентов, имена которых начинаются с буквы «А».

SELECT * FROM students WHERE name_student REGEXP "^А";
-- SELECT * FROM students WHERE name_student LIKE "А%";



-- Итерация №3:


USE lesson1;
DROP TABLE IF EXISTS workers;
CREATE TABLE workers (
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name_worker VARCHAR(45) NOT NULL,
dept VARCHAR(100) COMMENT "Подразделение",
salary INT UNSIGNED
);

INSERT INTO workers (id, name_worker, dept, salary)
VALUES
(100, 'AndreyEx', 'Sales', 5000),
(200, 'Boris', 'IT', 5500),
(300, 'Anna', 'IT', 7000),
(400, 'Anton', 'Marketing', 9500),
(500, 'Dima', 'IT', 6000),
(501, 'Maxs', 'Accounting', NULL);

--  Для заданной БД выполните: 1. Выбрать всех сотрудников, у которых зарплата
-- больше 6000

SELECT * FROM workers WHERE salary > 6000;

-- 2. Покажите всех сотрудников, которые принадлежат к отделу IT.

SELECT * FROM workers WHERE dept = 'IT';

-- 3. Отобразите всех сотрудников, который НЕ принадлежат к отделу IT

SELECT * FROM workers WHERE dept != 'IT';


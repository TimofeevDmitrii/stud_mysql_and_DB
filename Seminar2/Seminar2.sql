/*
Задача 1. Создать сущность с подборкой фильмов (movies). В таблице имеются следующие атрибуты:
id -- уникальный идентификатор фильма,
title -- название фильма
title_eng -- название фильма на английском языке
year_movie -- год выхода
count_min -- длительность фильма в минутах
storyline -- сюжетная линия, небольшое описание фильма
Все поля (кроме title_eng, count_min и storyline) обязательны для заполнения.
Поле id : первичный ключ, который заполняется автоматически.
*/

#id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
/*
Данные для заполнения:

('Игры разума', 'A Beautiful Mind', 2001, 135, 'От всемирной известности до греховных глубин — все это познал на своей шкуре Джон Форбс Нэш-младший. Математический гений, он на заре своей карьеры сделал титаническую работу в области теории игр, которая перевернула этот раздел математики и практически принесла ему международную известность. Однако буквально в то же время заносчивый и пользующийся успехом у женщин Нэш получает удар судьбы, который переворачивает уже его собственную жизнь.'),
('Форрест Гамп', 'Forrest Gump', 1994, 142, 'Сидя на автобусной остановке, Форрест Гамп — не очень умный, но добрый и открытый парень — рассказывает случайным встречным историю своей необыкновенной жизни. С самого малолетства парень страдал от заболевания ног, соседские мальчишки дразнили его, но в один прекрасный день Форрест открыл в себе невероятные способности к бегу. Подруга детства Дженни всегда его поддерживала и защищала, но вскоре дороги их разошлись.'),
('Иван Васильевич меняет профессию', NULL, 1998, 128,'Инженер-изобретатель Тимофеев сконструировал машину времени, которая соединила его квартиру с далеким шестнадцатым веком - точнее, с палатами государя Ивана Грозного. Туда-то и попадают тезка царя пенсионер-общественник Иван Васильевич Бунша и квартирный вор Жорж Милославский. На их место в двадцатом веке «переселяется» великий государь. Поломка машины приводит ко множеству неожиданных и забавных событий...'),
('Назад в будущее', 'Back to the Future', 1985, 116, 'Подросток Марти с помощью машины времени, сооружённой его другом-профессором доком Брауном, попадает из 80-х в далекие 50-е. Там он встречается со своими будущими родителями, ещё подростками, и другом-профессором, совсем молодым.'),
('Криминальное чтиво', 'Pulp Fiction', 1994, 154, NULL);
*/

CREATE DATABASE lesson2;
USE lesson2;
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
	id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    title_eng VARCHAR(50),
    year_movie YEAR NOT NULL,
    count_min INT UNSIGNED NOT NULL,
    story_line TEXT
    );

INSERT INTO movies (title, title_eng, year_movie, count_min, story_line)
VALUES
('Игры разума', 'A Beautiful Mind', 2001, 135, 'От всемирной известности до греховных глубин — все это познал на своей шкуре Джон Форбс Нэш-младший. Математический гений, он на заре своей карьеры сделал титаническую работу в области теории игр, которая перевернула этот раздел математики и практически принесла ему международную известность. Однако буквально в то же время заносчивый и пользующийся успехом у женщин Нэш получает удар судьбы, который переворачивает уже его собственную жизнь.'),
('Форрест Гамп', 'Forrest Gump', 1994, 142, 'Сидя на автобусной остановке, Форрест Гамп — не очень умный, но добрый и открытый парень — рассказывает случайным встречным историю своей необыкновенной жизни. С самого малолетства парень страдал от заболевания ног, соседские мальчишки дразнили его, но в один прекрасный день Форрест открыл в себе невероятные способности к бегу. Подруга детства Дженни всегда его поддерживала и защищала, но вскоре дороги их разошлись.'),
('Иван Васильевич меняет профессию', NULL, 1998, 128,'Инженер-изобретатель Тимофеев сконструировал машину времени, которая соединила его квартиру с далеким шестнадцатым веком - точнее, с палатами государя Ивана Грозного. Туда-то и попадают тезка царя пенсионер-общественник Иван Васильевич Бунша и квартирный вор Жорж Милославский. На их место в двадцатом веке «переселяется» великий государь. Поломка машины приводит ко множеству неожиданных и забавных событий...'),
('Назад в будущее', 'Back to the Future', 1985, 116, 'Подросток Марти с помощью машины времени, сооружённой его другом-профессором доком Брауном, попадает из 80-х в далекие 50-е. Там он встречается со своими будущими родителями, ещё подростками, и другом-профессором, совсем молодым.'),
('Криминальное чтиво', 'Pulp Fiction', 1994, 154, NULL);

CREATE TABLE genres (
	id SERIAL PRIMARY KEY,
    genre_name VARCHAR(40) NOT NULL
    );


#Задние 2. Операции с таблицами. Задачи:

USE lesson2;
-- 1) Переименовать сущность movies в cinema.
RENAME TABLE movies TO cinema;
-- 2) Добавить сущности cinema новый атрибут status_active (тип BIT) и атрибут genre_id после атрибута title_eng.
ALTER TABLE cinema
ADD status_active BIT DEFAULT b'1',
ADD genre_id BIGINT UNSIGNED AFTER title_eng;
-- 3) Удалить атрибут status_active сущности cinema.
ALTER TABLE cinema
DROP COLUMN status_active;
-- 4) Удалить сущность actors из базы данных
DROP TABLE actors;
-- 5) Добавить внешний ключ на атрибут genre_id сущности cinema и направить его на атрибут id сущности genres.
ALTER TABLE cinema
ADD FOREIGN KEY (genre_id) REFERENCES genres(id);

-- 6) Очистить сущность genres от данных и обнулить автоинкрементное поле.

INSERT INTO genres (genre_name)
VALUES
('triller'),
('comedy');

ALTER TABLE cinema
DROP FOREIGN KEY cinema_ibfk_1; -- удаляем внешнюю зависимость перед очищением таблицы genres

TRUNCATE TABLE genres; -- очищаем таблицу и обнуляем автоинкремент


-- Задание 3. Выведите id, название фильма _x000b_и категорию фильма, согласно следующего _x000b_перечня: _x000b_Д- Детская, П – Подростковая, _x000b_В – Взрослая, Не указана


ALTER TABLE cinema
ADD COLUMN age_category CHAR(1); 

UPDATE cinema SET age_category = 'П' WHERE id = 1;
UPDATE cinema SET age_category = 'Д' WHERE id = 4;
UPDATE cinema SET age_category = 'В' WHERE id = 5;

UPDATE cinema SET age_category = 'Н' WHERE id NOT IN (1, 4, 5);

SELECT 
    id AS номер_фильма, 
    title AS название_фильма,
    CASE
        WHEN age_category = 'П' THEN 'Подростковый'
        WHEN age_category = 'Д' THEN 'Детский'
        WHEN age_category = 'В' THEN 'Взрослый'
        ELSE 'Не указано'
	END AS категория
FROM cinema; 

/*SELECT 
    id AS номер_фильма, 
    title AS название_фильма,
    CASE age_category
        WHEN 'П' THEN 'Подростковый'
        WHEN 'Д' THEN 'Детский'
        WHEN 'В' THEN 'Взрослый'
        ELSE 'Не указано'
	END AS категория
FROM cinema; */
-- Задача 4. Выведите id, название фильма, продолжительность, тип в зависимости от продолжительности (с использованием CASE). 
-- До 50 минут - Короткометражный фильм
-- От 50 минут до 100 минут - Среднеметражный фильм
-- Более 100 минут - Полнометражный фильм
-- Иначе - Не определено
SELECT 
    id AS номер_фильма, 
    title AS название_фильма,
    count_min AS продолжительность,
    CASE
        WHEN count_min < 120 THEN 'Короткометражный фильм'
        WHEN count_min >=120  and count_min <= 140 THEN 'Среднеметражный фильм'
        -- WHEN count_min BETWEEN 120 and 140 THEN 'Среднеметражный фильм'
        WHEN count_min > 140 THEN 'Полнометражный фильм'
        ELSE 'Не определено'
    END AS Тип
FROM cinema; 


-- То же задание, но с IF

SELECT 
    id AS номер_фильма, 
    title AS название_фильма,
    count_min AS продолжительность,
    IF (count_min < 120, 'Короткометражный фильм',
        IF (count_min >= 120 and count_min <= 140,'Среднеметражный фильм',
            IF (count_min > 140, 'Полнометражный фильм', 'Не определено')
		)
	) AS Тип
FROM cinema; 
    
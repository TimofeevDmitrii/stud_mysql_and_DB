USE lesson4;

UPDATE profiles
SET hometown = 'Adriannaport'
WHERE birthday < '1990-01-01'
LIMIT 2; -- без limit не будет работать, т.к. включен безопасный режим редактирования;
-- необходимо либо использовать в WHERE первичный ключ, либо LIMIT, либо отключить режим безопасного редактирования.
-- SET SQL_SAFE_UPDATES = 0;

UPDATE profiles
SET hometown = 'Adriannaport'
WHERE user_id IN (4,10,6);


-- Задача 1. Создайте процедуру, которая выберет для одного пользователя 5 пользователей в случайной комбинации,
-- которые удовлетворяют хотя бы одному критерию:
-- 1) из одного города
-- 2) состоят в одной группе
-- 3) друзья друзей

DROP PROCEDURE IF EXISTS users_random;
DELIMITER $$
CREATE PROCEDURE users_random(for_user_id BIGINT)
BEGIN
	WITH friends AS (
		SELECT initiator_user_id AS id
		FROM friend_requests
		WHERE status = 'approved' AND target_user_id = for_user_id
		UNION
		SELECT target_user_id AS id
		FROM friend_requests
		WHERE status = 'approved' AND initiator_user_id = for_user_id
		)
	-- Общий город
	SELECT pr2.user_id
	FROM `profiles` AS pr1
	JOIN `profiles` AS pr2 ON pr1.hometown = pr2.hometown
	WHERE pr1.user_id = for_user_id AND pr2.user_id != for_user_id
	UNION
	-- Общая группа
	SELECT u2.community_id
	FROM users_communities AS u1
	JOIN users_communities AS u2 ON u1.community_id = u2.community_id
	WHERE u1.user_id = for_user_id AND u2.user_id != for_user_id
	UNION
	-- друзья друзей
	SELECT friend_requests.initiator_user_id
	FROM friends
	JOIN friend_requests ON friend_requests.target_user_id = friends.id
	WHERE friend_requests.`status` = 'approved' AND friend_requests.initiator_user_id != for_user_id
	UNION
	SELECT friend_requests.target_user_id
	FROM friends
	JOIN friend_requests ON friend_requests.initiator_user_id = friends.id
	WHERE friend_requests.`status` = 'approved' AND friend_requests.target_user_id != for_user_id
	ORDER BY RAND()
	LIMIT 5;
END $$
DELIMITER ;
CALL users_random(1);


-- Задача 2. Создание функции, вычисляющей коэффициент популярности пользователя
-- (по заявкам на дружбу – таблица friend_requests)

DROP FUNCTION IF EXISTS friend_direction;
DELIMITER &&
CREATE FUNCTION friend_direction(check_user_id BIGINT)
RETURNS FLOAT READS SQL DATA
BEGIN
	DECLARE count_to_user INT;
	DECLARE count_from_user INT;
	SET count_from_user = (SELECT COUNT(*) FROM friend_requests WHERE check_user_id = initiator_user_id);
	SET count_to_user = (SELECT COUNT(*) FROM friend_requests WHERE check_user_id = target_user_id) ;
	RETURN count_to_user / count_from_user;
END
&& DELIMITER ;
SELECT CONCAT(CONVERT(ROUND(friend_direction(1) * 100, 2), CHAR), '%') AS friend_direction;



-- Задача 3. Необходимо перебрать всех пользователей и тем пользователям,
-- у которых дата рождения меньше определенной даты обновить дату рождения на сегодняшнюю дату.
-- (реализация с помощью цикла)


DROP PROCEDURE IF EXISTS date_analysis;
DELIMITER &&
CREATE PROCEDURE date_analysis(start_date DATE)
BEGIN
DECLARE id_max_users INT;
SET id_max_users = (SELECT MAX(user_id) FROM `profiles`);
WHILE (id_max_users != 0) DO
	BEGIN
	IF(id_max_users IN (SELECT user_id FROM `profiles` WHERE birthday < start_date)) THEN
	UPDATE `profiles`
	SET birthday = NOW()
	WHERE user_id = id_max_users;
	END IF;
	SET id_max_users = id_max_users - 1;
	END;
END WHILE;
END
&& DELIMITER ;

CALL date_analysis('1983-01-01');
SELECT * FROM `profiles`;




-- ДЗ (промежуточная аттестация)
-- 1. Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней часов.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

DROP FUNCTION IF EXISTS convert_seconds;
DELIMITER $$
CREATE FUNCTION convert_seconds(seconds INT)
RETURNS VARCHAR(45) READS SQL DATA
BEGIN
	DECLARE dd INT;
	DECLARE hh INT;
	DECLARE mm INT;
	SET dd = FLOOR(seconds/60/60/24);
    IF (dd != 0) THEN
		SET seconds = seconds - dd*3600*24;
	END IF;
	SET hh = FLOOR(seconds/60/60);
    IF (hh != 0) THEN
		SET seconds = seconds - hh*3600;
	END IF;
	SET mm = FLOOR(seconds/60);
    IF (mm != 0) THEN
		SET seconds = seconds - mm*60;
	END IF;
	RETURN CONCAT(dd, ' days ', hh, ' hours ', mm, ' minutes ', seconds, ' seconds');
END
$$ DELIMITER ;

SELECT convert_seconds(123456);
SELECT convert_seconds(1465689);
SELECT convert_seconds(86486);
SELECT convert_seconds(3456);



-- 2. Выведите только чётные числа от 1 до 10
-- Пример: 2,4,6,8,10

DROP PROCEDURE even_nums_1_10;
DELIMITER $$
CREATE PROCEDURE even_nums_1_10()
BEGIN
DECLARE count INT DEFAULT 1;
DECLARE result VARCHAR(20) DEFAULT '';
WHILE count <= 10 DO 
	BEGIN
	IF(count % 2 = 0) THEN
		IF (result != '') THEN
			SET result = CONCAT(result, ', ');
        END IF;
		SET result = CONCAT(result, count);
	END IF;
	SET count= count + 1;
	END;
END WHILE;
SELECT result;
END 
$$ DELIMITER ;



CALL even_nums_1_10();


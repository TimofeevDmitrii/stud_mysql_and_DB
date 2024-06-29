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
QUERY sol1:
DELIMITER //
CREATE OR REPLACE PROCEDURE sol1
(priceHelp INT)
BEGIN
    SELECT model FROM pc ORDER BY ABS(price - priceHelp) LIMIT 1; 
END;
//
CALL sol1(2000);


QUERY sol2:
DELIMITER //
CREATE OR REPLACE PROCEDURE sol2
(sMaker VARCHAR(30), sModel INT)
BEGIN
    DECLARE sType VARCHAR(20);
    SELECT product.type INTO sType FROM product WHERE product.maker = sMaker AND product.model = sModel;
    IF sType = 'pc'
        THEN
            SELECT price FROM product 
            INNER JOIN pc ON pc.model = product.model 
            WHERE product.model = sModel AND product.maker = sMaker;
    ELSEIF sType = 'laptop'
        THEN
            SELECT price FROM product 
            INNER JOIN laptop ON laptop.model = product.model 
            WHERE product.model = sModel AND product.maker = sMaker;
    ELSE
        SELECT price FROM product 
        INNER JOIN printer ON printer.model = product.model 
        WHERE product.model = sModel AND product.maker = sMaker;        
    END IF;
END;
//
CALL sol2('A', 2001);

QUERY sol3:

#Ohne Error Handler
DELIMITER //
CREATE OR REPLACE PROCEDURE sol3
(iModel INT, iSpeed INT, iRam INT, `ihard-disk` INT, iPrice FLOAT)
BEGIN
	DECLARE maxModel INT;
	DECLARE modelCounter INT;
	SET modelCounter = iModel;
	SELECT MAX(model) INTO maxModel FROM pc;
	while modelCounter <= maxModel DO
		SET modelCounter = modelCounter + 1;
	END WHILE;
	INSERT INTO pc (model, speed, ram, `hard-disk`, price) 
      VALUES (modelCounter, iSpeed, iRam, `ihard-disk`, iPrice);
END;
//
CALL sol3(1001,23,23,2,323);

#Rekurisiv mit Error Handler
DELIMITER //
SET max_sp_recursion_depth=255;
CREATE OR REPLACE PROCEDURE sol3_2
(iModel INT, iSpeed INT, iRam INT, `ihard-disk` INT, iPrice FLOAT)
BEGIN
	
	DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
		CALL sol3_2(iModel+1, iSpeed, iRam, `ihard-disk`, iPrice);
	INSERT INTO pc (model, speed, ram, `hard-disk`, price) 
      VALUES (iModel, iSpeed, iRam, `ihard-disk`, iPrice);
END;
//

CALL sol3_2(1001,21232133,23,2,323);

#Iterativ mit Error Handler
DELIMITER //
CREATE OR REPLACE PROCEDURE sol3_3
(iModel INT, iSpeed INT, iRam INT, `ihard-disk` INT, iPrice FLOAT)
BEGIN
	DECLARE modelCounter INT;
	DECLARE inserted BOOLEAN;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' 
	BEGIN 
		SET modelCounter = modelCounter + 1;
		SET inserted = FALSE;
	END;
	SET modelCounter = iModel;

 	l: LOOP
		SET inserted = TRUE;
		INSERT INTO pc (model, speed, ram, `hard-disk`, price) 
      		VALUES (modelCounter, iSpeed, iRam, `ihard-disk`, iPrice);
      IF inserted = TRUE THEN
      	LEAVE l;
      END IF;
	END Loop l;
	
END;
//
CALL sol3_3(1001,3,2123213,2,323);

QUERY sol4:
DELIMITER //
CREATE OR REPLACE PROCEDURE sol4
(sPrice INT)
BEGIN
	DECLARE countPc INT;
	DECLARE countLa INT;
	DECLARE countPr INT;
	SELECT COUNT(*) INTO countPc FROM pc WHERE pc.price > sPrice;
	SELECT COUNT(*) INTO countLa FROM laptop WHERE laptop.price > sPrice;
	SELECT COUNT(*) INTO countPr FROM printer WHERE printer.price > sPrice;
	SELECT (countPc + countLa + countPr) AS Anzahl;
END;
//
CALL sol4(1000);
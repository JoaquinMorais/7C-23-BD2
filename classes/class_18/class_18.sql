use sakila;


#1 
#Write a function that returns the amount of copies of a film in a store in sakila-db. 
#Pass either the film id or the film name and the store id.

DROP FUNCTION IF EXISTS getCountFilmStore;
DELIMITER //
CREATE FUNCTION getCountFilmStore(FILM_DATA VARCHAR(100), STORE_ID INT) RETURNS INT READS SQL DATA

BEGIN 
    DECLARE film_count INT;

    SELECT
        COUNT(*) INTO film_count
    FROM inventory i
        JOIN film f ON i.film_id = f.film_id
    WHERE (
            f.film_id = film_data
            OR f.title = film_data
        )
        AND i.store_id = store_id;
    RETURN film_count;
    END
//
DELIMITER ;

SELECT getCountFilmStore('ZORRO ARK', 2) as film_count;
SELECT getCountFilmStore(1000, 2) as film_count;


#2
#Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", 
#that live in a certain country. You pass the country it gives you the list of people living there. 
#USE A CURSOR, do not use any aggregation function like CONTCAT_WS.

DROP PROCEDURE IF EXISTS getCustomersCountry;
DELIMITER //
CREATE PROCEDURE getCustomersCountry(
    IN country_name VARCHAR(100), 
    OUT customers_list TEXT
    )
BEGIN
    DECLARE response TEXT DEFAULT '';
    DECLARE separation BOOL DEFAULT FALSE;
    DECLARE customer_first_name VARCHAR(100) DEFAULT '';
    DECLARE customer_last_name VARCHAR(100) DEFAULT '';
    DECLARE done INT DEFAULT 0;

    DECLARE customer_cursor CURSOR FOR
        SELECT first_name, last_name
        FROM customer
            INNER JOIN address a on customer.address_id = a.address_id
            INNER JOIN city ci on a.city_id = ci.city_id
            INNER JOIN country co on ci.country_id = co.country_id
        WHERE co.country = country_name;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN customer_cursor;
    customers_loop:
    LOOP
        FETCH customer_cursor INTO customer_first_name, customer_last_name;
        IF done = 1 THEN
            LEAVE customers_loop;
        end if;

        IF separation = TRUE THEN
            SET response = CONCAT(response, ';');
        end if;

        SET separation = TRUE;

        SET response = CONCAT(response, customer_first_name, ' ', customer_last_name);

    end loop;
    CLOSE customer_cursor;

    SET customers_list = response;

END;
//
DELIMITER ;
CALL getCustomersCountry('Argentina', @result);
SELECT @result;


#3
#Review the function inventory_in_stock and the procedure film_in_stock explain the code, 
#write usage examples.



/* 
La función inventory_in_stock devuelve un valor tinyint (que se puede considerar como un valor de Verdadero o Falso). 
Dentro de esta función, se definen dos variables. 
Una de ellas almacena la cantidad de alquileres (rentals) para una película en particular, 
y la otra almacena la cantidad de alquileres que aún no han sido devueltos 
(es decir, tienen una fecha de retorno faltante) para los elementos con el ID especificado como parámetro.

Si existe al menos un artículo en el inventario que tenga una fecha de retorno (return_date), 
la función devuelve 1 (lo que se considera Verdadero). Por otro lado, 
si ninguno de los artículos en el inventario tiene una fecha de retorno, 
la función devuelve 0 (lo que se considera Falso).
*/

SET @result = inventory_in_stock(10);
SELECT @result;

SET @result = inventory_in_stock(11);
SELECT @result;

SET @result = inventory_in_stock(12);
SELECT @result;




/* 
El procedimiento almacenado film_in_stock devuelve la cantidad de películas que tienen el mismo identificador (ID) 
que se proporciona como parámetro, en la tienda que también se especifica como parámetro. 
En otras palabras, este procedimiento cuenta cuántas copias de una película en particular están disponibles en una tienda específica, 
según el ID de la película y la tienda proporcionados como argumentos.
*/

CALL film_in_stock(1, 1, @result);
SELECT @result;

CALL film_in_stock(2, 2, @result);
SELECT @result;

CALL film_in_stock(2, 3, @result);
SELECT @result;

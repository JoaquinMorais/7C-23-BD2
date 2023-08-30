use sakila;


#1
#Create two or three queries using address table in sakila db:

#include postal_code in where (try with in/not it operator)
#eventually join the table with city/country tables.
#measure execution time.
#Then create an index for postal_code on address table.
#measure execution time again and compare with the previous ones.
#Explain the results


select *
from address


SELECT *
FROM address AS a
    INNER JOIN city c ON a.city_id = c.city_id
    INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code IN ('91400', '91299', '99780', '99865'); -- 73ms


SELECT *
FROM address AS a
    INNER JOIN city c ON a.city_id = c.city_id
    INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('91400', '91299', '99780', '99865'); -- 196ms

CREATE INDEX idx_postal_code ON address (postal_code); -- 96ms

SELECT *
FROM address AS a
    INNER JOIN city c ON a.city_id = c.city_id
    INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code IN ('91400', '91299', '99780', '99865'); -- 56ms


SELECT *
FROM address AS a
    INNER JOIN city c ON a.city_id = c.city_id
    INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('91400', '91299', '99780', '99865');-- 121ms

/* 
A database index, or just index, helps speed up the retrieval of data from tables. 
When you query data from a table, first MySQL checks if the indexes exist, 
then MySQL uses the indexes to select exact physical corresponding rows of the table instead of scanning the whole table.
*/

SELECT *
FROM actor
WHERE first_name = 'PENELOPE';

SELECT *
FROM actor
WHERE last_name = 'GUINESS';

/* 
The difference is practically imperceptible in the execution time 
but there is an index for the last name
 */


ALTER TABLE film
    ADD FULLTEXT (description);

SELECT *
FROM film
WHERE description LIKE '%action%';


SELECT *
FROM film
WHERE MATCH(description) AGAINST('action');

/* 
In terms of performance, in this database it is practically imperceptible.
A FULLTEXT index is designed to efficiently handle queries based on natural language,
that involve searching for words or phrases within the text columns of a table
 */
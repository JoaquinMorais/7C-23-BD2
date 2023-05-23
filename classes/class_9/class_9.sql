use sakila;


/* 1 */
SELECT country.country as Pais, count(city) as Ciudades
FROM country
JOIN city on country.country_id = city.country_id
GROUP BY country.country_id
ORDER BY country.country, count(city);


/* 2 */
SELECT country.country as Pais, count(city) as Ciudades
FROM country
JOIN city on country.country_id = city.country_id
GROUP BY country.country_id
HAVING count(city) >10
ORDER BY count(city) DESC;


/* 3 */
SELECT SUM(p.amount) AS TodaLaPlataGastada, concat(c.last_name, ' ', c.first_name) as nombre, a.address as direccion, COUNT(r.rental_id) as CantPEliculasRentadas
FROM customer c
JOIN address a on c.address_id = a.address_id
JOIN rental r on c.customer_id = r.customer_id
JOIN payment p on c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY TodaLaPlataGastada DESC;


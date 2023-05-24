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
HAVING count(city) > 10
ORDER BY count(city) DESC;


/* 3 */
SELECT concat(c.last_name, ' ', c.first_name) as ApellidoNombre, a.address as direccion, 
(
    select count(*) 
    from rental 
    where customer_id = c.customer_id
) as PeliculasRentadas, 
(
    select SUM(p.amount) 
    from rental r
    join payment p on r.rental_id = p.rental_id
    where r.customer_id = c.customer_id
    GROUP by r.customer_id
) as TodaLaPlataGastada
FROM customer c
JOIN address a on c.address_id = a.address_id
GROUP BY c.customer_id
ORDER BY TodaLaPlataGastada DESC;



/* 4 */
SELECT c.name as Categoria, AVG(f.length) as DuracionPromedio
FROM film_category fc
JOIN category c on fc.category_id = c.category_id
JOIN film f on fc.film_id = f.film_id 
GROUP BY c.category_id
ORDER BY DuracionPromedio DESC;


/* 5 */
SELECT f.rating as ClasificacionFCBM, count(r.rental_id) as CantVentas, SUM(p.amount) as PrecioTotalVentas
FROM film f
JOIN inventory i on f.film_id = i.film_id
JOIN rental r on i.inventory_id = r.inventory_id
JOIN payment p on r.rental_id = p.rental_id
GROUP BY f.rating;
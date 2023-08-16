use sakila;

#### 1 #####
#Write a query that gets all the customers that live in Argentina. 
#Show the first and last name in one column, the address and the city.

SELECT CONCAT(C.first_name,' ', C.last_name) as name, A.address as address, Ci.city as city
FROM customer C
join address A using(address_id)
join city Ci using(city_id)
join country Co using(country_id) 
where Co.country = 'ARGENTINA';


#### 2 ####
#Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here:

select F.title,
(
    select name from language L where F.language_id = L.language_id limit 1
) as language,
case
when F.rating = 'G'
then 'G (GENERAL AUDIENCES) – ALL AGES ADMITTED.'
when F.rating = 'PG'
then 'PG (PARENTAL GUIDANCE SUGGESTED) – SOME MATERIAL MAY NOT BE SUITABLE FOR CHILDREN.'
when F.rating = 'PG-13'
then 'PG-13 (PARENTS STRONGLY CAUTIONED) – SOME MATERIAL MAY BE INAPPROPRIATE FOR CHILDREN UNDER 13.'
when F.rating = 'R' 
then 'R (RESTRICTED) – UNDER 17 REQUIRES ACCOMPANYING PARENT OR ADULT GUARDIAN.'
when F.rating = 'NC-17' 
then 'NC-17 (ADULTS ONLY) – NO ONE 17 AND UNDER ADMITTED.'
end as rating
from film F; 

#### 3 ####
#Write a search query that shows all the films (title and release year) an actor was part of. 
#Assume the actor comes from a text box introduced by hand from a web page. 
#Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

select (
    select title from film f where f.film_id = fa.film_id
) as title,
(
    select release_year from film f where f.film_id = fa.film_id
) as release_year
from film_actor fa
where fa.actor_id in (
    select actor_id from actor
    where first_name = 'LAURA'
    and last_name = 'BRODY'
)
group by fa.film_id
;
 

#### 4 ####
Find all the rentals done in the months of May and June. 
Show the film title, customer name and if it was returned or not. 
There should be returned column with two possible values 'Yes' and 'No'.

select F.title as title,
CONCAT(C.first_name,' ',C.last_name) as customer_name,
case
when return_date > NOW() then 'No'
when return_date <= NOW() then 'Yes'
end as is_return
from rental
join customer C using(customer_id)
join inventory I using(inventory_id)
join film F using(film_id)
where MONTH(rental_date) = '05'
or MONTH(rental_date) = '06';


#### 5 ####
#Investigate CAST and CONVERT functions. 
#Explain the differences if any, write examples based on sakila DB.

#CAST
#La función CAST se utiliza para convertir un valor de un tipo de datos a otro de manera explícita. 
#Esto puede ser útil cuando deseas asegurarte de que un valor se interprete y almacene en una columna 
#con un tipo de datos específico.
#Por ejemplo, si tienes un número decimal y deseas convertirlo en un número entero, puedes usar CAST para lograrlo:

SELECT title, CONVERT(release_year, CHAR) AS release_year_string
FROM film
WHERE film_id = 10;

#CONVERT:
#La función CONVERT también se utiliza para convertir valores de un tipo de datos a otro. 
#Sin embargo, su uso es un poco más genérico y es compatible con varios sistemas de bases de datos, no solo MySQL.
#Un ejemplo común es cuando deseas convertir un valor numérico en una cadena (texto). 
#Puedes usar CONVERT de la siguiente manera:

SELECT CONVERT(12345, CHAR) AS numero_como_cadena;



#### 6 ####
#Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. 
#Explain what they do. Which ones are not in MySql and write usage examples.

#NVL:
#La función NVL es específica de Oracle y se utiliza para reemplazar un valor nulo por otro valor. 
#Si la expresión no es nula, se devuelve la expresión original; 
#de lo contrario, se devuelve el valor de reemplazo.
#Un ejemplo podria ser:
"""
SELECT NVL(title, 'Without title') AS title_modify 
FROM film;
"""

#ISNULL:
#La función ISNULL se utiliza en Microsoft SQL Server y T-SQL. 
#Devuelve el primer valor si no es nulo; de lo contrario, devuelve el segundo valor. Su sintaxis es:
"""
SELECT ISNULL(title, 'stranger_film') AS title_modify
FROM film;
"""

#IFNULL:
#La función IFNULL es específica de MySQL y se utiliza para evaluar si una expresión es nula y, 
#si lo es, devuelve un valor de reemplazo; de lo contrario, devuelve la expresión original.
#Un ejemplo seria:

SELECT IFNULL(title, 'stranger_film') AS title_modify
FROM film;

#COALESCE:
#La función COALESCE es más genérica y ampliamente compatible con diferentes sistemas de bases de datos, 
#incluyendo Oracle, SQL Server, MySQL y otros. 
#Devuelve el primer valor no nulo de una lista de expresiones.
#Un ejemplo seria:

SELECT COALESCE(address, address2, 'Without address') AS address_modify
FROM address;







#### 1 ####
#Create a view named list_of_customers, it should contain the following columns:
#customer id
#customer full name,
#address
#zip code
#phone
#city
#country
#status (when active column is 1 show it as 'active', otherwise is 'inactive')
#store id


CREATE OR REPLACE VIEW list_of_customers AS
SELECT c.customer_id as 'customer_id',
concat(c.first_name, ' ' ,c.last_name) as 'customer_full_name',
a.address as 'address',
a.postal_code as 'zip_code',
a.phone as 'phone',
ci.city as 'city',
co.country as 'country',
CASE WHEN c.active = 1 THEN 'active' ELSE 'inactive' END as 'status',
c.store_id as 'store_id'
FROM customer c
JOIN address a USING(address_id)
JOIN city ci USING(city_id)
JOIN country co USING(country_id)
;
select * from list_of_customers;


#### 2 ####
#Create a view named film_details, it should contain the following columns:
#film id, title, description, category, price, length, rating, 
#actors - as a string of all the actors separated by comma. 
#Hint use GROUP_CONCAT

CREATE OR REPLACE VIEW film_details AS
SELECT f.film_id 'as film_id',
f.title as 'title',
#f.description as 'description',
(
    select c.name from category c where fc.category_id = c.category_id
) as 'category',
f.rental_rate AS 'price',
f.length as 'lenght',
f.rating as 'rating',
(
    select GROUP_CONCAT(DISTINCT 
    (
        select concat(a.first_name, ' ' ,a.last_name) from actor a where a.actor_id = fa.actor_id
    )  SEPARATOR ', ') 
    from film_actor fa where fa.film_id = f.film_id
) as 'actors'
FROM film f
JOIN film_category fc USING(film_id)
;

select * from film_details;


#### 3 ####
#Create view sales_by_film_category, it should return 'category' and 'total_rental' columns
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT 
c.name AS 'category',
SUM(p.amount) AS 'total_rental'
FROM
film f
JOIN film_category fc USING(film_id)
JOIN category c USING(category_id)
JOIN inventory i USING(film_id)
JOIN rental r USING(inventory_id)
JOIN payment p USING(rental_id)
GROUP BY
c.name;

SELECT * FROM sales_by_film_category;



#### 4 ####
#Create a view called actor_information where it should return, 
actor id, first name, last name and the amount of films he/she acted on.

CREATE or REPLACE VIEW actor_information AS
SELECT
a.actor_id as 'actor_id',
a.first_name as 'first_name',
a.last_name as 'last_name',
(
    select count(*) from film_actor fa where fa.actor_id = a.actor_id 
)
from actor a;

select * from actor_information;


#### 5 ####
1. CREATE or REPLACE VIEW actor_information AS: Esta línea crea una vista llamada "actor_information" o la reemplaza si ya existe. Las vistas son consultas almacenadas que se pueden usar para acceder a los datos como si fueran tablas, lo que facilita la consulta y el uso de datos complejos o frecuentemente necesarios.
2. SELECT: Esta es la cláusula que indica que queremos seleccionar datos de una o varias tablas.
3. a.actor_id as 'actor_id': Estamos seleccionando el campo "actor_id" de la tabla "actor" y lo estamos renombrando como "actor_id". El "a" antes de "actor_id" es un alias que se utiliza para abreviar el nombre de la tabla y facilitar la lectura del código.
4. a.first_name as 'first_name': Seleccionamos el campo "first_name" de la tabla "actor" y lo renombramos como "first_name".
5. a.last_name as 'last_name': Seleccionamos el campo "last_name" de la tabla "actor" y lo renombramos como "last_name".
6. select count(*) from film_actor fa where fa.actor_id = a.actor_id: Esta subconsulta cuenta la cantidad de registros en la tabla "film_actor" donde el "actor_id" coincide con el "actor_id" de la tabla "actor" (tabla externa). En otras palabras, esta subconsulta cuenta cuántas películas ha protagonizado cada actor.
7. from actor a;: Finalmente, estamos seleccionando los datos de la tabla "actor" y usando el alias "a" para referirnos a ella. En este punto, también hemos agregado la subconsulta que cuenta la cantidad de películas para cada actor.

#### 6 ####
/*
**Descripción de las Vistas Materializadas:**
Una vista materializada es un objeto de base de datos que almacena los resultados de una consulta como una tabla física, representando los datos extraídos de una o más tablas fuente. A diferencia de las vistas regulares, que son virtuales y no almacenan datos por sí mismas, las vistas materializadas están precalculadas y se actualizan periódicamente para garantizar que sus datos estén sincronizados con las tablas fuente subyacentes.

**Sintaxis**
CREATE MATERIALIZED VIEW nombre_de_la_vista
AS
SELECT columnas
FROM tablas
WHERE condiciones
[REFRESH {FAST | COMPLETE | FORCE | ON DEMAND | NEVER}];


**Por qué se utilizan:**
Las vistas materializadas se utilizan por varias razones:
1. **Mejora del rendimiento:** Las vistas materializadas pueden mejorar significativamente el rendimiento de las consultas precalculando y almacenando los resultados de consultas complejas o frecuentemente utilizadas. Esto reduce la necesidad de ejecutar repetidamente consultas costosas en conjuntos de datos grandes.
2. **Agregación y resumen de datos:** A menudo se utilizan para agregar, resumir o transformar datos, lo que permite a los usuarios acceder eficientemente a información resumida sin consultar todo el conjunto de datos.
3. **Procesamiento sin conexión:** Las vistas materializadas se pueden utilizar para el procesamiento y reportes sin conexión, lo que permite una recuperación de datos más rápida con fines analíticos.
4. **Reducción de la carga en las tablas fuente:** Al proporcionar una fuente de datos alternativa, las vistas materializadas pueden reducir la carga en las tablas fuente subyacentes, lo que puede ser crucial en sistemas con alta concurrencia y operaciones de lectura frecuentes.
5. **Soporte para datos remotos:** Las vistas materializadas se pueden utilizar para almacenar datos de bases de datos remotas, lo que facilita el trabajo con sistemas distribuidos.

**Alternativas a las Vistas Materializadas:**
Aunque las vistas materializadas ofrecen beneficios significativos, existen enfoques alternativos para lograr resultados similares:
1. **Vistas Regulares:** Las vistas regulares (no materializadas) son tablas virtuales que representan los resultados de una consulta. A diferencia de las vistas materializadas, no almacenan datos, pero proporcionan una vista actualizada de las tablas subyacentes cada vez que se consultan. Las vistas son más adecuadas cuando se requiere acceso a datos en tiempo real y el costo de recomputar los resultados es aceptable.
2. **Caché:** Almacenar en caché los resultados de consultas en memoria puede mejorar el rendimiento de las consultas al reducir la necesidad de volver a calcular las mismas consultas con frecuencia. Sin embargo, este enfoque puede no ser tan eficiente como las vistas materializadas para conjuntos de datos complejos o grandes.
3. **Indexación:** Crear índices apropiados en columnas consultadas con frecuencia puede mejorar el rendimiento de las consultas sin la necesidad de vistas materializadas. Si bien los índices no almacenan resultados precalculados, proporcionan un acceso más rápido a los datos al optimizar la recuperación de datos.

**SGBD donde existen:** 
Las vistas materializadas son compatibles con varios sistemas de gestión de bases de datos relacionales (SGBD). Algunos SGBD populares donde se pueden encontrar vistas materializadas incluyen:
1. **Oracle Database:** Oracle brinda un sólido soporte para vistas materializadas, ofreciendo varias opciones para su actualización y mantenimiento.
2. **PostgreSQL:** A partir de la versión 9.3, PostgreSQL introdujo soporte para vistas materializadas, lo que permite a los usuarios crearlas y utilizarlas como en otros SGBD.
3. **Microsoft SQL Server:** SQL Server también admite vistas materializadas, llamadas "Vistas Indexadas", que se pueden indexar para mejorar aún más el rendimiento.
4. **IBM Db2:** Db2 admite vistas materializadas como "Tablas de Consulta Materializadas (MQTs)", que proporcionan una funcionalidad similar.
5. **MySQL:** Hasta mi última actualización de conocimientos en septiembre de 2021, MySQL no tenía soporte incorporado para vistas materializadas. Sin embargo, es posible que algunas soluciones y extensiones de terceros ofrezcan una funcionalidad similar.
/*



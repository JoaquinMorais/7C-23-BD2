use sakila;

/* 1 */
select title,special_features,rating from film;

/* 2 */
select distinct length as DuracionPelicula from film order by length;

/* 3 */
select title,rental_rate,replacement_cost from film where replacement_cost between 20.00 and 24.00;

/* 4 */
select F.title as 'TituloPelicula',C.name as 'Categoria', F.special_features as 'CaracteristicasEspeciales' from film F
join film_category FC on F.film_id = FC.film_id
join category C on FC.category_id = C.category_id
where F.special_features = 'Behind the Scenes';

/* 5 */
select A.actor_id as 'IdActor',A.first_name as 'Nombre',A.last_name as 'Apellido' from actor A 
join film_actor AC on A.actor_id = AC.actor_id
join film F on AC.film_id = F.film_id
where F.title = 'ZOOLANDER FICTION';

/* 6 */
select S.store_id,A.address as 'Direccion',Ci.city as 'Ciudad',Co.country as 'Pais' from store S
join address A on S.address_id = A.address_id
join city Ci on A.city_id = Ci.city_id
join country Co on Ci.country_id = Co.country_id
where S.store_id = 1;

/* 7 */
select * from (
    select F1.film_id as IdP1,F1.title as TituloP1,F1.rating as RatingP1,F2.film_id as IdP2, F2.title  as TituloP2,F2.rating as RatingP2 from film F1, film F2
    where F1.rating = F2.rating and F1.title != F2.title
) as SelectPadre
where IdP1 in (
    select distinct min(F1.film_id) as id from film F1
    group by F1.rating
    order by F1.rating
)
order by IdP1;

/* 8 */
select distinct F.film_id, F.title as Pelicula, S.store_id as IdTienda, concat(St.first_name,' ',St.last_name) AS NombreManager
from film F
join inventory I on F.film_id = I.film_id
join store S on S.store_id = I.store_id
join staff St on S.manager_staff_id = St.staff_id
where S.store_id = 2;
use sakila;

#### 1 ####
#Add a new customer
#To store 1
#For address use an existing address. The one that has the biggest address_id in 'United States'

INSERT INTO customer 
(store_id, first_name, last_name, email, address_id, active)
SELECT 1,'UserClass13','UserClass14nt','userclass13userclass14nt@yahoo.com',MAX(a.address_id),1
FROM address a
where (
    select c.country_id
    from country c, city c1
    where c.country = "United States"
	and c.country_id = c1.country_id
	and c1.city_id = a.city_id
);

select * from customer where first_name = 'UserClass13';




#### 2 ####
#Add a rental

#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where,
#and not the id.
#Do not check if the film is already rented, just use any from the inventory, 
#e.g. the one with highest id.
#Select any staff_id from Store 2.


insert into rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
select CURRENT_TIMESTAMP, #rental_date
(
    select max(r.inventory_id)
    from inventory r
    join film f using(film_id)
    where f.title = 'ZORRO ARK'
    limit 1
), #inventory_id
600, #customer_id
NULL, #return_date
(
    select staff_id
	from staff
	join store USING(store_id)
	where store.store_id = 2
	limit 1
) #staff_id
; 

select * from rental where customer_id = 600;


#### 3 ####
#Update film year based on the rating
#For example if rating is 'G' release date will be '2001'
#You can choose the mapping between rating and year.
#Write as many statements are needed.


update film
set release_year = '2000'
where rating = 'G';

update film
set release_year = '2005'
where rating = 'PG';

update film
set release_year = '2010'
where rating = 'PG-13';

update film
set release_year = '2015'
where rating = 'R';

update film
set release_year = '2020'
where rating = 'NC-17';



#### 4 ####
#Return a film

#Write the necessary statements and queries for the following steps.
#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#Use the id to return the film.
UPDATE rental
SET return_date = CURRENT_TIMESTAMP
WHERE rental_id IN (
    SELECT rental_id
    FROM (
        SELECT r.rental_id
        FROM film
        JOIN inventory USING (film_id)
        JOIN rental r USING (inventory_id)
        WHERE r.return_date IS NULL
        ORDER BY r.rental_id
        LIMIT 1
    ) AS papaquery
);

select * from rental order by rental_id DESC limit 1;



#### 5 ####
#Try to delete a film

#Check what happens, describe what to do.
#Write all the necessary delete statements to entirely remove the film from the DB.

delete from payment
where rental_id in (
    select rental_id 
    from rental
    join inventory USING (inventory_id) 
    where film_id = 1
);
 
delete from rental
where inventory_id in (
    select inventory_id 
    from inventory
    where film_id = 1
);
                        
delete from inventory where film_id = 1;

delete film_actor from film_actor where film_id = 1;

delete film_category from film_category where film_id = 1;

delete film from film where film_id = 1;


#### 6 ####
#Rent a film

#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
#Add a rental entry
#Add a payment entry
#Use sub-queries for everything, except for the inventory id that can be used directly in the queries.

SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (
    SELECT inventory_id
    FROM inventory
	INNER JOIN rental USING (inventory_id)
	WHERE return_date IS NULL
    
)
limit 1
# inventory id to use: 10

# film id to use: 2



SELECT inventory_id
FROM (
    SELECT inventory_id, film_id
    FROM inventory
    WHERE inventory_id NOT IN (
        SELECT inventory_id
        FROM inventory
        INNER JOIN rental USING (inventory_id)
        WHERE return_date IS NULL
    )
    limit 1
) AS papaquery


INSERT INTO rental
(rental_date, inventory_id, customer_id, staff_id)
VALUES
(
    CURRENT_DATE(),
    (
        SELECT inventory_id
        FROM (
            SELECT inventory_id, film_id
            FROM inventory
            WHERE inventory_id NOT IN (
                SELECT inventory_id
                FROM inventory
                INNER JOIN rental USING (inventory_id)
                WHERE return_date IS NULL
            )
            limit 1
        ) AS papaquery
    ),

    (
        SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1
    ),
    (
        SELECT staff_id FROM staff WHERE store_id = (
            SELECT store_id FROM inventory WHERE inventory_id in (
                SELECT inventory_id
                FROM (
                    SELECT inventory_id, film_id
                    FROM inventory
                    WHERE inventory_id NOT IN (
                        SELECT inventory_id
                        FROM inventory
                        INNER JOIN rental USING (inventory_id)
                        WHERE return_date IS NULL
                    )
                    limit 1
                ) AS papaquery
            )
        )
    )

);

INSERT INTO payment
(customer_id, staff_id, rental_id, amount, payment_date)
VALUES(
    (
        SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1
    ),
    (
        SELECT staff_id FROM staff LIMIT 1
    ),
    (
        SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1
    ) ,
    (
        SELECT rental_rate FROM film WHERE film_id in (
            SELECT film_id
            FROM (
                SELECT inventory_id, film_id
                FROM inventory
                WHERE inventory_id NOT IN (
                    SELECT inventory_id
                    FROM inventory
                    INNER JOIN rental USING (inventory_id)
                    WHERE return_date IS NULL
                )
                limit 1
            ) AS papaquery
        )
    ),
    CURRENT_DATE()
);

select * from rental order by rental_date DESC limit 1;
select * from payment order by payment_date DESC limit 1;

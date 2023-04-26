#List all the actors that share the last name. Show them in order
#Find actors that don't work in any film
#Find customers that rented only one film
#Find customers that rented more than one film
#List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
#List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
#List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
#List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'


use sakila;
/* 1 */
select last_name,first_name,actor_id 
from actor
where last_name in (
    select last_name
    from actor
    group by last_name
    having count(*) > 1
)
order by last_name,first_name;


/* 2 */
select actor_id,last_name,first_name
from actor
where actor_id not in (
    select actor_id
    from film_actor
);

/* 3 */
select customer_id,first_name,last_name
from customer
where customer_id in (
    select customer_id from (
        select count(customer_id) as cant,customer_id
        from rental
        group by customer_id 
        order by count(customer_id)
    ) as countCustomers
    where cant = 1
);

/* 4 */
select customer_id,first_name,last_name
from customer
where customer_id in (
    select customer_id from (
        select count(customer_id) as cant,customer_id
        from rental
        group by customer_id 
        order by count(customer_id)
    ) as countCustomers
    where cant > 1
);

/* 5 */
select actor_id,first_name,last_name
from actor
where actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id 
        from film
        where title = 'BETRAYED REAR' or title = 'CATCH AMISTAD'
    )  
    group by actor_id
);

/* 6 */
select actor_id,first_name,last_name
from actor
where actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id 
        from film
        where title = 'BETRAYED REAR'
    )  
    group by actor_id
)
and actor_id not in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id 
        from film
        where title = 'CATCH AMISTAD'
    )  
    group by actor_id
);

/* 7 */
select actor_id,first_name,last_name
from actor
where actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id 
        from film
        where title = 'BETRAYED REAR'
    )  
    group by actor_id
)
and actor_id in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id 
        from film
        where title = 'CATCH AMISTAD'
    )  
    group by actor_id
);

/* 8 */
select actor_id,first_name,last_name
from actor
where actor_id not in (
    select actor_id
    from film_actor
    where film_id in (
        select film_id 
        from film
        where title = 'BETRAYED REAR' or title = 'CATCH AMISTAD'
    )  
    group by actor_id
);




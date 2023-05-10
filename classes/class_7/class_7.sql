1 Find the films with less duration, show the title and rating.

2 Write a query that returns the title of the film which duration is the lowest. 
If there are more than one film with the lowest durtation, the query returns an empty resultset.

3 Generate a report with list of customers showing the lowest payments done by each of them. 
Show customer information, the address and the lowest amount, 
provide both solution using ALL and/or ANY and MIN.

4 Generate a report that shows the customer's information with the highest payment and the lowest 
payment in the same row.
'


use sakila;


/*  1  */
SELECT title,rating,length FROM film 
WHERE length <= ALL (
  SELECT length 
  FROM film
);

/*  2  */
SELECT title, rating, length
FROM film AS f1
WHERE length <= ALL (
  SELECT length 
  FROM film
)
AND NOT EXISTS(
  SELECT * FROM film AS f2 WHERE f2.film_id <> f1.film_id AND f2.length <= f1.length
);

/*  3  */
SELECT * from (
  SELECT c.customer_id as id,c.first_name as firstName, c.last_name as lastName,a.address as address, p.amount AS lowest_payment
  FROM customer c
  INNER JOIN payment p on c.customer_id = p.customer_id
  INNER JOIN address a on c.address_id = a.address_id
  WHERE p.amount <= ALL(
    SELECT amount from payment WHERE customer_id=c.customer_id
  )
) as queryPapa
GROUP BY id,lowest_payment;

/*  4  */
SELECT id,firstName,lastName,address,min(amount) AS lowest_payment , max(amount) AS highest_payment from (
  SELECT c.customer_id as id,c.first_name as firstName, c.last_name as lastName,a.address as address,p.amount as amount
  FROM customer c
  INNER JOIN payment p on c.customer_id = p.customer_id
  INNER JOIN address a on c.address_id = a.address_id
  WHERE p.amount <= ALL(
    SELECT amount from payment WHERE customer_id=c.customer_id
  )
  OR p.amount >= ALL(
    SELECT amount from payment WHERE customer_id=c.customer_id
  )
) as queryPapa
GROUP BY id;
use sakila;

#1
#Insert a new employee to , but with an null email. Explain what happens.

insert into employees values (1080,'pepe','peponcio','x9999',null,1,'a','Vp');

#tira error por que la columna email tiene un NOT NULL 
#ERROR 1048 (23000): Column 'email' cannot be null


#2
#UPDATE employees SET employeeNumber = employeeNumber - 20
#What did happen? Explain. Then run this other

#UPDATE employees SET employeeNumber = employeeNumber + 20
#Explain this case also.

#UPDATE employees SET employeeNumber = employeeNumber - 20;
#esta linea de codigo se puede ejecutar por que el motor de busqueda va secuencialmente de arriba hacia abajo, 
#por lo que cuando tiene los id 1056 y 1076 pasa primero a 1036 y luego 1056

#UPDATE employees SET employeeNumber = employeeNumber + 20;
#encambio esta linea de codigo con los valores 1036 y 1056 pasa primero a 1056 y tira error al existir por un momento un doble id con 1056


#3
#Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.

alter table employees
add age TINYINT UNSIGNED DEFAULT 69;

alter table employees
add CONSTRAINT age CHECK(age >= 16 and age <=70);


#4
#Describe the referential integrity between tables film, actor and film_actor in sakila db
/*
In the sakila database, which is often used as a sample database for learning and testing purposes, there are three tables: film, actor, and film_actor. These tables are related through a many-to-many relationship, and the film_actor table serves as a junction table that connects the film and actor tables. This relationship is established to represent the fact that multiple actors can be associated with multiple films, and vice versa.

Here's how the referential integrity is maintained between these tables:

Film Table (film):

The film table contains information about individual films in the database.
It has a primary key named film_id, which uniquely identifies each film.
Other attributes in the film table describe properties of the films, such as title, release_year, and so on.
Actor Table (actor):

The actor table contains information about individual actors.
It has a primary key named actor_id, which uniquely identifies each actor.
Additional attributes in the actor table include actor-related details like first_name and last_name.
Film_Actor Table (film_actor):

The film_actor table serves as a junction table that establishes the many-to-many relationship between films and actors.
It contains foreign keys, film_id and actor_id, which reference the film and actor tables, respectively.
These foreign keys link the records in the film_actor table to the corresponding records in the film and actor tables.
The referential integrity between these tables is maintained as follows:

When a new film is inserted into the film table, a corresponding entry is created in the film_actor table, linking the film's film_id with the appropriate actor_id values. This signifies the actors associated with that film.
Similarly, when a new actor is added to the actor table, a corresponding entry is created in the film_actor table, linking the actor's actor_id with the relevant film_id values. This represents the films in which that actor has a role.
If a film or actor is deleted from their respective tables, the corresponding entries in the film_actor table are usually deleted as well, ensuring that no references exist to non-existent films or actors.
*/

#5
#Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on 
#inserts and updates operations. 
#Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row 
#(assume multiple users, other than root, can connect to MySQL and change this table).

ALTER TABLE employees
	ADD COLUMN lastUpdate DATETIME;

	
ALTER TABLE employees
	ADD COLUMN lastUpdateUser VARCHAR(255);	

DELIMITER //

CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    SET NEW.lastUpdate=NOW();
    SET NEW.lastUpdateUser=CURRENT_USER;
END;
//

DELIMITER ;


update employees set lastName = 'Phanny' where firstName = 'Diane';

#6
#Find all the triggers in sakila db related to loading film_text table. 
#What do they do? Explain each of them using its source code for the explanation.

----------------- INS_FILM ------------------
-- Inserta una nueva pelicula en film_text --
/*
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
END
*/
------------------------ UPD_FILM ------------------------
-- Actualiza el film_text existente por uno actualizado --
/*
BEGIN
	IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
	THEN
	    UPDATE film_text
	        SET title=new.title,
	            description=new.description,
	            film_id=new.film_id
	    WHERE film_id=old.film_id;
	END IF;
END
*/
---------------------------------- DEL_FILM --------------------------------
-- Elimina el film_text existente que corresponde a la pelicula eliminada --
/*
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END
*/
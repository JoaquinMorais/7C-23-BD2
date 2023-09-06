#1
#Create a user data_analyst

CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'pepe1234';

#2
#Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.

GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';


#3
#Login with this user and try to create a table. Show the result of that operation.

use sakila;
create table testCreateTable (
    id int primary key auto_increment,
    name varchar(100),
    description varchar(250)
);

-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'testCreateTable'
-- thats happens because the user 'data_analyst' does not have the necessary privileges to create a table in sakila database.


#4
#Try to update a title of a film. Write the update script.

use sakila;

UPDATE film
    SET title = 'testUpdateFilm'
WHERE title = 'ZORRO ARK';

UPDATE film
    SET title = 'ZORRO ARK'
WHERE title = 'testUpdateFilm';

#5
#With root or any admin user revoke the UPDATE permission. Write the command
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
-- revoke the Update permition



#6
#Login again with data_analyst and try again the update done in step 4. Show the result.

UPDATE film
    SET title = 'testUpdateFilm'
WHERE title = 'ZORRO ARK';
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'


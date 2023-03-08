drop database if exists imdb;
create database imdb;
use imdb;

create table film (film_id int primary key auto_increment,title varchar(30),descripcion varchar(100),release_year date);
create table actor (actor_id int primary key auto_increment, first_name varchar(30),last_name varchar(30));
create table film_actor(id int primary key auto_increment, actor_id int, film_id int);

alter table film add column last_update date;
alter table actor add column last_update date;

alter table film_actor add foreign key (film_id) references film(film_id);
alter table film_actor add foreign key (actor_id) references actor(actor_id);


insert into film(title,descripcion,release_year,last_update) values ('Jonh Wick','Matan al perro y quiere venganza','16-12-30','16-12-31'),
('Matrix','Azul o Roja??!!','00-2-26','00-04-08');

insert into actor(first_name,last_name,last_update) values ('Keanu','Reeves','20-12-20'),('Laurance','Fishburne','21-03-10'),
('Carrie-Anne','Moss','10-10-10');

insert into film_actor(film_id,actor_id) values (1,1),(1,2),(2,1),(2,2),(2,3);

select * from film;
select * from actor;
select * from film_actor;

drop database if exists JoaquinMorais_Tp0;
create database JoaquinMorais_Tp0;
use JoaquinMorais_Tp0;

create table Sede (id int primary key auto_increment,ubicacion varchar(100));
insert into Sede (ubicacion) values ('donGeronimo 4400'),('calle piola 123'),('Osbaldo 111');

create table Dia (id int primary key auto_increment,fecha date,id_sede int,constraint foreign key (id_sede) references Sede(id));
insert into Dia (fecha,id_sede) values ('10/10/10',3),('10/10/10',2),('23/03/01',1),('23/03/01',2),('23/03/02',1),('23/03/03',1);

create table Tipo_Clase(id int primary key auto_increment,nombre varchar(30),descripcion varchar(100));
insert into Tipo_Clase (nombre,descripcion) values ('Yoga','Estirate'),('Pilates','Recuperate!');

create table Clase (id int primary key auto_increment,nombre varchar(30),horario_inicio time,horario_final time, cupo_maximo int,id_tipo_clase int, constraint foreign key (id_tipo_clase) references Tipo_Clase(id));
insert into Clase (nombre,horario_inicio,horario_final,cupo_maximo,id_tipo_clase) values ('EjemploClase','13:00:00','14:00:00',46,1),('EjemploClase','14:00:00','15:00:00',35,1),('EjemploClase','13:00:00','14:00:00',30,2);

create table Dia_Clase (id int primary key auto_increment,id_dia int,id_clase int,constraint foreign key (id_dia) references Dia(id),constraint foreign key (id_clase) references Clase(id));
insert into Dia_Clase (id_dia,id_clase) values (1,1),(1,2),(2,2),(3,1),(4,2);

create table Tipo_Plan (id int primary key auto_increment,nombre varchar(30),descripcion varchar(100));
insert into Tipo_Plan (nombre,descripcion) values ('Musculacion','Para los musculos');

create table Estado_Plan (id int primary key auto_increment,nombre varchar(30),descripcion varchar(100));
insert into Estado_Plan (nombre,descripcion) values ('Creacion','Se esta creando'),('Expirado','Ya has terminado de usar este plan'),('Activo','On fire!');

create table Socio (id int primary key auto_increment,nombre varchar(30),apellido varchar(30),fecha_nacimiento date);
insert into Socio (nombre,apellido,fecha_nacimiento) values ('Pepe','Moncho','10-10-10');

create table Plan (id int primary key auto_increment,nombre varchar(30),descripcion varchar(100),fecha_activacion date,fecha_finalizacion date,id_socio int,id_tipo_plan int, id_estado_plan int, constraint foreign key (id_socio) references Socio(id),constraint foreign key (id_tipo_plan) references Tipo_Plan(id),constraint foreign key (id_estado_plan) references Estado_Plan(id));
insert into Plan (nombre,descripcion,fecha_activacion,fecha_finalizacion, id_socio,id_tipo_plan,id_estado_plan) values ('Plan1','aaaaa','10-10-10','10-11-10',1,1,1);

create table Sesion (id int primary key auto_increment, orden int,nombre varchar (30),id_plan int,constraint foreign key (id_plan) references Plan(id));
insert into Sesion (orden,nombre,id_plan) values (1,'aaaaaaaaa',1);

create table Circuito_Ejercicio (id int primary key auto_increment,repeticiones int,series int,notas varchar(100));
insert into Circuito_Ejercicio (repeticiones,series,notas) values (10,2,'Segui Asi!!'),(30,1,'Segui Asi!!'),(25,3,'Segui Asi!!');





















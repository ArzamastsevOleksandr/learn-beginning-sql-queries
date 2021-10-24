-- TYPES
create type member_type as enum ('associate', 'junior', 'social', 'senior');

create type practice_night as enum ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun');

create type gender as enum ('m', 'f');

create type tour_type as enum ('open', 'social');

-- TABLES
create table team
(
    name           varchar(20) primary key,
    practice_night practice_night
);

create table member
(
    id          integer primary key,
    lastname    varchar(20),
    firstname   varchar(20),
    member_type member_type,
    phone       char(6),
    handicap    integer,
    join_date   timestamp,
    gender      gender,
    team        varchar(20),
    coach_id integer,

    foreign key (team) references team (name),
    foreign key (coach_id) references member(id)
);

create table type_fee
(
    type member_type primary key,
    fee  smallint not null
);

create table tour
(
    id   integer primary key,
    name varchar(30) not null,
    type tour_type default 'social'
);

create table tour_entry
(
    member_id integer,
    tour_id   integer,
    year      integer
);

-- VIEWS
create view member_name_and_team as
select concat(m.lastname, ' ', m.firstname) as fullname, t.name as teamname
from member m
         join team t on m.team = t.name;

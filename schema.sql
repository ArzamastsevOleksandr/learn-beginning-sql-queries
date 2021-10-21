create type member_type as enum ('junior', 'social', 'senior');

create type practice_night as enum ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun');

create type gender as enum ('m', 'f');

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

    foreign key (team) references team (name)
);

create view member_name_and_team as
select concat(m.lastname, ' ', m.firstname), t.name
from member m
         join team t on m.team = t.name;

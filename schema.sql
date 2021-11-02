-- TYPES
create type member_type as enum ('associate', 'junior', 'social', 'senior');

create type practice_night as enum ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun');

create type gender as enum ('m', 'f');

create type tour_type as enum ('open', 'social');

-- TABLES
create table team
(
    name           varchar(20) primary key,
    practice_night practice_night,
    manager_id     bigint unique
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
    coach_id    integer,

    foreign key (team) references team (name),
    foreign key (coach_id) references member (id)
);

alter table team
    add constraint team_manager_fkey
        foreign key (manager_id) references member (id);

create table club_a
(
    member_id   bigint primary key,
    lastname    varchar(20),
    handicap    integer,
    member_type member_type,

    foreign key (member_id) references member (id)
);

create table club_b
(
    mem_id     bigint primary key,
    familyName varchar(20),
    grade      member_type,
    hand_cap   integer,

    foreign key (mem_id) references member (id)
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

create table order_info
(
    id       smallint primary key,
    price    int,
    quantity int
);

create table income
(
    month  smallint,
    income integer
);

create table income_with_area
(
    month  smallint,
    area   varchar(10),
    income integer
);

-- VIEWS
create view member_name_and_team as
select concat(m.lastname, ' ', m.firstname) as fullname, t.name as teamname
from member m
         join team t on m.team = t.name;

-- todo: use dbeaver to get the db visual schema
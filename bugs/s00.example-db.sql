create table products
(
    id   serial primary key,
    name varchar(50)
);

create table accounts
(
    id            serial primary key,
    name          varchar(20),
    first_name    varchar(20),
    last_name     varchar(20),
    email         varchar(100),
    password_hash char(64),
--     portrait_image BLOB,
    hourly_rate   numeric(9, 2)
);
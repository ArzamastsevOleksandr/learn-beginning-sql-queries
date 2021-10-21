insert into team
    (name, practice_night)
values ('Tigers', 'mon'),
       ('Lions', 'wed');

insert into member
(id, lastname, firstname, phone, handicap, join_date, gender, team, member_type)
values (118, 'McKenzie', 'Melissa', '123321', 30, '05/10/1999', 'f', 'Tigers', 'junior'),
       (119, 'Lock', 'John', '345543', null, '05/9/1997', 'm', 'Tigers', 'senior'),
       (120, 'Jarah', 'Said', '567765', null, '05/8/1996', 'm', 'Lions', 'senior'),
       (121, 'Soyer', 'Tom', '789987', 30, '05/7/1996', 'm', 'Tigers', 'senior'),
       (122, 'Kwin', 'Jim', '909090', 20, '05/6/1995', 'm', 'Lions', 'junior'),
       (123, 'Beck', 'Sarah', '101010', 10, '05/5/1994', 'f', 'Lions', null);

insert into type_fee
    (type, fee)
values ('associate', 50),
       ('junior', 100),
       ('social', 200),
       ('senior', 500);

insert into tour
    (id, name)
values (24, 'Leeston'),
       (25, 'Kaiapoi'),
       (36, 'WestCoast'),
       (38, 'Canterbury'),
       (40, 'Otago');

insert into tour_entry
    (member_id, tour_id, year)
values (118, 24, 2014),
       (119, 25, 2015);
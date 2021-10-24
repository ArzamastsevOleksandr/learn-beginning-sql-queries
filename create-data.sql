insert into team
    (name, practice_night)
values ('Tigers', 'mon'),
       ('Lions', 'wed');

insert into member
(id, lastname, firstname, phone, handicap, join_date, gender, team, member_type, coach_id)
values (118, 'McKenzie', 'Melissa', '123321', 10, '05/10/1999', 'f', 'Tigers', 'junior', 123),
       (119, 'Lock', 'John', '345543', 45, '05/9/1997', 'm', 'Tigers', 'senior', 123),
       (120, 'Jarah', 'Said', '567765', null, '05/8/1996', 'm', 'Lions', 'senior', 123),
       (121, 'Soyer', 'Tom', '789987', 25, '05/7/1996', 'm', 'Tigers', 'senior', 123),
       (122, 'Kwin', 'Jim', '909090', 20, '05/6/1995', 'm', 'Lions', 'junior', 123),
       (123, 'Beck', 'Sarah', '101010', 10, '05/5/1994', 'f', 'Lions', null, 124),
       (124, 'Cruise', 'Adam', '202020', 40, '05/4/1993', 'm', 'Tigers', null, null);

insert into type_fee
    (type, fee)
values ('associate', 50),
       ('junior', 100),
       ('social', 200),
       ('senior', 500);

insert into tour
    (id, name, type)
values (24, 'Leeston', 'open'),
       (25, 'Kaiapoi', 'open'),
       (36, 'WestCoast', 'social'),
       (38, 'Canterbury', 'open'),
       (40, 'Otago', 'social');

insert into tour_entry
    (member_id, tour_id, year)
values (118, 24, 2014),
       (118, 36, 2015),
       (119, 25, 2015),
       (120, 36, 2015),
       (121, 38, 2014),
       (122, 40, 2016);
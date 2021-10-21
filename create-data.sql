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
       (122, 'Kwin', 'Jim', '909090', 30, '05/6/1995', 'm', 'Lions', 'junior');
insert into team
    (name, practice_night)
values ('TeamA', 'mon'),
       ('TeamB', 'wed'),
       ('TeamC', 'fri');

insert into member
(id, lastname, firstname, phone, handicap, join_date, gender, team, member_type, coach_id)
values (118, 'McKenzie', 'Melissa', '123321', 10, '05/10/1999', 'f', 'TeamA', 'junior', 123),
       (119, 'Lock', 'John', '345543', 45, '05/9/1997', 'm', 'TeamA', 'senior', 123),
       (120, 'Jarah', 'Said', '567765', null, '05/8/1996', 'm', 'TeamB', 'senior', 123),
       (121, 'Soyer', 'Tom', '789987', 25, '05/7/1996', 'm', 'TeamA', 'senior', 123),
       (122, 'Kwin', 'Jim', '909090', 20, '05/6/1995', 'm', 'TeamB', 'junior', 123),
       (123, 'Beck', 'Sarah', '101010', 10, '05/5/1994', 'f', 'TeamB', null, 124),
       (124, 'Cruise', 'Adam', '202020', 40, '05/4/1993', 'm', 'TeamA', null, null),
       (125, 'Bloch', 'Joshua', '232323', 31, '05/3/1992', 'm', 'TeamB', 'senior', null),
       (126, 'Kant', 'Kant', '141414', 13, '05/2/1991', 'm', null, null, null),
       (127, 'Ex', 'Am', '141414', 13, '05/2/1991', 'm', null, null, null);


insert into club_a
    (member_id, lastname, handicap, member_type)
values (118, 'McKenzie', 10, 'junior'),
       (119, 'Lock', 45, 'senior'),
       (120, 'Jarah', null, 'senior'),
       (121, 'Soyer', 25, 'senior'),
       (122, 'Kwin', 20, 'junior'),
       (123, 'Beck', 10, null),
       (124, 'Cruise', 40, null);

insert into club_b
    (mem_id, familyname, grade, hand_cap)
values (120, 'Jarah', 'senior', null),
       (121, 'Soyer', 'senior', 25),
       (122, 'Kwin', 'junior', 20),
       (123, 'Beck', null, 10),
       (124, 'Cruise', null, 40),
       (125, 'Bloch', 'senior', 31),
       (126, 'Kant', null, 13);

update team
set manager_id = 124
where name = 'TeamA';

update team
set manager_id = 125
where name = 'TeamB';

update team
set manager_id = 126
where name = 'TeamC';

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
       (122, 40, 2016),
       (127, 24, 2016),
       (127, 25, 2016),
       (127, 36, 2016),
       (127, 38, 2016),
       (127, 40, 2016);
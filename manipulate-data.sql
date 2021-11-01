select *
from member_name_and_team;

select m.lastname, m.firstname, m.handicap
from member m
order by(case when m.handicap is null then 1 else 0 end), m.handicap;

select count(m.handicap) as having_handicap, count(m) as total, count(distinct m.firstname) as distinct_first_names
from member m;
-- ====================================================================================================================
-- cartesian product
select *
from member m
         cross join type_fee tf;

-- custom join optimization (smaller intermediate tables)
select *
from (select * from tour_entry te where te.year = 2014) te_2014
         inner join tour t
                    on t.id = te_2014.tour_id
                        and te_2014.year = 2014
                        and t.name = 'Leeston';

-- will not include Beck Sarah, because her type is NULL
select *
from member m
         inner join type_fee tf
                    on m.member_type = tf.type;

-- will include 'Beck Sarah' with NULL value for the tf.fee column
select concat(m.lastname, ' ', m.firstname) as fullname, tf.fee
from member m
         left outer join type_fee tf
                         on m.member_type = tf.type;

-- right outer join is the same as left outer join, the tables are swapped
select *
from type_fee tf
         right outer join member m
                          on tf.type = m.member_type;

-- full outer join will retain rows with a NULL in the join field in either table
select *
from member m
         full outer join type_fee tf
                         on m.member_type = tf.type;
-- ====================================================================================================================
select te.member_id
from tour_entry te
where te.tour_id in (select t.id
                     from tour t
                     where t.type = 'open'
);

-- will return the same result as the query with a subquery above
select te.member_id
from tour_entry te
         inner join tour t
                    on t.type = 'open'
                        and te.tour_id = t.id;

-- get all members who have entered ANY tours
select concat(m.lastname, ' ', m.firstname)
from member m
where exists(select * from tour_entry te where te.member_id = m.id);

-- is the same as the query above
select distinct concat(m.lastname, ' ', m.firstname)
from member m
         inner join tour_entry te on m.id = te.member_id;

-- get all members who have NOT entered ANY tours
select concat(m.lastname, ' ', m.firstname)
from member m
where not exists(select * from tour_entry te where te.member_id = m.id);

select *
from member m
where not exists(select *
                 from tour_entry te,
                      tour t
                 where te.member_id = m.id
                   and te.tour_id = t.id
                   and t.type = 'open');

select *
from member m
where m.handicap < (select handicap from member where id = 119);

select *
from member m
where m.handicap < (select avg(handicap) from member);

select *
from member m
where m.member_type = 'junior'
  and m.handicap < (select avg(handicap) from member where member_type = 'senior');

-- insert a record for every JUNIOR member
insert into tour_entry
    (member_id, tour_id, year)
select m.id, 40, 2017
from member m
where m.member_type = 'junior';

delete
from tour_entry te
where te.tour_id = 25
  and te.year = 2019
  and te.member_id in (select m.id from member m where m.handicap > 100);
-- ====================================================================================================================
-- members who have a coach
select 'has coach', m.firstname
from member m
         inner join member c
                    on m.coach_id = c.id;

-- coach names
select distinct concat(c.firstname, ' ', c.lastname)
from member m
         join member c
              on m.coach_id = c.id;

-- who is being coached with a lower handicap?
select m.firstname
from member m
         join member c
              on m.coach_id = c.id
where m.handicap > c.handicap;

-- list the names of all members and the names of their coaches
select m.firstname as m_first, m.lastname as m_last, c.firstname as c_first, c.lastname as c_last
from member m
         left join member c
                   on m.coach_id = c.id;

-- show all members that have entered BOTH tours 24 AND 36
select m.id
from member m
where exists(select * from tour_entry where tour_id = 24 and member_id = m.id)
  and exists(select * from tour_entry where tour_id = 36 and member_id = m.id);

select te.member_id
from tour_entry te
where te.tour_id = 24
  and exists(select * from tour_entry te2 where te2.tour_id = 36 and te2.member_id = te.member_id);

select e1.member_id
from tour_entry e1
         inner join tour_entry e2
                    on e1.member_id = e2.member_id
                        and e1.tour_id = 24 and e2.tour_id = 36;
-- ====================================================================================================================
-- get team name and its manager details
select t.name, t.manager_id, m.lastname, m.firstname
from team t
         inner join member m
                    on t.manager_id = m.id;

-- get member name and his coach name
select m1.lastname as m_last, m2.lastname as manager_last
from member m1
         inner join team t on m1.team = t.name
         inner join member m2 on t.manager_id = m2.id;

select m1.lastname as member_last, m2.lastname as manager_last
from member m1,
     team t,
     member m2
where m1.team = t.name
  and t.manager_id = m2.id;

-- find teams whose managers are not members of the team
select t.name, managers.lastname as m_last
from member managers,
     team t
where t.manager_id = managers.id
  and (managers.team is null or managers.team <> t.name);
-- ====================================================================================================================
-- ensure UNION compatibility by specifying the sequence of columns
-- no duplicates
select ca.member_id, ca.lastname, ca.handicap, ca.member_type
from club_a ca
union
select cb.mem_id, cb.familyname, cb.hand_cap, cb.grade
from club_b cb;
-- with duplicates
select ca.member_id, ca.lastname, ca.handicap, ca.member_type
from club_a ca
union all
select cb.mem_id, cb.familyname, cb.hand_cap, cb.grade
from club_b cb;

-- get member ids who have entered either tour 24 or 36
select distinct e1.member_id
from tour_entry e1
where e1.tour_id in (24, 36);

select distinct e1.member_id
from tour_entry e1
where e1.tour_id = 24
   or e1.tour_id = 36;

select e1.member_id
from tour_entry e1
where e1.tour_id = 24
union
select e2.member_id
from tour_entry e2
where e2.tour_id = 36;

-- will not get all rows because some members have a NULL in member_type
select *
from member m
         inner join type_fee tf
                    on m.member_type = tf.type;
-- will get all members with NULLs for the corresponding type_fee columns
select *
from member m
         left join type_fee tf
                   on m.member_type = tf.type;
-- the same as above
select *
from type_fee tf
         right join member m
                    on tf.type = m.member_type;
-- will get all rows from the type_fee
select *
from member m
         right join type_fee tf
                    on m.member_type = tf.type;

-- will get all rows from both tables
select m.lastname, tf.type, tf.fee
from member m
         full join type_fee tf
                   on tf.type = m.member_type;
-- an equivalent of the query above
select m.lastname, tf.type, tf.fee
from member m
         left join type_fee tf on tf.type = m.member_type
union
select m.lastname, tf.type, tf.fee
from member m
         right join type_fee tf on tf.type = m.member_type;

-- find member ids who have entered BOTH tours 24 AND 36
select e1.member_id
from tour_entry e1
where e1.tour_id = 24
intersect
select e2.member_id
from tour_entry e2
where e2.tour_id = 36;

-- find member data who have entered BOTH tours 24 AND 36
select *
from (select e1.member_id
      from tour_entry e1
      where e1.tour_id = 24
      intersect
      select e2.member_id
      from tour_entry e2
      where e2.tour_id = 36) inter
         inner join member m
                    on m.id = inter.member_id;
-- same as above
select *
from member m
where m.id in (select e1.member_id
               from tour_entry e1
               where e1.tour_id = 24
               intersect
               select e2.member_id
               from tour_entry e2
               where e2.tour_id = 36);
-- an intersection between 2 tables
select *
from club_a ca,
     club_b cb
where ca.member_id = cb.mem_id
  and ca.member_type = cb.grade;

-- find the difference between 2 tables
select ca.lastname, ca.handicap, ca.member_type
from club_a ca
    except
select cb.familyname, cb.hand_cap, cb.grade
from club_b cb;
-- same as above
select ca.lastname, ca.handicap, ca.member_type
from club_a ca
where ca.lastname not in (
    select cla.lastname
    from club_a cla
             inner join club_b clb
                        on cla.member_id = clb.mem_id
);
-- find all members who have not entered tour 36
select e.member_id
from tour_entry e
    except
select te.member_id
from tour_entry te
where te.tour_id = 36;
-- same as above
select *
from tour_entry e1
where e1.member_id not in (select e2.member_id from tour_entry e2 where e2.tour_id = 36);
-- same as above (has more rows because tables are different and some members have not entered any tours)
select m.id
from member m
where not exists(
        select *
        from tour_entry e
        where e.member_id = m.id
          and e.tour_id = 36
    );
-- a DIVISION operation. Find all members who have entered ALL tours
-- TODO: work on this one more
select m.lastname, m.id
from member m
where not exists(
        select *
        from tour t
        where not exists(
                select *
                from tour_entry e
                where e.member_id = m.id
                  and e.tour_id = t.id
            )
    );
-- ====================================================================================================================
-- count members who have a coach
select count(*)
from member m
where m.coach_id is not null;
-- same as above
select count(m.coach_id)
from member m;

-- how many coaches are there?
select count(distinct coach_id)
from member;
-- same as above
select count(*)
from (select distinct coach_id from member where coach_id is not null) coaches;

-- will calculate the AVG of members who have a handicap
select avg(handicap)
from member;
-- to avoid the rounding and precision loss convert to float
select round(avg(handicap * 1.0), 2)
from member;
-- will calculate the AVG of all members, regardless of a handicap
select sum(handicap) / count(*)
from member;

-- use an expression in the avg()
select avg(o.price * o.quantity)
from order_info o;

select min(handicap) as min_handicap, max(handicap) as max_handicap, avg(handicap) as avg_handicap
from member;

-- how many times each member entered tours
select member_id, count(*) as entries
from tour_entry
group by member_id;
-- get names with number of entries
select m.id, m.firstname, m.lastname, count(*) as entries
from member m inner join tour_entry te on m.id = te.member_id
group by m.id, m.firstname, m.lastname;
-- count of entries for each tour of 2015
select tour_id, count(*)
from tour_entry
where year = 2015
group by tour_id;
-- count of entries for each tour for each year
select tour_id, year, count(*)
from tour_entry
group by tour_id, year;
-- count of entries for each tour with num of entries >= 2
select tour_id, year, count(*)
from tour_entry
group by tour_id, year
having count(*) >= 2;
-- get ids of members who have entered > 4 tours
select member_id, count(*)
from tour_entry
group by member_id
having count(*) > 2;
-- get ids of members who have entered > 2 open tours
select member_id, count(*)
from tour_entry e inner join tour t on t.id = e.tour_id
where t.type = 'open'
group by member_id
having count(*) > 2
order by count(*);

select min(handicap) as minimum, round(avg(handicap), 2) as average, member_type
from member
group by member_type;

-- an equivalent to the division operator. Get member ids who have entered all tours
select member_id, count(distinct tour_id)
from tour_entry
group by member_id
having count(distinct tour_id) = (select count(distinct id) from tour);

-- select members whose handicap is higher that avg handicap
select * from member
where handicap > (select avg(handicap) from member);

-- find members who have entered at least 2 tours
select * from member
where id in (select e.member_id from tour_entry e group by member_id having count(*) >= 2);
-- same as above
select * from member m
where (select count(*) from tour_entry e where e.member_id = m.id) >= 2;
-- get an average number of tours entered by members
select avg(cc.c)
from (
         select count(*) as c
         from tour_entry e
         group by member_id
     ) cc;
-- ====================================================================================================================
-- use the over() function to allow other columns than aggregates in the result
select id,
       firstname,
       lastname,
       handicap,
       avg(handicap * 1.0) over ()            as avg,
       handicap - avg(handicap * 1.0) over () as difference,
       count(*) over ()                       as count
from member;
-- use 'partition by' to count rows based on 'group by'
select member_id, year, tour_id,
       count(*) over() as total_count,
       count(*) over(partition by tour_id) as tour_count,
       count(*) over(partition by tour_id, year) as tour_year_count
from tour_entry e
order by tour_id; -- add order by to better display output (will group the same tour_id values together)

-- will count the same year values and summarize them cumulatively
select member_id, tour_id, year,
       count(*) over(order by year) as cumulative
from tour_entry;
-- select the month, its income and the running total sum for current and previous months
select i.month, i.income,
       sum(i.income) over(order by income) as runningTotal
from income i;

-- rank members by handicap
select id, handicap,
       rank() over (order by handicap) as rank
from member
where handicap is not null;
-- get all rows with a total income
select month, area, income,
       sum(income) over() as total_sum
from income_with_area;
-- get all rows with a running total per month
select month, area, income,
       sum(income) over(order by month) as running_total
from income_with_area;
-- get all rows partitioned by are with area running total
select month, area, income,
       sum(income) over(partition by area order by month) as area_running_total
from income_with_area;
-- calculate a running average for each area (change the values to have different results)
select month, area, income,
       avg(income) over(partition by area order by month) as running_avg
from income_with_area;
-- same as above with explicit default values for the ROWS<>
select month, area, income,
       avg(income) over(
           partition by area
           order by month
           rows between unbounded preceding and current row ) as running_avg
from income_with_area;
-- get running 3 months averages (for each month we take an average that includes the current month, the one preceding, and the one following)
select month, area, income,
       avg(income) over(
           partition by area
           order by month
           rows between unbounded preceding and current row ) as running_avg,
       avg(income) over(
           partition by area
           order by month
           rows between 1 preceding and 1 following
           ) as area_3_months_avg
from income_with_area;

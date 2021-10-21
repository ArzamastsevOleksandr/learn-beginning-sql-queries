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

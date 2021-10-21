select *
from member_name_and_team;

select m.lastname, m.firstname, m.handicap
from member m
order by(case when m.handicap is null then 1 else 0 end), m.handicap;

select count(m.handicap) as having_handicap, count(m) as total, count(distinct m.firstname) as distinct_first_names
from member m;

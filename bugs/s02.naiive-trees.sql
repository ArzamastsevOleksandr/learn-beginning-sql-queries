-- antipattern: depend on one's parent.
-- problem: store a hierarchy of comments, where comments can have other comments etc.
create table comment
(
    id serial primary key,
    parent_id bigint,
    author varchar(50) not null,
    comment varchar(500) not null,

    foreign key (parent_id) references comment(id)
);

insert into comment
(parent_id, author, comment)
values (null, 'fran', 'What is the cause of this bug?'),
       (1, 'olie', 'I think it is a null pointer'),
       (2, 'fran', 'No, I checked for that'),
       (1, 'kukla', 'We need to check for valid input'),
       (4, 'olie', 'Yes, that is a bug'),
       (4, 'fran', 'Yes, please add a check'),
       (6, 'kukla', 'That fixed it');

-- get comment and its immediate children
select *
from comment c1
left join comment c2
on c1.id = c2.parent_id;

-- problems:
-- difficult to compute aggregates such as count(*)
-- difficult to get the full depth of data
-- difficult to delete the subtree (need to satisfy the foreign key constraints)

-- solution1: use path enumeration
create table comment_with_path
(
    id serial primary key,
    path varchar(1000),
    author varchar(50) not null,
    comment varchar(500) not null,

    foreign key (parent_id) references comment(id)
);
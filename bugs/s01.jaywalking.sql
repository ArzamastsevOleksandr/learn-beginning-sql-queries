-- Rule: STORE EACH VALUE IN ITS OWN COLUMN AND ROW

-- Sometimes the need may arise to store comma-separated lists in one varchar(n) column.
-- This may lead to problems like:
--      searching for a value from the list by a pattern
--      removing one item from a comma-separated list results in a lot of work
--      full table scans and large cartesian products
--      selecting a proper separator is impossible
-- There are a few legitimate uses of the pattern (denormalization):
--      the input comes from a 3rd party system and the values must be stored in the same order
--      there is no need of accessing separate values from the list
-- A solution is creating an intersection table (N-N relationship) which has foreign keys referencing 2 tables.
-- An intersection table relies on the foreign key constraints, this ensures that the DB
-- will enforce the referential integrity and prevent illegal values from being inserted.

create table contacts
(
    product_id bigint,
    account_id bigint,

    primary key (product_id, account_id),

    foreign key (product_id) references products (id),
    foreign key (account_id) references accounts (id)
);

-- Get the number of accounts per product
select product_id, count(*) as accounts_per_product
from contacts
group by product_id;

-- Get the number of products per account
select account_id, count(*) as products_per_account
from contacts
group by account_id;

-- Get the product with the greatest amount of accounts
select *
from (
         select product_id, count(*) as accounts_per_product
         from contacts
         group by product_id
     ) as report
order by report.accounts_per_product desc
limit 1;
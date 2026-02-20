CREATE TABLE SMOOTHIES.PUBLIC.FRUIT_OPTIONS (
    FRUIT_ID NUMBER,
    FRUIT_NAME VARCHAR(25)
);
create file format smoothies.public.two_headerrow_pct_delim type = CSV,
skip_header = 2,
field_delimiter = '%',
trim_space = TRUE
SELECT
    $1,
    $2
FROM
    @MY_UPLOADED_FILES/fruits_available_for_smoothies.txt (
        FILE_FORMAT => smoothies.public.two_headerrow_pct_delim
    );
COPY INTO smoothies.public.fruit_options
from
    (
        select
            $2 as FRUIT_ID,
            $1 As FRUIT_NAME
        FROM
            @MY_UPLOADED_FILES/fruits_available_for_smoothies.txt
    ) FILE_FORMAT = (
        format_name = smoothies.public.two_headerrow_pct_delim
    ) on_error = abort_statement purge = true;
create table smoothies.public.orders (ingredients varchar(200));
insert into
    smoothies.public.orders(ingredients)
values
    ('Cantaloupe Guava Jackfruit Elderberries Figs ');
select
    *
from
    smoothies.public.orders;
    --truncate table smoothies.public.orders;
alter table
    smoothies.public.orders
add
    column ORDER_FILLED boolean;
insert into
    smoothies.public.orders(ingredients, name_on_order)
values
    ('Cantaloupe Figs Honeydew ', 'Ankit')
alter table
    smoothies.public.orders
add
    column ORDER_FILLED boolean DEFAULT FALSE;
update
    smoothies.public.orders
set
    order_filled = true
where
    name_on_order is null;
alter table
    SMOOTHIES.PUBLIC.ORDERS
add
    column order_uid integer --adds the column
    default smoothies.public.order_seq.nextval --sets the value of the column to sequence
    constraint order_uid unique enforced;
--makes sure there is always a unique value in the column
    create
    or replace table smoothies.public.orders (
        order_uid integer default smoothies.public.order_seq.nextval,
        order_filled boolean default false,
        name_on_order varchar(100),
        ingredients varchar(200),
        constraint order_uid unique (order_uid),
        order_ts timestamp_ltz default current_timestamp()
    );
set
    mistry_bag = 'what is not there';
select
    $mistry_bag;
set
    var1 = 5;
set
    var2 = 10;
set
    var3 = 15;
select
    ($var1 + $var2 + $var3);
create function sum_mystery_bag_vars (var1 number, var2 number, var3 number) returns number as 'select var1+var2+var3';
select
    sum_mystery_bag_vars(5.3, -3, 7)
set
    alternating_cap_pharse = 'aLtErNaTiNg CaPs!'
select
    initcap($alternating_cap_pharse);
create function NEUTRALIZE_WHINING(var1 TEXT) returns TEXT as ' select initcap(var1)';
select
    NEUTRALIZE_WHINING('aLtErNaTiNg CaPs!')
select
    *
from
    smoothies.public.fruit_options;
alter table
    smoothies.public.fruit_options
add
    column SEARCH_ON varchar(25);
update
    smoothies.public.fruit_options
set
    SEARCH_ON = 'Apple'
where
    fruit_name = 'Apples';
update
    smoothies.public.fruit_options
set
    SEARCH_ON = 'Blueberry'
where
    fruit_name = 'Blueberries';
update
    smoothies.public.fruit_options
set
    SEARCH_ON = 'Raspberry'
where
    fruit_name = 'Raspberries';
update
    smoothies.public.fruit_options
set
    SEARCH_ON = 'Strawberry'
where
    fruit_name = 'Strawberries';
select
    *
from
    smoothies.public.orders;
Kevin Divya Xi
update
    smoothies.public.orders
set
    name_on_order = 'Kevin'
where
    order_uid = 1001;
update
    smoothies.public.orders
set
    name_on_order = 'Divya'
where
    order_uid = 1201;
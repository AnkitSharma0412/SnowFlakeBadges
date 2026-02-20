create
or replace table ROOT_DEPTH (
    ROOT_DEPTH_ID number(1),
    ROOT_DEPTH_CODE text(1),
    ROOT_DEPTH_NAME text(7),
    UNIT_OF_MEASURE text(2),
    RANGE_MIN number(2),
    RANGE_MAX number(2)
);
insert into
    root_depth
values
    (
        1,
        'S',
        'Shallow',
        'cm',
        30,
        45
    );
insert into
    root_depth
values
    (
        1,
        'M',
        'Medium',
        'cm',
        45,
        60
    );
insert into
    root_depth
values
    (
        1,
        'L',
        'Deep',
        'cm',
        60,
        90
    );
select
    *
from
    garden_plants.vegies.root_depth;
create table garden_plants.veggies.vegetable_details (
        plant_name varchar(25),
        root_depth_code varchar(1)
    );
create
    or replace table Flower_details (
        plant_name varchar(25),
        root_depth_code varchar(1)
    );
create
    or replace table vegetable_details_soil_type (plant_name varchar(25), soil_type number(1, 0));
create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW type = 'CSV' --csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
;
copy into vegetable_details_soil_type
from
    @util_db.public.my_internal_stage files = ('VEG_NAME_TO_SOIL_TYPE_PIPE.txt') file_format = (
        format_name = GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW
    );
create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW TYPE = 'CSV' --csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
;
select
    $1
from
    @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
select
    $1,
    $2,
    $3
from
    @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv (
        file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW
    );
select
    $1,
    $2,
    $3
from
    @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv (
        file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW
    );
CREATE
    OR REPLACE FILE FORMAT L9_CHALLENGE_FF TYPE = 'CSV' FIELD_DELIMITER = '\t' -- Tab
    SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"' TRIM_SPACE = TRUE;
select
    $1,
    $2,
    $3
from
    @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv (
        file_format => garden_plants.veggies.L9_CHALLENGE_FF
    );
create
    or replace table LU_SOIL_TYPE(
        SOIL_TYPE_ID number,
        SOIL_TYPE varchar(15),
        SOIL_DESCRIPTION varchar(75)
    );
copy into LU_SOIL_TYPE
from
    @util_db.public.my_internal_stage files = ('LU_SOIL_TYPE.tsv') file_format = (
        format_name = GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF
    );
select
    *
from
    LU_SOIL_TYPE create
    or replace table VEGETABLE_DETAILS_PLANT_HEIGHT(
        plant_name varchar(50),
        UOM varchar(5),
        Low_End_of_Range number,
        High_End_of_Range number
    );
copy into VEGETABLE_DETAILS_PLANT_HEIGHT
from
    @util_db.public.my_internal_stage files = ('veg_plant_height.csv') file_format = (
        format_name = GARDEN_PLANTS.VEGGIES.COMMASEP_DBLQUOT_ONEHEADROW
    );
select
    *
from
    VEGETABLE_DETAILS_PLANT_HEIGHT use role sysadmin;
-- Create a new database and set the context to use the new database
    create database library_card_catalog comment = 'DWW Lesson 10 ';
--Set the worksheet context to use the new database
    use database library_card_catalog;
use database library_card_catalog;
use role sysadmin;
create
    or replace table book (
        book_uid number autoincrement,
        title varchar(50),
        year_published number(4, 0)
    );
insert into
    book(title, year_published)
values
    ('Food', 2001),('Food', 2006),('Food', 2008),('Food', 2016),('Food', 2015);
select
    *
from
    book;
create
    or replace table author (
        author_uid number,
        first_name varchar(50),
        middle_name varchar(50),
        last_name varchar(50)
    );
insert into
    author(author_uid, first_name, middle_name, last_name)
values
    (1, 'Fiona', '', 'Macdonald'),(2, 'Gian', 'Paulo', 'Faleschini');
select
    *
from
    author;
select
    seq_author_uid.nextval,
    seq_author_uid.nextval;
insert into
    author(author_uid, first_name, middle_name, last_name)
values
    (seq_author_uid.nextval, 'Laura', 'K', 'Egendorf'),(seq_author_uid.nextval, 'Jan', '', 'Grover'),(seq_author_uid.nextval, 'Jennifer', '', 'Clapp'),(
        seq_author_uid.nextval,
        'Kathleen',
        '',
        'Petelinsek'
    );
use database library_card_catalog;
use role sysadmin;
create table book_to_author (book_uid number, author_uid number);
insert into
    book_to_author(book_uid, author_uid)
values
  (1, 1)-- This row links the 2001 book to Fiona Macdonald
,(1, 2) --This row links the 2001 book to Gian Paulo Faleschini
,(2, 3) --Links 2006 book to Laura K Egendorf
,(3, 4) --Links 2008 book to Jan Grover
,(4, 5) --Links 2016 book to Jennifer Clapp
,(5, 6);
// Links 2015 book to Kathleen Petelinsek
select
    *
from
    book_to_author ba
    join author a on ba.author_uid = a.author_uid
    join book b on b.book_uid = ba.book_uid;
use database library_card_catalog;
use role sysadmin;
create table library_card_catalog.public.author_ingest_json (raw_author variant);
create
    or replace file format library_card_catalog.public.json_file_format type = 'JSON' compression = 'AUTO' enable_octal = FALSE allow_duplicate = false strip_outer_array = true strip_null_values = false ignore_utf8_errors = false;
select
    $1
from
    @util_db.public.my_internal_stage/author_with_header.json (
        file_format => library_card_catalog.public.json_file_format
    );
copy into library_card_catalog.public.author_ingest_json
from
    @util_db.public.my_internal_stage files = ('author_with_header.json') file_format = (
        format_name = library_card_catalog.public.json_file_format
    );
select
    raw_author
from
    library_card_catalog.public.author_ingest_json;
select
    raw_author:AUTHOR_UID
from
    author_ingest_json;
SELECT
    raw_author:AUTHOR_UID,
    raw_author:FIRST_NAME::STRING as FIRST_NAME,
    raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME,
    raw_author:LAST_NAME::STRING as LAST_NAME
FROM
    AUTHOR_INGEST_JSON;
create
    or replace table library_card_catalog.public.nested_ingest_json (raw_nested_book VARIANT);
copy into library_card_catalog.public.nested_ingest_json
from
    @util_db.public.my_internal_stage files = ('json_book_author_nested.txt') file_format = (
        format_name = library_card_catalog.public.json_file_format
    );
select
    raw_nested_book
from
    nested_ingest_json;
select
    raw_nested_book:year_published
from
    nested_ingest_json;
select
    raw_nested_book:authors
from
    nested_ingest_json;
select
    value:first_name
from
    nested_ingest_json,
    lateral flatten(input => raw_nested_book:authors);
select
    value:first_name
from
    nested_ingest_json,
    table(flatten(raw_nested_book:authors));
--Add a CAST command to the fields returned
SELECT
    value:first_name::varchar,
    value:last_name::varchar
from
    nested_ingest_json,
    lateral flatten(input => raw_nested_book:authors);
--Assign new column  names to the columns using "AS"
select
    value:first_name::varchar as first_nm,
    value:last_name::varchar as last_nm
from
    nested_ingest_json,
    lateral flatten(input => raw_nested_book:authors);
create
    or replace table SOCIAL_MEDIA_FLOODGATES.public.TWEET_INGEST (RAW_STATUS VARIANT);
select
    *
from
    TWEET_INGEST;
copy into SOCIAL_MEDIA_FLOODGATES.public.TWEET_INGEST
from
    @util_db.public.my_internal_stage files = ('nutrition_tweets.json') file_format = (
        format_name = library_card_catalog.public.json_file_format
    )
select
    raw_status
from
    tweet_ingest;
select
    raw_status:entities
from
    tweet_ingest;
select
    raw_status:entities:hashtags
from
    tweet_ingest;
select
    raw_status:entities:hashtags [0].text
from
    tweet_ingest;
select
    raw_status:entities:hashtags [0].text
from
    tweet_ingest
where
    raw_status:entities:hashtags [0].text is not null;
select
    raw_status:created_at::date
from
    tweet_ingest
order by
    raw_status:created_at::date;
select
    value
from
    tweet_ingest,
    lateral flatten (input => raw_status:entities:urls);
select
    value
from
    tweet_ingest,
    table(flatten(raw_status:entities:urls));
--Flatten and return just the hashtag text, CAST the text as VARCHAR
select
    value:text::varchar as hashtag_used
from
    tweet_ingest,
    lateral flatten (input => raw_status:entities:hashtags);
--Add the Tweet ID and User ID to the returned table so we could join the hashtag back to it's source tweet
select
    raw_status:user:name::text as user_name,
    raw_status:id as tweet_id,
    value:text::varchar as hashtag_used
from
    tweet_ingest,
    lateral flatten (input => raw_status:entities:hashtags);
create
    or replace view social_media_floodgates.public.urls_normalized as (
        select
            raw_status:user:name::text as user_name,
            raw_status:id as tweet_id,
            value:display_url::text as url_used
        from
            tweet_ingest,
            lateral flatten (input => raw_status:entities:urls)
    );
select
    *
from
    social_media_floodgates.public.urls_normalized create
    or replace view social_media_floodgates.public.HASHTAGS_NORMALIZED as (
        select
            raw_status:user:name::text as user_name,
            raw_status:id as tweet_id,
            value:text::varchar as hashtag_used
        from
            tweet_ingest,
            lateral flatten (input => raw_status:entities:hashtags)
    );
select
    *
from
    social_media_floodgates.public.HASHTAGS_NORMALIZED
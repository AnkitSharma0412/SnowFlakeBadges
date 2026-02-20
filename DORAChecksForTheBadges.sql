create
or replace api integration dora_api_integration api_provider = aws_api_gateway api_aws_role_arn = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole' enabled = true api_allowed_prefixes = (
    'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora'
);
create
or replace external function util_db.public.grader(
    step varchar,
    passed boolean,
    actual integer,
    expected integer,
    description varchar
) returns variant api_integration = dora_api_integration context_headers = (
    current_timestamp,
    current_account,
    current_statement,
    current_account_name
) as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader' use role accountadmin;
use database util_db;
use schema public;
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DORA_IS_WORKING' as step,(
                select
                    123
            ) as actual,
            123 as expected,
            'Dora is working!' as description
    );;
select
    *
from
    garden_plants.information_schema.schemata;
SELECT
    *
FROM
    GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where
    schema_name in ('FLOWERS', 'FRUITS', 'VEGGIES');
select
    count(*) as schemas_found,
    '3' as schemas_expected
from
    GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where
    schema_name in ('FLOWERS', 'FRUITS', 'VEGGIES');
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW01' as step,(
                select
                    count(*)
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
                where
                    schema_name in ('FLOWERS', 'VEGGIES', 'FRUITS')
            ) as actual,
            3 as expected,
            'Created 3 Garden Plant schemas' as description
    );
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW02' as step,(
                select
                    count(*)
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
                where
                    schema_name = 'PUBLIC'
            ) as actual,
            0 as expected,
            'Deleted PUBLIC schema.' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW03' as step,(
                select
                    count(*)
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'ROOT_DEPTH'
            ) as actual,
            1 as expected,
            'ROOT_DEPTH Table Exists' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW04' as step,(
                select
                    count(*) as SCHEMAS_FOUND
                from
                    UTIL_DB.INFORMATION_SCHEMA.SCHEMATA
            ) as actual,
            2 as expected,
            'UTIL_DB Schemas' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW05' as step,(
                select
                    row_count
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'ROOT_DEPTH'
            ) as actual,
            3 as expected,
            'ROOT_DEPTH row count' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW06' as step,(
                select
                    count(*)
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'VEGETABLE_DETAILS'
            ) as actual,
            1 as expected,
            'VEGETABLE_DETAILS Table' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW07' as step,(
                select
                    row_count
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'VEGETABLE_DETAILS'
            ) as actual,
            41 as expected,
            'VEG_DETAILS row count' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW08' as step,(
                select
                    iff(count(*) = 0, 0, count(*) / count(*))
                from
                    table(information_schema.query_history())
                where
                    query_text like 'execute NOTEBOOK%Uncle Yer%'
            ) as actual,
            1 as expected,
            'Notebook success!' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW09' as step,(
                select
                    iff(count(*) = 0, 0, count(*) / count(*))
                from
                    snowflake.account_usage.query_history
                where
                    query_text like 'execute streamlit "GARDEN_PLANTS"."FRUITS".%'
            ) as actual,
            1 as expected,
            'SiS App Works' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW10' as step,(
                select
                    count(*)
                from
                    UTIL_DB.INFORMATION_SCHEMA.stages
                where
                    stage_name = 'MY_INTERNAL_STAGE'
                    and stage_type is null
            ) as actual,
            1 as expected,
            'Internal stage created' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW11' as step,(
                select
                    row_count
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'VEGETABLE_DETAILS_SOIL_TYPE'
            ) as actual,
            42 as expected,
            'Veg Det Soil Type Count' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW12' as step,(
                select
                    row_count
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT'
            ) as actual,
            41 as expected,
            'Veg Detail Plant Height Count' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW13' as step,(
                select
                    row_count
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'LU_SOIL_TYPE'
            ) as actual,
            8 as expected,
            'Soil Type Look Up Table' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW14' as step,(
                select
                    count(*)
                from
                    GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS
                where
                    FILE_FORMAT_NAME = 'L9_CHALLENGE_FF'
                    and FIELD_DELIMITER = '\t'
            ) as actual,
            1 as expected,
            'Challenge File Format Created' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW15' as step,(
                select
                    count(*)
                from
                    LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba
                    join LIBRARY_CARD_CATALOG.PUBLIC.author a on ba.author_uid = a.author_uid
                    join LIBRARY_CARD_CATALOG.PUBLIC.book b on b.book_uid = ba.book_uid
            ) as actual,
            6 as expected,
            '3NF DB was Created.' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW16' as step,(
                select
                    row_count
                from
                    LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'AUTHOR_INGEST_JSON'
            ) as actual,
            6 as expected,
            'Check number of rows' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW17' as step,(
                select
                    row_count
                from
                    LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'NESTED_INGEST_JSON'
            ) as actual,
            5 as expected,
            'Check number of rows' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW18' as step,(
                select
                    row_count
                from
                    SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'TWEET_INGEST'
            ) as actual,
            9 as expected,
            'Check number of rows' as description
    );
-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DWW19' as step,(
                select
                    count(*)
                from
                    SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS
                where
                    table_name = 'HASHTAGS_NORMALIZED'
            ) as actual,
            1 as expected,
            'Check number of rows' as description
    );
select
    GRADER(
        step,(actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DORA_IS_WORKING' as step,(
                select
                    223
            ) as actual,
            223 as expected,
            'Dora is working!' as description
    );
--DO NOT EDIT BELOW THIS LINE
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW01' as step,(
                select
                    count(*)
                from
                    snowflake.account_usage.databases
                where
                    database_name = 'INTL_DB'
                    and deleted is null
            ) as actual,
            1 as expected,
            'Created INTL_DB' as description
    );
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW02' as step,(
                select
                    count(*)
                from
                    INTL_DB.INFORMATION_SCHEMA.TABLES
                where
                    table_schema = 'PUBLIC'
                    and table_name = 'INT_STDS_ORG_3166'
            ) as actual,
            1 as expected,
            'ISO table created' as description
    );
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW03' as step,(
                select
                    row_count
                from
                    INTL_DB.INFORMATION_SCHEMA.TABLES
                where
                    table_name = 'INT_STDS_ORG_3166'
            ) as actual,
            249 as expected,
            'ISO Table Loaded' as description
    );
--DO NOT EDIT BELOW THIS LINE
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW04' as step,(
                select
                    count(*)
                from
                    INTL_DB.PUBLIC.NATIONS_SAMPLE_PLUS_ISO
            ) as actual,
            249 as expected,
            'Nations Sample Plus Iso' as description
    );
--DO NOT EDIT BELOW THIS LINE
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW05' as step,(
                select
                    row_count
                from
                    INTL_DB.INFORMATION_SCHEMA.TABLES
                where
                    table_schema = 'PUBLIC'
                    and table_name = 'COUNTRY_CODE_TO_CURRENCY_CODE'
            ) as actual,
            265 as expected,
            'CCTCC Table Loaded' as description
    );
--DO NOT EDIT BELOW THIS LINE
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW06' as step,(
                select
                    row_count
                from
                    INTL_DB.INFORMATION_SCHEMA.TABLES
                where
                    table_schema = 'PUBLIC'
                    and table_name = 'CURRENCIES'
            ) as actual,
            151 as expected,
            'Currencies table loaded' as description
    );
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from(
        SELECT
            'CMCW07' as step,(
                select
                    count(*)
                from
                    INTL_DB.PUBLIC.SIMPLE_CURRENCY
            ) as actual,
            265 as expected,
            'Simple Currency Looks Good' as description
    );
-- set your worksheet drop lists to the location of your GRADER function
    --DO NOT EDIT ANYTHING BELOW THIS LINE
    --This DORA Check Requires that you RUN two Statements, one right after the other
    show shares in account;
--the above command puts information into memory that can be accessed using result_scan(last_query_id())
    -- If you have to run this check more than once, always run the SHOW command immediately prior
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'CMCW08' as step,(
                select
                    IFF(count(*) > 0, 1, 0)
                from
                    table(result_scan(last_query_id()))
                where
                    "kind" = 'OUTBOUND'
                    and "database_name" = 'INTL_DB'
            ) as actual,
            1 as expected,
            'Outbound Share Created From INTL_DB' as description
    );
--This DORA Check Requires that you RUN two Statements, one right after the other
    show resource monitors in account;
--the above command puts information into memory that can be accessed using result_scan(last_query_id())
    -- If you have to run this check more than once, always run the SHOW command immediately prior
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'CMCW09' as step,(
                select
                    IFF(count(*) > 0, 1, 0)
                from
                    table(result_scan(last_query_id()))
                where
                    "name" = 'DAILY_3_CREDIT_LIMIT'
                    and "credit_quota" = 3
                    and "frequency" = 'DAILY'
            ) as actual,
            1 as expected,
            'Resource Monitors Exist' as description
    );
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'CMCW12' as step,(
                select
                    count(*)
                from
                    SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS
                where
                    account_name = 'ACME'
                    and region like 'GCP_%'
                    and deleted_on is null
            ) as actual,
            1 as expected,
            'ACME Account Added on GCP Platform' as description
    );
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'CMCW13' as step,(
                select
                    count(*)
                from
                    SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS
                where
                    account_name = 'AUTO_DATA_UNLIMITED'
                    and region like 'AZURE_%'
                    and deleted_on is null
            ) as actual,
            1 as expected,
            'ADU Account Added on AZURE' as description
    );
select
    *
from
    SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS SHOW ORGANIZATION ACCOUNTS;
select
    grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DORA_IS_WORKING' as step,(
                select
                    223
            ) as actual,
            223 as expected,
            'Dora is working!' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW001' as step,(
                select
                    count(*)
                from
                    SMOOTHIES.PUBLIC.FRUIT_OPTIONS
            ) as actual,
            25 as expected,
            'Fruit Options table looks good' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW002' as step,(
                select
                    IFF(count(*) >= 5, 5, 0)
                from
                    (
                        select
                            ingredients
                        from
                            smoothies.public.orders
                        group by
                            ingredients
                    )
            ) as actual,
            5 as expected,
            'At least 5 different orders entered' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW003' as step,(
                select
                    ascii(fruit_name)
                from
                    smoothies.public.fruit_options
                where
                    fruit_name ilike 'z%'
            ) as actual,
            90 as expected,
            'A mystery check for the inquisitive' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW004' as step,(
                select
                    count(*)
                from
                    smoothies.information_schema.columns
                where
                    table_schema = 'PUBLIC'
                    and table_name = 'ORDERS'
                    and column_name = 'ORDER_FILLED'
                    and column_default = 'FALSE'
                    and data_type = 'BOOLEAN'
            ) as actual,
            1 as expected,
            'Order Filled is Boolean' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW005' as step,(
                select
                    IFF(count(*) >= 2, 2, 0) as num_sis_apps
                from
                    (
                        select
                            count(*) as tally
                        from
                            snowflake.account_usage.query_history
                        where
                            query_text like 'execute streamlit%'
                        group by
                            query_text
                    )
            ) as actual,
            2 as expected,
            'There seem to be 2 SiS Apps' as description
    );
set
    this = -10.5;
set
    that = 2;
set
    the_other = 1000;
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW006' as step,(
                select
                    util_db.public.sum_mystery_bag_vars($this, $that, $the_other)
            ) as actual,
            991.5 as expected,
            'Mystery Bag Function Output' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW007' as step,(
                select
                    hash(
                        neutralize_whining('bUt mOm i wAsHeD tHe dIsHes yEsTeRdAy')
                    )
            ) as actual,
            -4759027801154767056 as expected,
            'WHINGE UDF Works' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DABW008' as step,(
                select
                    sum(hash_ing)
                from
                    (
                        select
                            hash(ingredients) as hash_ing
                        from
                            smoothies.public.orders
                        where
                            order_ts is not null
                            and name_on_order is not null
                            and (
                                name_on_order = 'Kevin'
                                and order_filled = FALSE
                                and hash_ing = 7976616299844859825
                            )
                            or (
                                name_on_order = 'Divya'
                                and order_filled = TRUE
                                and hash_ing = -6112358379204300652
                            )
                            or (
                                name_on_order = 'Xi'
                                and order_filled = TRUE
                                and hash_ing = 1016924841131818535
                            )
                    )
            ) as actual,
            2881182761772377708 as expected,
            'Followed challenge lab directions' as description
    );
use role accountadmin;
select
    util_db.public.grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DORA_IS_WORKING' as step,(
                select
                    123
            ) as actual,
            123 as expected,
            'Dora is working!' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW01' as step,(
                select
                    count(*)
                from
                    ZENAS_ATHLEISURE_DB.INFORMATION_SCHEMA.STAGES
                where
                    stage_schema = 'PRODUCTS'
                    and (
                        stage_type = 'Internal Named'
                        and stage_name = ('PRODUCT_METADATA')
                    )
                    or stage_name = ('SWEATSUITS')
            ) as actual,
            2 as expected,
            'Zena stages look good' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW02' as step,(
                select
                    sum(tally)
                from
                    (
                        select
                            count(*) as tally
                        from
                            ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATBAND_PRODUCT_LINE
                        where
                            length(product_code) > 7
                        union
                        select
                            count(*) as tally
                        from
                            ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUIT_SIZES
                        where
                            LEFT(sizes_available, 2) = char(13) || char(10)
                    )
            ) as actual,
            0 as expected,
            'Leave data where it lands.' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW03' as step,(
                select
                    count(*)
                from
                    ZENAS_ATHLEISURE_DB.PRODUCTS.CATALOG
            ) as actual,
            180 as expected,
            'Cross-joined view exists' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW04' as step,(
                select
                    count(*)
                from
                    zenas_athleisure_db.products.catalog_for_website
                where
                    upsell_product_desc not like '%e, Bl%'
            ) as actual,
            6 as expected,
            'Relentlessly resourceful' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW05' as step,(
                select
                    sum(tally)
                from
                    (
                        select
                            count(*) as tally
                        from
                            mels_smoothie_challenge_db.information_schema.stages
                        union all
                        select
                            count(*) as tally
                        from
                            mels_smoothie_challenge_db.information_schema.file_formats
                    )
            ) as actual,
            4 as expected,
            'Camila\'s Trail Data is Ready to Query' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW06' as step,(
                select
                    count(*) as tally
                from
                    mels_smoothie_challenge_db.information_schema.views
                where
                    table_name in ('CHERRY_CREEK_TRAIL', 'DENVER_AREA_TRAILS')
            ) as actual,
            2 as expected,
            'Mel\'s views on the geospatial data from Camila' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW07' as step,(
                select
                    round(max(max_northsouth))
                from
                    MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_AND_BOUNDARIES
            ) as actual,
            40 as expected,
            'Trails Northern Extent' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW08' as step,(
                select
                    truncate(distance_to_melanies)
                from
                    mels_smoothie_challenge_db.locations.denver_bike_shops
                where
                    name like '%Mojo%'
            ) as actual,
            14084 as expected,
            'Bike Shop View Distance Calc works' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW09' as step,(
                select
                    row_count
                from
                    mels_smoothie_challenge_db.information_schema.tables
                where
                    table_schema = 'TRAILS'
                    and table_name = 'SMV_CHERRY_CREEK_TRAIL'
            ) as actual,
            3526 as expected,
            'Secure Materialized View Created' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DLKW10' as step,(
                select
                    row_count
                from
                    MY_ICEBERG_DB.INFORMATION_SCHEMA.TABLES
                where
                    table_catalog = 'MY_ICEBERG_DB'
                    and table_name like 'CCT_%'
                    and table_type = 'BASE TABLE'
            ) as actual,
            100 as expected,
            'Iceberg table created and populated!' as description
    );
use role accountadmin;
select
    util_db.public.grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DORA_IS_WORKING' as step,(
                select
                    123
            ) as actual,
            123 as expected,
            'Dora is working!' as description
    );
-- DO NOT EDIT THIS CODE
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW01' as step,(
                select
                    count(*)
                from
                    ags_game_audience.raw.logs
                where
                    is_timestamp_ntz(to_variant(datetime_iso8601)) = TRUE
            ) as actual,
            250 as expected,
            'Project DB and Log File Set Up Correctly' as description
    );
SELECT
    current_timestamp()
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW02' as step,(
                select
                    sum(tally)
                from(
                        select
                            (count(*) * -1) as tally
                        from
                            ags_game_audience.raw.logs
                        union all
                        select
                            count(*) as tally
                        from
                            ags_game_audience.raw.game_logs
                    )
            ) as actual,
            250 as expected,
            'View is filtered' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW03' as step,(
                select
                    count(*)
                from
                    ags_game_audience.enhanced.logs_enhanced
                where
                    dow_name = 'Sat'
                    and tod_name = 'Early evening'
                    and gamer_name like '%prajina'
            ) as actual,
            2 as expected,
            'Playing the game on a Saturday evening' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW04' as step,(
                select
                    count(*) / iff (count(*) = 0, 1, count(*))
                from
                    table(
                        ags_game_audience.information_schema.task_history (task_name => 'LOAD_LOGS_ENHANCED')
                    )
            ) as actual,
            1 as expected,
            'Task exists and has been run at least once' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW05' as step,(
                select
                    max(tally)
                from
                    (
                        select
                            CASE
                                WHEN SCHEDULED_FROM = 'SCHEDULE'
                                and STATE = 'SUCCEEDED' THEN 1
                                ELSE 0
                            END as tally
                        from
                            table(
                                ags_game_audience.information_schema.task_history (task_name => 'GET_NEW_FILES')
                            )
                    )
            ) as actual,
            1 as expected,
            'Task succeeds from schedule' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW06' as step,(
                select
                    CASE
                        WHEN pipe_status:executionState::text = 'RUNNING' THEN 1
                        ELSE 0
                    END
                from(
                        select
                            parse_json(
                                SYSTEM$PIPE_STATUS('ags_game_audience.raw.PIPE_GET_NEW_FILES')
                            ) as pipe_status
                    )
            ) as actual,
            1 as expected,
            'Pipe exists and is RUNNING' as description
    );
select
    GRADER(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) as graded_results
from
    (
        SELECT
            'DNGW07' as step,(
                select
                    count(*) / count(*)
                from
                    snowflake.account_usage.query_history
                where
                    query_text like '%case when game_session_length < 10%'
            ) as actual,
            1 as expected,
            'Curated Data Lesson completed' as description
    );
alter user ANKIT30DAYCHALLENGE
set
    default_role = 'SYSADMIN';
alter user ANKIT30DAYCHALLENGE
set
    default_warehouse = 'COMPUTE_WH';
alter user ANKIT30DAYCHALLENGE
set
    default_namespace = 'UTIL_DB.PUBLIC';
list @uni_kishore/kickoff;
select
    $1
from
    @uni_kishore/kickoff (file_format => FF_JSON_LOGS);
copy into raw.game_logs
from
    @uni_kishore/kickoff file_format = (format_name = FF_JSON_LOGS);
select
    *
from
    raw.game_logs
select
    raw_log:agent::text as AGENT,
    raw_log:user_event::text as User_Event,
    raw_log:datetime_iso8601::datetime as datetime_iso8601,
    raw_log:user_login::text as user_login,
    *
from
    game_logs;
create view LOGS as
select
    raw_log:agent::text as AGENT,
    raw_log:user_event::text as User_Event,
    raw_log:datetime_iso8601::datetime as datetime_iso8601,
    raw_log:user_login::text as user_login,
    *
from
    game_logs;
--what time zone is your account(and/or session) currently set to? Is it -0700?
select
    current_timestamp();
--worksheets are sometimes called sessions -- we'll be changing the worksheet time zone
    alter session
set
    timezone = 'UTC';
select
    current_timestamp();
--how did the time differ after changing the time zone for the worksheet?
    alter session
set
    timezone = 'Africa/Nairobi';
select
    current_timestamp();
alter session
set
    timezone = 'Pacific/Funafuti';
select
    current_timestamp();
alter session
set
    timezone = 'Asia/Shanghai';
select
    current_timestamp();
--show the account parameter called timezone
    show parameters like 'timezone';
list @uni_kishore
select
    *
from
    game_logs;
copy into raw.game_logs
from
    @uni_kishore/updated_feed file_format = (format_name = FF_JSON_LOGS);
select
    *
from
    LOGS
where
    agent is null;
--looking for empty AGENT column
select
    *
from
    ags_game_audience.raw.LOGS
where
    agent is null;
--looking for non-empty IP_ADDRESS column
select
    RAW_LOG:ip_address::text as IP_ADDRESS,
    *
from
    ags_game_audience.raw.LOGS
where
    RAW_LOG:ip_address::text is not null;
create
    or replace view LOGS as
select
    RAW_LOG:ip_address::text as IP_ADDRESS,
    raw_log:user_event::text as User_Event,
    raw_log:datetime_iso8601::datetime as datetime_iso8601,
    raw_log:user_login::text as user_login,
    *
from
    game_logs
where
    RAW_LOG:ip_address::text is not null;
select
    *
from
    LOGS
WHERE
    USER_LOGIN ilike '%Prajin%'
select
    parse_ip('100.41.16.160', 'inet');
select
    parse_ip('107.217.231.17', 'inet'):family;
select
    parse_ip('107.217.231.17', 'inet'):host;
select
    parse_ip('100.41.16.160', 'inet'):ipv4;
SELECT
    * ILIKE '%ip%'
FROM
    LOGS;
--Look up Kishore and Prajina's Time Zone in the IPInfo share using his headset's IP Address with the PARSE_IP function.
select
    start_ip,
    end_ip,
    start_ip_int,
    end_ip_int,
    city,
    region,
    country,
    timezone
from
    IPINFO_GEOLOC.demo.location
where
    parse_ip('100.41.16.160', 'inet'):ipv4 --Kishore's Headset's IP Address
    BETWEEN start_ip_int
    AND end_ip_int;
--Join the log and location tables to add time zone to each row using the PARSE_IP function.
select
    logs.*,
    loc.city,
    loc.region,
    loc.country,
    loc.timezone
from
    AGS_GAME_AUDIENCE.RAW.LOGS logs
    join IPINFO_GEOLOC.demo.location loc
where
    parse_ip(logs.ip_address, 'inet'):ipv4 BETWEEN start_ip_int
    AND end_ip_int;
--Use two functions supplied by IPShare to help with an efficient IP Lookup Process!
SELECT
    logs.ip_address,
    logs.user_login,
    logs.user_event,
    logs.datetime_iso8601,
    city,
    region,
    country,
    timezone,
    convert_timezone('UTC', timezone, logs.datetime_iso8601) as GAME_EVENT_LTZ,
    dayname(GAME_EVENT_LTZ) as DOW_NAME
from
    AGS_GAME_AUDIENCE.RAW.LOGS logs
    JOIN IPINFO_GEOLOC.demo.location loc ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
    AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
    AND end_ip_int;
create table ags_game_audience.raw.time_of_day_lu (hour number, tod_name varchar(25));
--insert statement to add all 24 rows to the table
insert into
    time_of_day_lu
values
    (6, 'Early morning'),
    (7, 'Early morning'),
    (8, 'Early morning'),
    (9, 'Mid-morning'),
    (10, 'Mid-morning'),
    (11, 'Late morning'),
    (12, 'Late morning'),
    (13, 'Early afternoon'),
    (14, 'Early afternoon'),
    (15, 'Mid-afternoon'),
    (16, 'Mid-afternoon'),
    (17, 'Late afternoon'),
    (18, 'Late afternoon'),
    (19, 'Early evening'),
    (20, 'Early evening'),
    (21, 'Late evening'),
    (22, 'Late evening'),
    (23, 'Late evening'),
    (0, 'Late at night'),
    (1, 'Late at night'),
    (2, 'Late at night'),
    (3, 'Toward morning'),
    (4, 'Toward morning'),
    (5, 'Toward morning');
--Check your table to see if you loaded it properly
select
    tod_name,
    listagg(hour, ',')
from
    time_of_day_lu
group by
    tod_name;
--Use two functions supplied by IPShare to help with an efficient IP Lookup Process!
SELECT
    logs.ip_address,
    logs.user_login as GAMER_NAME,
    logs.user_event as GAME_EVENT_NAME,
    logs.datetime_iso8601 as GAME_EVENT_UTC,
    city,
    region,
    country,
    timezone as GAMER_LTZ_NAME,
    convert_timezone('UTC', timezone, logs.datetime_iso8601) as GAME_EVENT_LTZ,
    dayname(GAME_EVENT_LTZ) as DOW_NAME,
    TOD_NAME
from
    AGS_GAME_AUDIENCE.RAW.LOGS logs
    JOIN IPINFO_GEOLOC.demo.location loc ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
    AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
    AND end_ip_int
    join time_of_day_lu on HOUR(GAME_EVENT_LTZ) = time_of_day_lu.hour;
create table ags_game_audience.enhanced.logs_enhanced as(
        SELECT
            logs.ip_address,
            logs.user_login as GAMER_NAME,
            logs.user_event as GAME_EVENT_NAME,
            logs.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            convert_timezone('UTC', timezone, logs.datetime_iso8601) as GAME_EVENT_LTZ,
            dayname(GAME_EVENT_LTZ) as DOW_NAME,
            TOD_NAME
        from
            AGS_GAME_AUDIENCE.RAW.LOGS logs
            JOIN IPINFO_GEOLOC.demo.location loc ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
            AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            join time_of_day_lu on HOUR(GAME_EVENT_LTZ) = time_of_day_lu.hour
    );
select
    *
from
    ags_game_audience.enhanced.logs_enhanced;
--first we dump all the rows out of the table
    truncate table ags_game_audience.enhanced.LOGS_ENHANCED;
--then we put them all back in
INSERT INTO
    ags_game_audience.enhanced.LOGS_ENHANCED (
        SELECT
            logs.ip_address,
            logs.user_login as GAMER_NAME,
            logs.user_event as GAME_EVENT_NAME,
            logs.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.LOGS logs
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    );
--Hey! We should do this every 5 minutes from now until the next millennium - Y3K!!!
    --Alexa, play Yeah by Usher!
    --clone the table to save this version as a backup (BU stands for Back Up)
    create table ags_game_audience.enhanced.LOGS_ENHANCED_BU clone ags_game_audience.enhanced.LOGS_ENHANCED;
MERGE INTO ENHANCED.LOGS_ENHANCED e USING RAW.LOGS r ON r.user_login = e.GAMER_NAME
    and r.datetime_iso8601 = e.GAME_EVENT_UTC
    and r.user_event = e.GAME_EVENT_NAME
    WHEN MATCHED THEN
UPDATE
SET
    IP_ADDRESS = 'Hey I updated matching rows!';
select
    *
from
    ENHANCED.LOGS_ENHANCED MERGE INTO ags_game_audience.enhanced.LOGS_ENHANCED e USING (
        SELECT
            logs.ip_address,
            logs.user_login as GAMER_NAME,
            logs.user_event as GAME_EVENT_NAME,
            logs.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.LOGS logs
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    ) r --we'll put our fancy select here
    ON r.GAMER_NAME = e.GAMER_NAME
    and r.game_event_utc = e.game_event_utc
    and r.game_event_name = e.game_event_name
    WHEN NOT MATCHED THEN
insert
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    ) --list of columns
values
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );
--list of columns (but we can mark as coming from the r select)
    use role accountadmin;
    --You have to run this grant or you won't be able to test your tasks while in SYSADMIN role
    --this is true even if SYSADMIN owns the task!!
    grant execute task on account to role SYSADMIN;
use role sysadmin;
--Now you should be able to run the task, even if your role is set to SYSADMIN
    execute task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
--the SHOW command might come in handy to look at the task
    show tasks in account;
--you can also look at any task more in depth using DESCRIBE
    describe task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
create
    or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED warehouse = COMPUTE_WH schedule = '5 minute' as
INSERT INTO
    AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
SELECT
    logs.ip_address,
    logs.user_login as GAMER_NAME,
    logs.user_event as GAME_EVENT_NAME,
    logs.datetime_iso8601 as GAME_EVENT_UTC,
    city,
    region,
    country,
    timezone as GAMER_LTZ_NAME,
    CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
    DAYNAME(game_event_ltz) as DOW_NAME,
    TOD_NAME
from
    ags_game_audience.raw.LOGS logs
    JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
    AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
    AND end_ip_int
    JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour;
--let's truncate so we can start the load over again
    truncate table AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
select
    *
from
    ags_game_audience.enhanced.LOGS_ENHANCED;
create
    or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED warehouse = COMPUTE_WH schedule = '5 minute' as MERGE INTO ags_game_audience.enhanced.LOGS_ENHANCED e USING (
        SELECT
            logs.ip_address,
            logs.user_login as GAMER_NAME,
            logs.user_event as GAME_EVENT_NAME,
            logs.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.LOGS logs
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    ) r --we'll put our fancy select here
    ON r.GAMER_NAME = e.GAMER_NAME
    and r.game_event_utc = e.game_event_utc
    and r.game_event_name = e.game_event_name
    WHEN NOT MATCHED THEN
insert
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    ) --list of columns
values
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );
select
    *
from
    AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
create
    or replace TABLE AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS (RAW_LOG VARIANT);
copy into raw.PL_GAME_LOGS
from
    @UNI_KISHORE_PIPELINE file_format = (format_name = FF_JSON_LOGS);
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES;
select
    count(*)
from
    PL_GAME_LOGS;
select
    *
from
    PL_GAME_LOGS;
create
    or replace view AGS_GAME_AUDIENCE.RAW.PL_LOGS(
        IP_ADDRESS,
        USER_EVENT,
        DATETIME_ISO8601,
        USER_LOGIN,
        RAW_LOG
    ) as
select
    RAW_LOG:ip_address::text as IP_ADDRESS,
    raw_log:user_event::text as User_Event,
    raw_log:datetime_iso8601::datetime as datetime_iso8601,
    raw_log:user_login::text as user_login,
    *
from
    PL_GAME_LOGS
where
    RAW_LOG:ip_address::text is not null;
select
    *
from
    PL_LOGS create
    or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED warehouse = COMPUTE_WH schedule = '5 minute' as MERGE INTO ags_game_audience.enhanced.LOGS_ENHANCED e USING (
        SELECT
            logs.ip_address,
            logs.user_login as GAMER_NAME,
            logs.user_event as GAME_EVENT_NAME,
            logs.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.ED_PL_LOGS logs
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    ) r --we'll put our fancy select here
    ON r.GAMER_NAME = e.GAMER_NAME
    and r.game_event_utc = e.game_event_utc
    and r.game_event_name = e.game_event_name
    WHEN NOT MATCHED THEN
insert
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    ) --list of columns
values
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );
truncate table ags_game_audience.enhanced.LOGS_ENHANCED;
select
    *
from
    ags_game_audience.enhanced.LOGS_ENHANCED;
--Turning on a task is done with a RESUME command
    alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES resume;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED resume;
--Turning OFF a task is done with a SUSPEND command
    alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES suspend;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED suspend;
--Step 1 - how many files in the bucket?
    list @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE;
--Step 2 - number of rows in raw table (should be file count x 10)
select
    count(*)
from
    AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS;
--Step 3 - number of rows in raw view (should be file count x 10)
select
    count(*)
from
    AGS_GAME_AUDIENCE.RAW.PL_LOGS;
--Step 4 - number of rows in enhanced table (should be file count x 10 but fewer rows is okay because not all IP addresses are available from the IPInfo share)
select
    count(*)
from
    AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
use role accountadmin;
grant EXECUTE MANAGED TASK on account to SYSADMIN;
--switch back to sysadmin
    use role sysadmin;
create
    or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL' SCHEDULE = '5 Minutes' as MERGE INTO ags_game_audience.enhanced.LOGS_ENHANCED e USING (
        SELECT
            logs.ip_address,
            logs.user_login as GAMER_NAME,
            logs.user_event as GAME_EVENT_NAME,
            logs.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.ED_PIPELINE_LOGS logs
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    ) r --we'll put our fancy select here
    ON r.GAMER_NAME = e.GAMER_NAME
    and r.game_event_utc = e.game_event_utc
    and r.game_event_name = e.game_event_name
    WHEN NOT MATCHED THEN
insert
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    ) --list of columns
values
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );
create
    or replace task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL' schedule = '5 Minutes' as copy into raw.PL_GAME_LOGS
from
    @UNI_KISHORE_PIPELINE file_format = (format_name = FF_JSON_LOGS);
create table ED_PIPELINE_LOGS as
SELECT
    METADATA$FILENAME as log_file_name --new metadata column
,
    METADATA$FILE_ROW_NUMBER as log_file_row_id --new metadata column
,
    current_timestamp(0) as load_ltz --new local time of load
,
    get($1, 'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601,
    get($1, 'user_event')::text as USER_EVENT,
    get($1, 'user_login')::text as USER_LOGIN,
    get($1, 'ip_address')::text as IP_ADDRESS
FROM
    @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE (file_format => 'ff_json_logs');
select
    *
from
    ED_PIPELINE_LOGS;
--truncate the table rows that were input during the CTAS, if you used a CTAS and didn't recreate it with shorter VARCHAR fields
    truncate table ED_PIPELINE_LOGS;
--reload the table using your COPY INTO
    COPY INTO ED_PIPELINE_LOGS
FROM
    (
        SELECT
            METADATA$FILENAME as log_file_name,
            METADATA$FILE_ROW_NUMBER as log_file_row_id,
            current_timestamp(0) as load_ltz,
            get($1, 'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601,
            get($1, 'user_event')::text as USER_EVENT,
            get($1, 'user_login')::text as USER_LOGIN,
            get($1, 'ip_address')::text as IP_ADDRESS
        FROM
            @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
    ) file_format = (format_name = ff_json_logs);
CREATE
    OR REPLACE PIPE PIPE_GET_NEW_FILES auto_ingest = true aws_sns_topic = 'arn:aws:sns:us-west-2:321463406630:dngw_topic' AS COPY INTO ED_PIPELINE_LOGS
FROM
    (
        SELECT
            METADATA$FILENAME as log_file_name,
            METADATA$FILE_ROW_NUMBER as log_file_row_id,
            current_timestamp(0) as load_ltz,
            get($1, 'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601,
            get($1, 'user_event')::text as USER_EVENT,
            get($1, 'user_login')::text as USER_LOGIN,
            get($1, 'ip_address')::text as IP_ADDRESS
        FROM
            @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
    ) file_format = (format_name = ff_json_logs);
select
    parse_json(
        SYSTEM$PIPE_STATUS('ags_game_audience.raw.PIPE_GET_NEW_FILES')
    );
--create a stream that will keep track of changes to the table
    create
    or replace stream ags_game_audience.raw.ed_cdc_stream on table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;
--look at the stream you created
    show streams;
--check to see if any changes are pending (expect FALSE the first time you run it)
    --after the Snowpipe loads a new file, expect to see TRUE
select
    system$stream_has_data('ed_cdc_stream');
--query the stream
select
    *
from
    ags_game_audience.raw.ed_cdc_stream;
--check to see if any changes are pending
select
    system$stream_has_data('ed_cdc_stream');
--if your stream remains empty for more than 10 minutes, make sure your PIPE is running
select
    SYSTEM$PIPE_STATUS('PIPE_GET_NEW_FILES');
--make a note of how many rows are in the stream
select
    *
from
    ags_game_audience.raw.ed_cdc_stream;
--process the stream by using the rows in a merge
    MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e USING (
        SELECT
            cdc.ip_address,
            cdc.user_login as GAMER_NAME,
            cdc.user_event as GAME_EVENT_NAME,
            cdc.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, cdc.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.ed_cdc_stream cdc
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(cdc.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(cdc.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    ) r ON r.GAMER_NAME = e.GAMER_NAME
    AND r.GAME_EVENT_UTC = e.GAME_EVENT_UTC
    AND r.GAME_EVENT_NAME = e.GAME_EVENT_NAME
    WHEN NOT MATCHED THEN
INSERT
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    )
VALUES
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );
--Did all the rows from the stream disappear?
select
    *
from
    ags_game_audience.raw.ed_cdc_stream;
--Create a new task that uses the MERGE you just tested
    create
    or replace task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL' SCHEDULE = '5 minutes'
    when system$stream_has_data('ed_cdc_stream') as MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e USING (
        SELECT
            cdc.ip_address,
            cdc.user_login as GAMER_NAME,
            cdc.user_event as GAME_EVENT_NAME,
            cdc.datetime_iso8601 as GAME_EVENT_UTC,
            city,
            region,
            country,
            timezone as GAMER_LTZ_NAME,
            CONVERT_TIMEZONE('UTC', timezone, cdc.datetime_iso8601) as game_event_ltz,
            DAYNAME(game_event_ltz) as DOW_NAME,
            TOD_NAME
        from
            ags_game_audience.raw.ed_cdc_stream cdc
            JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(cdc.ip_address) = loc.join_key
            AND ipinfo_geoloc.public.TO_INT(cdc.ip_address) BETWEEN start_ip_int
            AND end_ip_int
            JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
    ) r ON r.GAMER_NAME = e.GAMER_NAME
    AND r.GAME_EVENT_UTC = e.GAME_EVENT_UTC
    AND r.GAME_EVENT_NAME = e.GAME_EVENT_NAME
    WHEN NOT MATCHED THEN
INSERT
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    )
VALUES
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );
--Resume the task so it is running
    alter task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED suspend;
alter pipe PIPE_GET_NEW_FILES
set
    pipe_execution_paused = true;
select
    GAMER_NAME,
    listagg(GAME_EVENT_LTZ, ' / ') as login_and_logout
from
    AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
group by
    gamer_name;
select
    GAMER_NAME,
    game_event_ltz as login,
    lead(game_event_ltz) OVER (
        partition by GAMER_NAME
        order by
            GAME_EVENT_LTZ
    ) as logout,
    coalesce(datediff('mi', login, logout), 0) as game_session_length
from
    AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
order by
    game_session_length desc;
use role sysadmin;
use schema dev_db.consumption_sch;
use warehouse adhoc_wh;


-- date dim
-- level-1 
select 
        index_record_ts as measurement_time,
        year(index_record_ts) as aqi_year,
        month(index_record_ts) as aqi_month,
        quarter(index_record_ts) as aqi_quarter,
        day(index_record_ts) aqi_day,
        hour(index_record_ts) aqi_hour,
    from 
        dev_db.clean_sch.clean_flatten_aqi_dt
        group by 1,2,3,4,5,6;

with step01_hr_data as (
select 
        index_record_ts as measurement_time,
        year(index_record_ts) as aqi_year,
        month(index_record_ts) as aqi_month,
        quarter(index_record_ts) as aqi_quarter,
        day(index_record_ts) aqi_day,
        hour(index_record_ts)+1 aqi_hour,
    from 
        dev_db.clean_sch.clean_flatten_aqi_dt
        group by 1,2,3,4,5,6
)
select 
    hash(measurement_time) as date_pk,
    *
from step01_hr_data
order by aqi_year,aqi_month,aqi_day,aqi_hour;


create or replace dynamic table date_dim
    target_lag='DOWNSTREAM'
    warehouse=transform_wh
as
with step01_hr_data as (
select 
        index_record_ts as measurement_time,
        year(index_record_ts) as aqi_year,
        month(index_record_ts) as aqi_month,
        quarter(index_record_ts) as aqi_quarter,
        day(index_record_ts) aqi_day,
        hour(index_record_ts)+1 aqi_hour,
    from 
        dev_db.clean_sch.clean_flatten_aqi_dt
        group by 1,2,3,4,5,6
)
select 
    hash(measurement_time) as date_pk,
    *
from step01_hr_data
order by aqi_year,aqi_month,aqi_day,aqi_hour;

select * from date_dim;



-- location dim
-- step-1
select 
    LATITUDE,
    LONGITUDE,
    COUNTRY,
    STATE,
    CITY,
    STATION,
from 
    dev_db.clean_sch.clean_flatten_aqi_dt
    group by 1,2,3,4,5,6;

-- step-2 with 

with step01_unique_data as (
select 
    LATITUDE,
    LONGITUDE,
    COUNTRY,
    STATE,
    CITY,
    STATION,
from 
    dev_db.clean_sch.clean_flatten_aqi_dt
    group by 1,2,3,4,5,6
)
select 
    hash(LATITUDE,LONGITUDE) as location_pk,
    *
from step01_unique_data
order by 
    country, STATE, city, station;


create or replace dynamic table location_dim
    target_lag='DOWNSTREAM'
    warehouse=transform_wh
as
with step01_unique_data as (
select 
    LATITUDE,
    LONGITUDE,
    COUNTRY,
    STATE,
    CITY,
    STATION,
from 
    dev_db.clean_sch.clean_flatten_aqi_dt
    group by 1,2,3,4,5,6
)
select 
    hash(LATITUDE,LONGITUDE) as location_id,
    *
from step01_unique_data
order by 
    country, STATE, city, station;


-- fact table
-- step-01
select 
        index_record_ts,
        year(index_record_ts) as aqi_year,
        month(index_record_ts) as aqi_month,
        quarter(index_record_ts) as aqi_quarter,
        day(index_record_ts) aqi_day,
        hour(index_record_ts) aqi_hour,
        country,
        state,
        city,
        station,
        latitude,
        longitude,
        pm10_avg,
        pm25_avg,
        so2_avg,
        no2_avg,
        nh3_avg,
        co_avg,
        o3_avg,
        prominent_index(PM25_AVG,PM10_AVG,SO2_AVG,NO2_AVG,NH3_AVG,CO_AVG,O3_AVG)as prominent_pollutant,
        case
        when three_sub_index_criteria(PM25_AVG,PM10_AVG,SO2_AVG,NO2_AVG,NH3_AVG,CO_AVG,O3_AVG) > 2 then greatest (get_int(PM25_AVG),get_int(PM10_AVG),get_int(SO2_AVG),get_int(NO2_AVG),get_int(NH3_AVG),get_int(CO_AVG),get_int(O3_AVG))
        else 0
        end
    as AQI
    from dev_db.clean_sch.clean_flatten_aqi_dt
    limit 1000;
    


-- level-02
select 
        hash(index_record_ts) as date_fk,
        hash(latitude,longitude) as location_fk
        pm10_avg,
        pm25_avg,
        so2_avg,
        no2_avg,
        nh3_avg,
        co_avg,
        o3_avg,
        prominent_index(pm25_avg,pm10_avg,so2_avg,no2_avg,nh3_avg,co_avg,o3_avg)as prominent_pollutant,
        case
        when three_sub_index_criteria(pm25_avg,pm10_avg,so2_avg,no2_avg,nh3_avg,co_avg,o3_avg) > 2 then greatest (get_int(pm25_avg),get_int(pm10_avg),get_int(so2_avg),get_int(no2_avg),get_int(nh3_avg),get_int(co_avg),get_int(o3_avg))
        else 0
        end
    as aqi
    from dev_db.clean_sch.clean_flatten_aqi_dt
    where 
        city = 'Chittoor' and 
        station =  'Gangineni Cheruvu, Chittoor - APPCB' and 
        INDEX_RECORD_TS = '2024-03-01 18:00:00.000';
        
select * from date_dim where date_id = 1635727249877756006;
select * from location_dim where location_id = 3830234801511030131;

create or replace dynamic table air_quality_fact
    target_lag='30 min'
    warehouse=transform_wh
as
select 
        hash(index_record_ts,latitude,longitude) aqi_pk,
        hash(index_record_ts) as date_fk,
        hash(latitude,longitude) as location_fk,
        pm10_avg,
        pm25_avg,
        so2_avg,
        no2_avg,
        nh3_avg,
        co_avg,
        o3_avg,
        prominent_index(pm25_avg,pm10_avg,so2_avg,no2_avg,nh3_avg,co_avg,o3_avg)as prominent_pollutant,
        case
        when three_sub_index_criteria(pm25_avg,pm10_avg,so2_avg,no2_avg,nh3_avg,co_avg,o3_avg) > 2 then greatest (pm25_avg,pm10_avg,so2_avg,no2_avg,nh3_avg,co_avg,o3_avg)
        else 0
        end
    as aqi
    from dev_db.clean_sch.clean_flatten_aqi_dt
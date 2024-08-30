# Import python packages
import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

# Page Title
st.title("AQI Trend- By State/City/Day Level")
st.write("This streamlit app hosted on Snowflake Cloud Data Warehouse Platform")

# Get Session
session = get_active_session()

# variables to hold the selection parameters, initiating as empty string
state_option,city_option, date_option  = '','',''

# query to get distinct states from agg_city_fact_hour_level table
state_query = """
    select state from DEV_DB.CONSUMPTION_SCH.AGG_CITY_FACT_HOUR_LEVEL 
    group by state 
    order by 1 desc
"""

# execute query using sql api and execute it by calling collect function.
state_list = session.sql(state_query).collect()
symbols = [row[0] for row in state_list]

# use the selectbox api to render the states
state_option = st.selectbox('Select State',options=symbols)

#check the selection
if (state_option is not None and len(state_option) > 1):

    # query to get distinct cities from agg_city_fact_hour_level table
    city_query = f"""
    select city from DEV_DB.CONSUMPTION_SCH.AGG_CITY_FACT_HOUR_LEVEL 
    where 
    state = '{state_option}' group by city
    order by 1 desc
    """
    # execute query using sql api and execute it by calling collect function.
    city_list = session.sql(city_query).collect()
    symbols_city = [row[0] for row in city_list]

    # use the selectbox api to render the cities
    city_option = st.selectbox('Select City',symbols_city)

if (city_option is not None and len(city_option) > 1):
    date_query = f"""
    select date(measurement_time) as measurement_date from DEV_DB.CONSUMPTION_SCH.AGG_CITY_FACT_HOUR_LEVEL 
        where 
            state = '{state_option}' and
            city = '{city_option}'
        group by measurement_date
        order by 1 desc;
    """
    date_list = session.sql(date_query).collect()
    symbols_date = [row[0] for row in date_list]
    date_option = st.selectbox('Select Date',symbols_date)

if (date_option is not None):
    trend_sql = f"""
    select 
        hour(measurement_time) as Hour,
        PM25_AVG,
        PM10_AVG,
        SO2_AVG,
        NO2_AVG,
        NH3_AVG,
        CO_AVG,
        O3_AVG
    from 
        dev_db.consumption_sch.agg_city_fact_hour_level
    where 
        state = '{state_option}' and
        city = '{city_option}' and 
        date(measurement_time) = '{date_option}'
    order by measurement_time
    """
    sf_df = session.sql(trend_sql).collect()

    # create panda's dataframe
    pd_df =pd.DataFrame(
        sf_df,
        columns=['Hour','PM2.5','PM10','SO3','CO','NO2','NH3','O3'])
    
    #draw charts
    st.bar_chart(pd_df,x='Hour')
    st.divider()
    st.line_chart(pd_df,x='Hour')
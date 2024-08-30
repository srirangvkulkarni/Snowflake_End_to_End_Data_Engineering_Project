# Snowflake_End_to_End_Data_Engineering_Project
Objective is to create an interactive dashboard that aggregates air quality index(AQI) data from Indian Govt website(Data.gov.in) where users can access current and historical  air quality index and pollutant level at any given hour in the past.

In this project, we ingest AQI(Air Quality Index) data from 'Data.gov.in' website through API and feed it to Snowflake in real-time that will power an in-built dashboard utility in Snowflake to obtain current and historical air quality index and pollutant level from all over India.

𝗗𝗮𝘁𝗮 𝗣𝗶𝗽𝗲𝗹𝗶𝗻𝗲:<br />
A data pipeline is a technique for transferring data from one system to another. The data may or may not be updated, and it may be handled in real-time (or streaming) rather than in batches. The data pipeline encompasses everything from harvesting or acquiring data using various methods to storing raw data, cleaning, validating, and transforming data into a query-worthy format, displaying KPIs, and managing the above process.

𝗗𝗮𝘁𝗮𝘀𝗲𝘁 𝗗𝗲𝘀𝗰𝗿𝗶𝗽𝘁𝗶𝗼𝗻:<br />
We will use the API from 'Data.gov.in' and fetch AQI data in JSON format using Python.

𝗧𝗲𝗰𝗵 𝗦𝘁𝗮𝗰𝗸:<br />
➔Language: Python, SQL<br />
➔Services: Snowflake, Snowpark, GitHub Action, Streamlit<br />

𝗦𝗻𝗼𝘄𝗳𝗹𝗮𝗸𝗲:<br />
Snowflake is a cloud native data platform offered as a service(SaaS). Snowflake delivers all the features of an enterprise analytic database to the user. <br />
Snowflake components used in this project are<br />
➔Virtual Warehouse<br />
➔Database & Schema<br />
➔Dynamic Table to create DAG
➔Internal Stage
➔Snowflake User Defined Functions
➔Snowflake File Formats
➔Task
➔Snowpark
➔Streamlit in Snowflake



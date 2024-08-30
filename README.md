# Snowflake End to End Data Engineering Project
Objective is to create an interactive dashboard that aggregates Air Quality Index(AQI) data from Indian Govt website(Data.gov.in) where users can access current and historical  air quality index and pollutant level of any city in India at any given hour in the past.

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
➔Dynamic Table to create DAG<br />
➔Internal Stage<br />
➔Snowflake User Defined Functions<br />
➔Snowflake File Formats<br />
➔Task<br />
➔Snowpark<br />
➔Streamlit in Snowflake<br />

<strong>Approach:</strong><br />
➔ We write API Calls to fetch AQI data in JSON format from Indian Govt. website 'Data.gov.in' using Python. This python code is kept in **Github Action** to automate the process of fetching JSON files every hour and loading them to Snowflake Stages(Raw_data).<br />

➔The data that has landed on Snowflake Stage is the raw data and we call it as Landing Layer.<br />

➔The data is then flattened/cleaned and is made available in table format, we call this layer as Clean Layer.<br />

➔Using Star Schema Dimensional Modelling approach we create fact and dimensional tables and data is now ready for consumption, we call this layer as Consumption Layer.<br />

➔We create aggregated fact table that stores pre-computed summary data derived from fact tables of consumption layer and is used in creating dashboard, we call this layer as Publish layer.<br />

➔ The data available in Publish layer is used in creating Dashboard. Streamlit in Snowflake has been used to create dashboard where users can access real time and historical data from it.<br />

<img width="1202" alt="Layered-Architecture-Standard-Names" src="https://github.com/user-attachments/assets/f0be8be0-a91f-4232-8f9b-47de54b59044"> <br />


𝗞𝗲𝘆 𝗧𝗮𝗸𝗲𝗮𝘄𝗮𝘆𝘀:<br />

● Understanding the project overview.<br />
● Creating GitHub Action Workflow using YAML extension.<br />
● Creating Snowflake Database Objects such as Tasks,Dynamic Tables(which inturn creates a DAG),Stages, UDF.<br />
● Implementing Star Schema Dimensional modelling to create fact and dimension tables.<br />
● Creating Streamlit in Snowflake Dashboard.<br />










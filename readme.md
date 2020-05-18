# IMDB MOVIES DATAWAREHOUSE project
# Deliverables
Data model (visual diagram)
Implementation (whatever tools and tech stack you want to actually move the data from files to warehouse)
Supporting documentation

# Summary of approach
I initially reviewed the dataset documentation on Kaggle to understand the business significance. I subsequently ingested the data into a staging table in a SQL Server Database using Microsoft SQL server built in ETL tool. I performed exploratory analysis on the data to determine the relationships between table, cardinality and data quality. Then I designed the data model for the Datawarehouse and populated the tables with the staging data using some transformation logic when needed. I also fine tuned the integrity constraints needed to main relational model for the Datawarehouse. Also applied performance and optimization best practice when needed to the tables like added indexes. Finally, I would create a Source to Target mapping documentation on the data flow and transformation for the support team and data lineage analysis.

Please see word document that contains full details on the ETL and modelling

![Data Model](/images/datamodel.PNG)


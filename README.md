# **Social Media Data Analysis - dbt™ Modeling Challenge**

Project for the dbt™ data modeling challenge, Hosted by Paradime!

*Prepared by **✋ [Işın Pesch](https://www.linkedin.com/in/isin-pesch-32b489163/)***

## **Table of Contents**
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## **Introduction**
This project focuses on driving Travel related insights from Instagram posts and correlates them to real life tourist activity.
Instagram is chosen for the main social media source as it is one of the biggest platforms for travel bloggers and influencers.

# **Data Sources and Data Lineage 🕸️**
All datasets in this project are completely new. Some of them are downloaded and uploaded via python scripts, some are directly
uploaded to Paradime as seed files.

### **Sources and Seeds**
- *`instagram_data`* (main social media dataset)

This dataset is downloaded using the python script *`instagram_data_download.py`* from Hugging Face.
It is then uploaded back to Motherduck `RAW` db using *`instagram_data_upload.py`*. Python script is used as this dataset contains over 17M rows and needed a batch upload.

- *`world_cities_countries.csv`*

This dataset contains the top 50.000 most populated cities in the world. Together with the country they are in and their population numbers.
It is downloaded using *`get_world_cities_countries.py`* from `geonamescache` pyhton library and then
uploaded as a seed file.

- *`global_tourism_data.csv`*

This dataset contains the international arrivals of each country over the XXX years sourced from Kaggle
It is uploaded as a seed file.

- *`common_english_words.csv`*

This is a chatgpt generated csv where top 500 common english words are written.
It is uploaded as a seed file.

### **Staging Layer**
This layer contains the below models and used for light transformations of the source models and standardizes the column names.
- *`stg_instagram_data`* 
- *`stg_world_cities_countries`*
- *`stg_global_tourism_data`* 

### **Intermediate Layer**
Main transformation layer that prepares the models to be consumed in the analytics layer.
- *`int_city_mentions`* (Extracts the country names from the instagram posts)
- *`int_country_mentions`* (Extracts the city names from the instagram posts)
- *`int_instagrammable_destinations`* (Brings the city mentions and country mentions together with the instagram post details)

### **Analytics Layer**
- *`instagrammable_destinations`* (Mart model for instagrammable destinations)
- *`fact_profile_engagements`* (Mart model for uncovering engagement facts related to instagram user profiles)

### **Macros**
- *`generate_model_yml.sql`*: This macro generates `.yml` and `.md` files for any given table.
It can be executed with the following command:
```markdown 
dbt run-operation generate_model_yaml --args '{"model_name": "stg_instagram_data", "upstream_descriptions":"True"}' 
```
- *`normalize_value.sql`*: This macro takes the input of a column and returns the normalized values of each row to be between 0-1.
Written out in order to avoid duplication of this logic throughout the models.

- *`.sqlfluff`*: This file makes sure that all the models are up to good formatting standards accroding to extensive set of rules defined.

### **Data Lineage**
![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/lineage.png?raw=true)


## Methodology
### Tools Used
- Paradime: SQL and dbt™ development
- MotherDuck: Data storage and computing
- Hex: Data visualization
- [Other tools]

### Applied Techniques
- [List key techniques and practices used]

## Insights

### Insight 1
- Title
- Visualization
- Analysis

[Repeat for additional insights]

## Conclusions
[Summarize key findings and their implications]

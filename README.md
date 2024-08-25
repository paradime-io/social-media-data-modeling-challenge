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
Main purpose of the staging models is to prepare the raw data to be consumed in the modelling. Here, only name changes and some
formatting is made and no transformation is carried out.
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

# **Methodology 🧪**
### **Tools Used**
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Motherduck](https:///)** for data storage and computing.
- **[Hex](https://www.hex.tech/)** for data visualization.
- **Python scripts** for calculations and reads/writes to database.
- **dbt Tests** for maintaining data accuracy.
- **dbt MD** for removing redundant field descriptions.
- **dbt YML** for creating model descriptions.

### **Data Preparation and Applied Techniques**
Before I started doing the analytical modeling, I have first organized the dbt repository to consist of
the two main folder structures; `transformation` where staging and intermediate models live and `analytics` where the
mart models live. Only the models under this directory is surfaced to the BI Layer. Under each directory, I also have folders containing model and field descriptions.

The main Instagram dataset, `stg_instagram_data`, contains posts that are made by each user. These posts have a `description` column that
the user can write any free text describing their post. This is the crucial datapoint I have to uncover Travel insights.
I needed to capture the country and city names from the description column in order to determine the most instagrammable destinations.

In the intermediate layer, I used the `string_to_array` function to separate each word written in the post descriptions. 
I then used `stg_world_cities_countries` to see if any of the city or country names are present in the post description.
The two models `int_city_mentions` and `int_country_mentions` act as a lookup table containing only post ids and city/country names mentioned.
This is a more computationally efficent approach then doing all the word extrations together with the other modelling. 

Furthermore, `int_instagrammable_destinations` brings together all the relevant post details with city and country names extracted from the description.
To ensure that the accurate city and country names are captured as much as possible,the following are made:
- If there is a country name in the post, we try to capture it from eirther the hastag or the plain word. (eg. #italy or italy)
- If there is no country but a city is mentioned, then we derive the country name using where the city is. (eg. Bangkok --> Thailand)
- Generally, the most common english words that can act as a city name are filtered out using `common_english_words.csv` (eg. 'Of' is a city in Turkey). Within this table, I have also added the number of international arrivals associated with the country mentioned and the post year.

Finally, 2 mart models are surfaced. `instagrammable_destinations` is the main mart model used to uncover destination related insights.
`fact_profile_engagements` is the table used to uncover engagement related insights of Instagram profiles.

#### Best Practices
- Using `dbt tests` to ensure data quality.
- Having a `yml` and `md` file for each model.
- Writing a config block in each model describing the target database and materalization. For compute efficiency, all staging
models are materialized as `view` and all intermediate and analytics models are materalizated as `table`.
- Making sure that staging files can only consume from sources or seeds, intermediate models can only consume from staging or other intermediate
models and analytics models can consume from anything upstream except the sources. This is to ensure that no spaghetti lineage occurs 🍝.
- Using a customized `.sqlfluff` file to ensure formating quality accross the project.
- Since the BI tool, Hex, is a very powerful tool that allows for sql and python transformations, 
the analytics models are designed be as user friendly as possible without cutting down on flexibility. That is why, the final tables don't contain many
pre-aggregated columns. This a design choice made specific to the tool stack here and could be adjusted if the BI tool changes.


# **Visualizations** 📊




# **Conclusion 🌎**


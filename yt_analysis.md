# YouTube Trending Data Analysis

## Introduction
This project focuses on analyzing YouTube trending data across 15 countries, leveraging dbt (Data Build Tool) to implement a scalable, efficient data pipeline. The objective is to gain insights into trending videos and their metadata.
I am still experimenting dbt, so I use this dbt project to learn with production data dbt key features, AWS lambda function with duckdb and practice data warehouse techniques:
- dim and fact tables
- incremental
- macros
- snapshot for SCD2
- tags
- makefile
- data_tests
  
Main goal was to level up my dbt skills so modeling is much more developped than analysis on Hex

## Architectures
![image](https://github.com/user-attachments/assets/3d3929c7-080d-47d1-ba91-a6b8802913f2)


## Data Sources and Lineage
I use YouTube's API to collect two main datasets via AWS Lambda powered by duckdb:

- **YouTube Trending Videos**: Capturing metadata of trending videos across 15 countries.
https://github.com/cmotte4git/paradime-dbt-social-challenge/blob/main/trending_statistic.py
- **YouTube Categories**: Fetching trending video categories in the same countries.
https://github.com/cmotte4git/paradime-dbt-social-challenge/blob/main/category_scraping.py

Both datasets are enriched with additional metadata such as country information and date data for enhanced analytics.

I also use historic data collected with same API: https://www.kaggle.com/datasets/rsrishav/youtube-trending-video-dataset

### Data Lineage
1. **Source Tables**:
   - `stg_yt_trending`: Staging table for YouTube trending videos.
   - `stg_yt_category`: Staging table for video categories.

2. **Dimension and Fact Tables**:
   - `dim_category` (SCD Type 2): Tracks historical changes in video categories.
   - `dim_channel` (SCD Type 2): Tracks historical changes in YouTube channel metadata.
   - `dim_country`: Provides country information.
   - `dim_date`: Date dimension for time-based analysis.
   - `fct_yt_trending`: Fact table for YouTube trending videos, including video performance metrics like views, likes, and comments.

3. **Preparation Tables**:
   - `prep_yt_trending`: Prepares the trending videos data for further analysis.
   - `prep_yt_category`: Prepares the video category data.
   - `prep_yt_channel`: Prepares the YouTube channel data.

4. **Mart Layer**:
   - `mart_youtube_trending`: Provides high-level insights into YouTube video trends.

## Methodology

### Kimball's Data Warehouse Approach
I modeled the data using Kimball’s dimension and fact tables approach. Type-2 Slowly Changing Dimensions (SCD2) are implemented to track historical changes in categories and YouTube channel names.
I also insert dummy values in dimensions to always keep integrity when doing INNER JOIN between fact and dimensions. I created a macro (inspired by gitlab dbt stack) to insert dummmy values dynamically depending of data type and name.

### Data Transformation Using dbt
- **Staging Models**: Raw data from the YouTube API is loaded into staging tables (`stg_yt_trending`, `stg_yt_category`). Here, I apply light transformations to ensure data quality, such as removing duplicates and handling null values.

- **Preparation Models**: The staging data is further transformed into `prep_yt_trending`, `prep_yt_category`, and `prep_yt_channel`. These models apply more complex logic, including surrogate key generation, ensuring unique identifiers, and joining with date and country dimensions.

- **Incremental Models**: To handle large datasets efficiently, several models, including `prep_yt_trending` and `fct_yt_trending`, use dbt’s incremental materialization. Incremental models update the warehouse by processing only new or changed data.


### SCD Type 2 for Dimensions
For category names and channel metadata, I implemented SCD Type 2 to track historical changes. This allows us to analyze changes over time in:
- **`dim_category`**: Tracks YouTube video categories.
- **`dim_channel`**: Tracks historical changes in YouTube channel information.

### Data Validation
I use dbt tests to maintain data accuracy and quality:
- **Uniqueness Tests**: Ensure primary keys, such as `video_id` and `category_id`, are unique.
- **Foreign Key Tests**: Verify the integrity betIen fact and dimension tables.

### Project Models

#### Dimension Models
- **`dim_category`**: Tracks YouTube video categories using SCD2.
- **`dim_channel`**: Tracks historical changes in YouTube channel metadata with SCD2.
- **`dim_country`**: Static dimension providing metadata on countries.
- **`dim_date`**: Date dimension table for time-related analysis.

#### Fact Table
- **`fct_yt_trending`**: The central fact table that tracks video trending metadata across multiple dimensions, such as country, date, and category.

#### Snapshot Models
- **`dim_channel_snapshot`**: Tracks historical changes in YouTube channel names using SCD2.
- **`dim_category_snapshot`**: Tracks historical changes in YouTube categories using SCD2.


### Data Flow
- **Staging**: Data from the YouTube API is ingested into staging tables (`stg_yt_trending`, `stg_yt_category`).
- **Preparation**: The staging data is processed, cleaned, and joined with dimensions (e.g., `prep_yt_trending`).
- **Fact Table**: The `fct_yt_trending` fact table is built using incremental materialization.
- **Mart Layer**: The final data mart (`mart_youtube_trending`) is used for high-level insights and reporting on YouTube video trends.

### Tools and Technologies 🛠️
- **AWS Lambda**: For daily API requests and storing data in Parquet format.
- **DuckDB** **MotherDuck**: For quick, in-memory processing of API data.
- **dbt (Data Build Tool)**: For building, transforming, and maintaining the data pipeline.
- **GitLab CI/CD**: To manage the deployment of dbt transformations, following dbt best practices for incremental and full refresh models.
- **Kimball Methodology**: Provides the foundation for designing the data warehouse with dimension and fact tables, ensuring scalability and performance.
- 

### Analysis

I ran some reprts and alaysis on my mart dataset built with dbt
Available on my Hex app: https://app.hex.tech/92a8cf44-5935-4d57-b4e3-5a40bc84dd78/app/27cc3cc8-a396-4ab1-8e8f-568c0bc4145d/latest


## Conclusion
This project demonstrates the effective use of dbt to process and analyze YouTube trending data at scale. With incremental models, SCD Type 2 snapshots, and automated data ingestion through AWS Lambda, I ensure that both historical and current data are accurately tracked and efficiently transformed for high-quality insights into YouTube trends.

## Full lineage

![image](https://github.com/user-attachments/assets/b213aeae-c9ed-4c47-97b2-718d5334a21f)


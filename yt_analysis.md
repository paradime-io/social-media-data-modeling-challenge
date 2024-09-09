# YouTube Trending Data Analysis

## Introduction
This project focuses on analyzing YouTube trending data across 15 countries, leveraging dbt (Data Build Tool) to implement a scalable, efficient data pipeline. The objective is to gain insights into trending videos and their metadata, following best practices like Kimball's methodology and dbt's incremental models for large datasets. The project aligns with dbt’s design patterns recommended by GitLab.

## Data Sources and Lineage
We use YouTube's API to collect two main datasets via AWS Lambda:

- **YouTube Trending Videos**: Capturing metadata of trending videos across 15 countries.
- **YouTube Categories**: Fetching trending video categories in the same countries.

Both datasets are enriched with additional metadata such as country information and date data for enhanced analytics.

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
We have modeled the data using Kimball’s approach with dimension and fact tables. Type-2 Slowly Changing Dimensions (SCD2) are implemented to track historical changes in categories and YouTube channel names.

### Data Transformation Using dbt
- **Staging Models**: Raw data from the YouTube API is loaded into staging tables (`stg_yt_trending`, `stg_yt_category`). Here, we apply light transformations to ensure data quality, such as removing duplicates and handling null values.

- **Preparation Models**: The staging data is further transformed into `prep_yt_trending`, `prep_yt_category`, and `prep_yt_channel`. These models apply more complex logic, including surrogate key generation, ensuring unique identifiers, and joining with date and country dimensions.

- **Incremental Models**: To handle large datasets efficiently, several models, including `prep_yt_trending` and `fct_yt_trending`, use dbt’s incremental materialization. Incremental models update the warehouse by processing only new or changed data.

#### Sample dbt Incremental Configuration:
```sql
{{
    config(
        materialized='incremental',
        unique_key=['video_id', 'country_code', 'trending_date']
    )
}}

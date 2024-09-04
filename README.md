# dbt™ Data Modeling Challenge - Social Media Edition

Welcome to the [dbt™ Data Modeling Challenge - Social Media Edition](https://www.paradime.io/dbt-data-modeling-challenge)! This challenge invites you to showcase your data modeling skills using social media data.

## 📋 Table of Contents

1. Objective
2. Data Sources & Lineage
    - Sources
    - Intermediate Layer
    - Mart Layer
    - Data Lineage
3. Methodology + Metric Definitions
    - Tools Used
    - Data Preparation
    - Key Metrics
4. Key Insights & Visualizations
    - Data Profile
    - 2019 - Mid-2021: Audios/Artists That Took Over TikTok
    - Consistency vs Peak: A Case Study on Performance and Virality (Pre-Covid vs Post-Covid)
    - Predictors of Success: Which Song Attributes Do Well?
    - Bonus: The Stats Around These Iconic Audios
5. Summary & Conclusions
6. Reflection

# Objective
Uncovering insights around tiktok audio popularity across a variety of criteria, specifically during TikTok's early days thru the first year of COVID (roughly). 
1. Hook 1
2. Hook 2
3. Hook 3

For avid current and ex-TikTok users, how many of these audios do you remember? 

# Data Sources and Lineage

### Sources / Seeds
- *`stg_spotify_songs.sql`* kaggle spotify dataset of 20k+ popular songs between 2000 and 2020
- *`stg_tiktok_songs_on_spotify.sql`* 4 combined spotify datasets of popular tiktok songs between 2019 and 2022
- *`stg_tiktok_top_audio.sql`* top 100 tiktok audios by month over a 30-month period scraped from tokboard.com
- *`other_artists.csv`* manually populated dataset that identifies official artists not included in the spotify datasets

### Intermediate Models
- *`int_tiktok_top_audio_cleaned.sql`* cleaned version of the scraped top 100 tiktok audio data
- *`int_combined_song_list.sql`* combined spotify dataset of the 20k+ popular songs and tiktok songs
- *`int_audio_performance.sql`* core metrics table handling all calculations

### Mart Models
- *`mrt_tiktok_performance_by_audio.sql`* core metrics associated with each tiktok audio
- *`mrt_tiktok_performance_by_author.sql`* core metrics associated with each tiktok author / song artist
- *`mrt_tiktok_top_audio_by_month 1:1`* of cleaned tiktok top 100 audio dataset
- *`mrt_spotify_song_detail.sql`* 1:1 of combined spotify dataset

### Macros
- *`performance_scores.sql`* macro to handle performance score (success metrics) composition / calculation

### Other
- *`add_genre.py`* (deprecated) script to assign genre based on attributes to song tracks missing genre values

### Data Lineage


# Methodology + Metrics Definitions

### Tools
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™
- **[MotherDuck](https://www.motherduck.com/)** for data storage and computing
- **[Hex](https://hex.tech/)** for analyses and data visualization

### Data Preparation
This analysis is built off of two datasets: spotify song data from two kaggle sources and tiktok top audio data that I scraped with AI.
1. For spotify song data, ensured that the data from the two sources did not duplicate *`select distinct`* and removed variants of the 
same song that had slightly different attributes using window functions: *`row_number()`* (ex: acousticness for variant A: .91, for variant B: .90)
2. Because the tiktok top audio dataset was scraped, many fields were weirdly formatted. I used string parsing and datetime functions to
extract the values I needed, in particular the user engagement data (viral videos, views) that are key for this analysis.

### Key Metrics
The core 
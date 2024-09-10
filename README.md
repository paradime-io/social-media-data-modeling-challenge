# Social Media Data Analysis - dbt™ Modeling Challenge

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## Introduction
In this project, I will be investigating the importance of timing and music characteristics when working with TikTok content. Specifically, the analysis will focus on how different musical attributes—such as rhythm, intensity, and genre—affect user engagement metrics like likes, shares, comments, and play counts. Additionally, I will explore how the timing of TikTok posts throughout the day influences content interaction, helping to identify optimal posting windows for maximum visibility and engagement. This comprehensive analysis aims to uncover actionable insights that can be applied to content creation strategies, leveraging both the musical aspects and timing to enhance engagement on the platform.

## Data Sources
## Data Sources
- **Dataset 1: TikTok Dataset**  
  - Kaggle dataset with 1000 posts from 2020 Q4  
  - Includes various engagement metrics (likes, comments, shares, play counts), music data (Spotify and Apple), and author data.

- **Dataset 2: Extra Spotify Dataset**  
  - Due to incomplete Spotify data in the original TikTok dataset, I scraped additional Spotify data using their API. This additional data includes track popularity and musical features such as rhythm, loudness, and danceability.
<a href="Analysis/spotify_api_extract.py" style="font-size: 6pt; color: #0077cc;">Spotify extract script</a>

- **Dataset 3: Extra Author Dataset**  
  - An additional Kaggle dataset providing more detailed author information, used to join genres on.


### Data Lineage
<img width="1424" alt="image" src="https://github.com/user-attachments/assets/2d4c1c97-8f0a-467e-b895-6f162687d660">

## Methodology
### Tools Used
- **Paradime**: SQL and dbt™ development
- **MotherDuck**: Data storage and computing
- **Hex**: Data visualization and further transformation

### Applied Techniques
- **Data Cleaning and Preprocessing**  
  - Standardized data formats and handled missing values to ensure data consistency across all models.  
  - Removed duplicates to maintain data accuracy.
  
- **Feature Engineering**  
  - Created composite features such as **intensity**, **rhythm**, and **sound type** to capture musical characteristics beyond basic metrics.  
  - For example, **intensity** combines loudness and energy, while **rhythm** factors in danceability, positiveness, and tempo.

- **Binning and Quartiles**  
  - Utilized NTILE functions to divide data into quartiles based on features like popularity, rhythm, and intensity, providing deeper insights through segmented analysis.

- **Outlier Removal**  
  - Applied Interquartile Range (IQR) method to remove outliers that could distort engagement metrics, focusing on the most relevant data points.

- **Exploratory Data Analysis (EDA)**  
  - Employed visualization tools to explore data distributions, relationships, and trends. This included heatmaps, scatter plots, and line charts for initial insights.

- **Logarithmic Scale Transformation**  
  - Used logarithmic scales in visualizations to manage large variances and bring out trends that might be missed on linear scales.

- **Correlation Analysis**  
  - Created correlation matrices to measure the relationships between engagement metrics (likes, plays, comments) and music features. This helped in identifying key factors that influence user interaction.


## Insights

<img width="1384" alt="image" src="https://github.com/user-attachments/assets/2b641ba5-34ac-4fab-ab3b-3f8c5561371a">
<img width="1353" alt="image" src="https://github.com/user-attachments/assets/56cd5b61-81c0-41d2-bdde-19c91ae52daf">
<img width="1367" alt="image" src="https://github.com/user-attachments/assets/1e2cf651-8984-4bf3-b2ac-c3242a624c67">
<a href="Analysis/f/tiktok_engagement_by_timeslot_ratio.sql" style="font-size: 6pt; color: #0077cc;">Engagement by timeslot source code</a>
<br><br>

<img width="1368" alt="image" src="https://github.com/user-attachments/assets/d5f8ab98-310b-4bde-87cc-387a80bc84aa">
<img width="1372" alt="image" src="https://github.com/user-attachments/assets/f391af48-7463-40db-b96e-f7ca523a7271">
<a href="Analysis/heatmap_engagement_by_timeslot.py" style="font-size: 6pt; color: #0077cc;">Engagement by timeslot (heatmap) source code</a>
<br><br>

<img width="1149" alt="image" src="https://github.com/user-attachments/assets/4e033c0c-0fda-49e4-8766-e7afed086eea">
<br><br>

<img width="1372" alt="image" src="https://github.com/user-attachments/assets/60b42c59-5b5a-4dc5-9b68-285abab6d50e">
<a href="Analysis/heatmap_engagement_by_music_characteristic.py" style="font-size: 6pt; color: #0077cc;">Engagement by music features (heatmap) source code</a>
<br><br>

<img width="1316" alt="image" src="https://github.com/user-attachments/assets/0bf64b13-a96a-4260-9a37-55f4a6e08bf3">
<a href="Analysis/tiktok_engagement_by_genres_ratio.sql" style="font-size: 6pt; color: #0077cc;">Engagement by music features (heatmap) source code</a>
<br><br>

<img width="1322" alt="image" src="https://github.com/user-attachments/assets/1d62e360-a045-4113-9692-d60ab7bfddc1">
<img width="1339" alt="image" src="https://github.com/user-attachments/assets/d81cdf4d-e2a9-4906-912c-35d8c3fbebd8">
<a href="Analysis/trendline_scatter_popularity_vs_engagement.py" style="font-size: 6pt; color: #0077cc;">Engagement by Popularity (Scatter) source code</a>
<br><br>

<img width="1353" alt="image" src="https://github.com/user-attachments/assets/7beb378f-13fe-4868-b8a7-69facb421d6b">
<a href="Analysis/tiktok_engagement_by_popularity_ratio.sql" style="font-size: 6pt; color: #0077cc;">Engagement by Popularity source code</a>
<br><br>

<img width="1309" alt="image" src="https://github.com/user-attachments/assets/3fa61129-f03b-40d8-bc89-49b6c94034c2">
<a href="Analysis/trendline_scatter_rhythm_vs_engagement.py" style="font-size: 6pt; color: #0077cc;">Engagement by Rhythm (Scatter) source code</a>
<br><br>

<img width="1388" alt="image" src="https://github.com/user-attachments/assets/a074e973-ac80-4996-a8cc-0e767d354e9c">
<a href="Analysis/tiktok_engagement_by_rhythm_ratio.sql" style="font-size: 6pt; color: #0077cc;">Engagement by Rhythm source code</a>
<br><br>

<img width="1433" alt="image" src="https://github.com/user-attachments/assets/d2f204af-8ad6-4dc9-9041-dfe2916b1398">

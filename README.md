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
- Dataset 1: TikTok Dataset - This is a dataset found on Kaggle that included 1000 posts from 2020 Q4, including
   - various engagement metrics
   - music data (spotify and apple)
   - Author data
- Dataset 2: Spotify dataset - After figuring out that the spotify dataset in the kaggle dataset didn't contain the data that I hoped for, gathered I the list of
  spotify ids and scraped it myself.
- Dataset 3: Extra Author dataset found on Kaggle - A more nuanced author dataset that I used to join genres on. 

### Data Lineage
<img width="1372" alt="image" src="https://github.com/user-attachments/assets/8206a900-0d57-43f2-b97f-3ba3d0a078c4">


## Methodology
### Tools Used
- Paradime: SQL and dbt™ development
- MotherDuck: Data storage and computing
- Hex: Data visualization and further transformation

### Applied Techniques
- Dbt modelling using custom macros, CTEs, window functions and other aggregations on differen granularity.
- Outlier removal using the Interquartile range.
- Visualization using Python and Hex's native visualization tool.  

## Insights

<img width="1384" alt="image" src="https://github.com/user-attachments/assets/2b641ba5-34ac-4fab-ab3b-3f8c5561371a">
<img width="1353" alt="image" src="https://github.com/user-attachments/assets/56cd5b61-81c0-41d2-bdde-19c91ae52daf">



### Insight 1
- Title
- Visualization
- Analysis
[Repeat for additional insights]
## Conclusions
[Summarize key findings and their implications]
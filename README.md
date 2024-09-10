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
<img width="1367" alt="image" src="https://github.com/user-attachments/assets/1e2cf651-8984-4bf3-b2ac-c3242a624c67">
<img width="1368" alt="image" src="https://github.com/user-attachments/assets/d5f8ab98-310b-4bde-87cc-387a80bc84aa">
<img width="1372" alt="image" src="https://github.com/user-attachments/assets/f391af48-7463-40db-b96e-f7ca523a7271">
<img width="1149" alt="image" src="https://github.com/user-attachments/assets/4e033c0c-0fda-49e4-8766-e7afed086eea">

<img width="1372" alt="image" src="https://github.com/user-attachments/assets/60b42c59-5b5a-4dc5-9b68-285abab6d50e">
<img width="1316" alt="image" src="https://github.com/user-attachments/assets/0bf64b13-a96a-4260-9a37-55f4a6e08bf3">
<img width="1322" alt="image" src="https://github.com/user-attachments/assets/1d62e360-a045-4113-9692-d60ab7bfddc1">
<img width="1339" alt="image" src="https://github.com/user-attachments/assets/d81cdf4d-e2a9-4906-912c-35d8c3fbebd8">
<img width="1353" alt="image" src="https://github.com/user-attachments/assets/7beb378f-13fe-4868-b8a7-69facb421d6b">

<img width="1433" alt="image" src="https://github.com/user-attachments/assets/d2f204af-8ad6-4dc9-9041-dfe2916b1398">


<img width="1309" alt="image" src="https://github.com/user-attachments/assets/3fa61129-f03b-40d8-bc89-49b6c94034c2">
<img width="1381" alt="image" src="https://github.com/user-attachments/assets/203b2cd5-8728-46a8-b87d-49edecfc9209">

<img width="1386" alt="image" src="https://github.com/user-attachments/assets/37b89d63-ca5e-4a21-910e-45b1525ad6c7">

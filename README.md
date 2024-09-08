# **_Mastering the Art of YouTube: Roadmap to Building a Successful Video ▶️_**
Project for the dbt™ data modeling challenge - Social Media Edition

_Brought to you by **🙋🏻‍♀️ [Hetvi Parekh](https://www.linkedin.com/in/parekh-hetvi/)**_

## **Table of Contents**
1. [Introduction](#📣-introduction)
2. [Key Elements of a Youtube video](#key-elements-of-a-youtube-video-✨)
3. [Data Sources and Data Lineage](#data-sources-and-data-lineage-🕸️)
   - [Source](#source)
   - [Supporting Dataset](#seeds)
   - [Seeds](#seeds)
   - [Intermediate Layer](#intermediate-layer)
   - [Mart Layer](#mart-layer)
   - [Other Models](#other-models)
   - [Data Lineage](#data-lineage)
3. [Methodology](#methodology-🧪)
   - [Tools Used](#tools-used)
   - [Data Preparation and Cleaning](#data-preparation-and-cleaning-🧼)
   - [Calculating Video Success Metrics](#calculating-movie-success-🏅)
4. [Visualizations](#visualizations-📊)
   - [Getting to Know the Dataset](#getting-to-know-the-dataset-🔎)
   - [Ultimate Combined Movie Success](#ultimate-combined-movie-success-🥇)
   - [Change in Movie Success](#change-in-movie-success-⏳)
   - [Most Popular Months for Movie Releases](#most-popular-months-for-movie-releases-🗓️)
5. [Conclusion](#conclusion-🎬)

## **📣 Introduction**
This project delves into the dynamics of YouTube's top trending videos, offering a comprehensive exploration of the elements that contribute to viral success. By analysing patterns and key metrics across a wide range of trending content, this analysis aims to uncover actionable insights for creators. Whether you're an aspiring YouTuber or an established content creator, these findings offer a roadmap to mastering the art of trendsetting on the world's most popular video platform.

## **Key Elements of a YouTube video ✨**  
   - **_Title_** : The main headline of the video, summarizing its content.  

   - **_Description_** : A brief text below the video providing additional details.

   - **_Tags_** : Keywords associated with the video for better search visibility.

   - **_Thumbnail_** : The preview image representing the video in search results and recommendations.

   - **_Views_** : The total number of times the video has been watched.

   - **_Likes_** : The number of users who clicked the thumbs-up button.

   - **_Comments_** : User-generated messages and feedback below the video.

   - **_Video Duration_** : The length of the video in hours/minutes and seconds.
   # **Data Sources 📚 and Data Lineage** 🔗

The following datasets fuel my analysis -

### **Source**
`trending_yt_videos_113_countries`
   - This dataset is sourced from the open-source platform [Kaggle](https://www.kaggle.com/datasets/asaniczka/trending-youtube-videos-113-countries), special thanks to Asaniczka for making it available! 🙏🏼
   - It contains   top 50 trending YouTube videos across 113 countries, updated daily (starting from Oct 26, 2023 to Aug 8, 2024).

### **Supporting Dataset**
- *`video_details`* - Leveraged the YouTube API to retrieve comprehensive video details for deeper analysis. (Python script - fetching_video_details.py)
   
### **Seeds**
   - *`category_mapping`* -  Maps YouTube video categories to their respective IDs for analysis. [Online reference used](https://mixedanalytics.com/blog/list-of-youtube-video-category-ids/)
   - *`category_cpm_rates`* - Provides CPM rates for different YouTube categories as of year 2024, useful for revenue estimation. [Online Reference used](https://megadigital.ai/en/blog/youtube-ad-benchmarks/)*
   - *`country_cpm_rates`* - Lists CPM rates by country as of year 2024, enabling geographical revenue comparisons. [Online Reference used](https://bloggernexus.com/youtube-cpm-and-rpm-rates-by-country/)*

**Note that for cases where CPM rates were unavailable for certain categories or countries, used ChatGPT to gather estimates from additional online sources.*

### **Intermediate Layer**
- *`int_yt_combined_data`*  - int model that integrates all YouTube data into a unified model.
- *`int_yt_metric_definition`* - int model that defines and calculates key video success metrics.


### **Mart Layer**
- *`yt_trending_videos_deduped`* - ensures a unique, deduplicated dataset at the video level.

### **Other Models**
- *`thumbnail_analysis.py`* -  Python script to detect the presence of text and faces in YouTube video thumbnails.
- *`checking_emoji_presence.py`* - Python script to analyze the presence of emojis in video titles and descriptions.

### **Data Lineage**
![plot](Add data lineage here)

# **Methodology ⚙️**
### **Tools Used  🛠️**
- **[Paradime](https://www.paradime.io/)** to develop dbt™ models.
- **[MotherDuck](https://app.motherduck.com/)** for data warehousing and compute.
- **[Hex](https://app.hex.tech/)** to analyze the datasets and create visualizations.
- **Python scripts** for pulling additional data via Youtube API and other analysis.
- **dbt Tests** to ensure data accuracy and consistency throughout the project.
- **ChatGPT** to assist with enhancements and optimization across various tasks.
- **Tableau** for additional visualizations (which are not supported in Hex).
- **GitHub** for version control and project submission.


### **Data Preparation and Cleaning 🫧**
The source dataset gives information about top 50 latest trending videos on YouTube across 113 countries updated daily (starting from Oct 26, 2023 to Aug 8, 2024).  
To analyse the patterns across these videos, following steps were taken -

- A video can trend across multiple days and countries. To ensure uniqueness at the video level, duplicate entries were removed by:

   1. **Country-level deduplication**  

      For each video on the same trending date, rank the countries based on the highest view count. This ensures that only the country with the highest views for each trending day is selected.

   2. **First trending instance deduplication**

      After deduping at the country level, rank the videos by their first trending date. This step ensures only the earliest instance of the video appearing on the trending list is kept.

   This method ensures the data is unique at both the video and trending date levels, prioritizing the country with the highest views and the first occurrence of the video on the trending list.
- Online sources, along with the assistance of ChatGPT, were used to gather CPM rates for various video categories and countries for revenue estimations, as outlined above.
- Python scripts were used for -
   - Pulling additional video related details like video duration, category id, caption information, etc. via YouTube API.
   - To check the presence of emoji in video title and description (using `Emoji` library).
   - To check the presence of text and faces in video thumbnail. (using `EacyOCR` and `OpenCV(cv2)` libraries).

### **Calculating Video Success metrics 🏆**
Video engagement rate and average View count are crucial for measuring a video's success, making them key metrics in this analysis:

1. Engagement Rate – Gauges audience interaction using the formula:  
`Engagement Rate = (#likes + (2 * #comments)) / #views`  
Comments are weighted higher as they reflect deeper engagement, while likes are considered a lighter form of interaction.

2. Average View Count – Represents the average views per segment.  
   `Average View Count = Total #views / Total #videos`

#### 🚨 **_It's important to note that this analysis focuses exclusively on top trending videos, representing the most successful content on YouTube. While views naturally rise over time, the focus is on trends across video elements rather than absolute numbers. These insights reflect patterns observed in top-performing content, offering valuable guidance for creators looking to craft successful videos by aligning with proven trends._** 🚨

# **Insights** 📊

### **Note 📝** -
When analyzing success metrics, the average was used for balanced representation when video counts were nearly equal across segments. Otherwise, the median was applied to minimize the impact of outliers and skewed distributions.

### **Familiarizing with the dataset 🔎**
Here’s an overview of the key values present in the analyzed dataset.

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/dataset_overview.png)

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/views_per_video_across_categories.png)

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/engagement_rate_across_categories.png)

Next, we will explore the success metrics for each key attribute of a YouTube video -

Let's zoom in on video duration to uncover how the length of your content influences viewer engagement and success metrics ⏳

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_video_duration.png)

Shifting focus to captions and exploring how their presence can enhance accessibility and boost audience retention 📝

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_caption.png)

Let’s examine how video title length influences viewer curiosity and drives engagement ✍️

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_title_length.png)

Video descriptions hold valuable clues—let's see how they impact a video's overall performance 📝

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_description_length.png)

Emoji presence in titles and descriptions adds a visual pop—discover how they influence viewer engagement 😊

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_emoji_presence.png)

Text and faces in thumbnails are attention magnets — explore how they drive views and engagement 🎯

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/thumbnail_analysis.png)

Timing is everything—find out which days are prime for publishing to maximize views and engagement 📅

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/two_day_engagement_rate.png)

Relevant video tags are the hidden power behind discoverability—see how they boost visibility and reach 🔍

![plot](Add image for word clouds)



# **Conclusion 🎬**

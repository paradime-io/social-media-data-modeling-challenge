# **_Mastering the Art of YouTube: Roadmap to Building a Successful Video ▶️_**
Project for the dbt™ data modeling challenge - Social Media Edition

_Brought to you by **🙋🏻‍♀️ [Hetvi Parekh](https://www.linkedin.com/in/parekh-hetvi/)**_

## **Table of Contents**
1. [Introduction](#-introduction)
2. [Key Elements of a Youtube video](#key-elements-of-a-youtube-video-)
3. [Data Sources and Data Lineage](#data-sources--and-data-lineage-)
   - [Source](#source)
   - [Supporting Dataset](#supporting-dataset)
   - [Seeds](#seeds)
   - [Intermediate Layer](#intermediate-layer)
   - [Mart Layer](#mart-layer)
   - [Other Models](#other-models)
   - [Data Lineage](#data-lineage)
3. [Methodology](#methodology-)
   - [Tools Used](#tools-used-)
   - [Data Preparation and Cleaning](#data-preparation-and-cleaning-)
   - [Calculating Video Success Metrics](#calculating-video-success-metrics-)
4. [Insights](#insights-)
   - [Executive Summary ⛳️](#executive-summary-)
   - [Detailed Analysis](#detailed-analysis-)
      - [Familiarizing with the dataset](#familiarizing-with-the-dataset-)
      - [Exploring Success Metrics Across Key Video Attributes](#exploring-success-metrics-across-key-video-attributes-)
5. [Conclusion](#conclusion-)

## **📣 Introduction**
This project explores the dynamics of YouTube's top trending videos, analyzing key features that drive viral success. By examining patterns and metrics from trending content, it offers actionable insights to help creators optimize their video features and master the art of trendsetting on the platform.

## **Key Elements of a YouTube video ✨** 

   - **_Title_** : The main headline of the video, summarizing its content.  

   - **_Description_** : A brief text below the video providing additional details.

   - **_Caption_** : A written text overlay that transcribes spoken words, enhancing accessibility and understanding for viewers.

   - **_Tags_** : Keywords associated with the video for better search visibility.

   - **_Thumbnail_** : The preview image representing the video in search results and recommendations.

   - **_Views_** : The total number of times the video has been watched.

   - **_Likes_** : The number of users who clicked the thumbs-up button.

   - **_Comments_** : User-generated messages and feedback below the video.

   - **_Video Duration_** : The length of the video in hours/minutes and seconds.

  Revenue model - 

   - **_CPM (Cost Per Mille)_**: The amount advertisers pay per 1,000 ad impressions on a video, making it one of the primary revenue models for YouTube creators based on ad views.

   - **_RPM (Revenue Per Mille)_**: The revenue earned by the creator per 1,000 views after YouTube’s share is deducted


# **Data Sources 📚 and Data Lineage 🔗** 

The following datasets fuel my analysis -

### **Source**
`trending_yt_videos`
   - This dataset is sourced from the open-source platform [Kaggle](https://www.kaggle.com/datasets/asaniczka/trending-youtube-videos-113-countries), special thanks to Asaniczka for making it available! 🙏🏼
   - It contains   top 50 trending YouTube videos across 113 countries, updated daily (starting from Oct 26, 2023 to Aug 8, 2024).

### **Supporting Dataset**
- *`video_details`* - Leveraged the YouTube API to retrieve comprehensive video details like video duration, caption availability, and the category ID to which each video belongs for deeper analysis. (Python script - `fetching_video_details.py`)
   
### **Seeds**
   - *`category_mapping`* -  Maps YouTube video categories to their respective IDs for analysis. [Online reference used](https://mixedanalytics.com/blog/list-of-youtube-video-category-ids/)

   - *`category_cpm_rates`* - Provides CPM rates for different YouTube categories as of year 2024, useful for revenue estimation. [Online Reference used](https://megadigital.ai/en/blog/youtube-ad-benchmarks/)*

   - *`country_cpm_rates`* - Lists CPM rates by country as of year 2024, enabling geographical revenue comparisons. [Online Reference used](https://bloggernexus.com/youtube-cpm-and-rpm-rates-by-country/)*

**Note that for cases where CPM rates were unavailable for certain categories or countries, used ChatGPT to gather estimates from additional online sources.*

### **Intermediate Layer**
- *`int_yt_combined_data`*  - int model that integrates all YouTube data into a unified model and creates metrics.


### **Mart Layer**
- *`yt_trending_videos`* - ensures a unique, deduplicated dataset at the video level.

### **Other Models**
- *`thumbnail_analysis.py`* -  Python script to detect the presence of text and faces in YouTube video thumbnails.

- *`checking_emoji_presence.py`* - Python script to analyze the presence of emojis in video titles and descriptions.

- *`video_tag_word_clouds.py`* - Python script to generate word clouds from the most frequently used video tags.

### **Data Lineage**
![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/data_lineage.png)

# **Methodology ⚙️**

### **Tools Used 🛠️**

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

- A video can trend on multiple days and in multiple countries. To make the data unique at the video level, duplicates were removed by:

1. **Country-level deduplication**:  
For each video trending on the same day, the country with the highest view count was kept.

2. **First trending instance deduplication**:  
After the country-level cleanup, only the earliest date the video trended was kept.

   This ensures the data is unique by video and trending date, prioritizing the country with the highest views and the first time the video trended.

- Python scripts were used for -
   - Pulling additional video related details like video duration, category id, caption information, etc. via YouTube API.
   - To check the presence of emoji in video title and description (using `Emoji` library).
   - To check the presence of text and faces in video thumbnail. (using `EacyOCR` and `OpenCV(cv2)` libraries).
   - To generate word clouds from the most frequently used video tags. (using `Wordcloud `, `nltk`, `matplotlib` libraries).

- Online sources, along with the assistance of ChatGPT, were used to gather CPM rates for various video categories and countries for revenue estimations, as outlined above.

### **Calculating Video Success metrics 🏆**
Video engagement rate and average View count are crucial for measuring a video's success, making them key metrics in this analysis:

1. Engagement Rate – Gauges audience interaction using the formula:  
`Engagement Rate = (#likes + (2 * #comments)) / #views`  
Comments are weighted higher as they reflect deeper engagement, while likes are considered a lighter form of interaction.

2. Average View Count – Represents the average views per segment.  
   `Average View Count = Total #views / Total #videos`

#### 🚨 **_It's important to note that this analysis focuses exclusively on top trending videos, representing the most successful content on YouTube. While views naturally rise over time, the focus is on trends across video elements rather than absolute numbers. These insights reflect patterns observed in top-performing content, offering valuable guidance for creators looking to craft successful videos by aligning with proven trends._** 🚨

# **Insights 📊**

## **Executive Summary ⛳️**

This analysis focuses exclusively on trending YouTube videos, excluding non-trending content. Among trending videos, creators can **boost engagement rates by 2x** by -  
 - ⏳ Keeping videos under 15 minutes.
 - 🎥📄 Using captions for accessibility.
 - ✏️ Crafting concise titles with fewer than 7 words.
 - 📜 Optimizing descriptions under 300 characters.
 - 🤔 Including emojis in titles and descriptions.
 - Using expressive faces 😄 and text 🔠 in thumbnails.
 - 📅 Publishing videos on Fridays and Thursdays further enhance engagement. 
 - Focus should be on adding quality video tags 🌟, quantity does not matter.

Lastly, as engagement increases, it leads to a substantial rise in video views, directly impacting revenue. 💸 

## **Detailed Analysis 🔦**

### **Note 📝** -
While analyzing success metrics, the average was used for balanced representation when video counts were nearly equal across segments. In cases of uneven distribution, the median was applied to reduce the impact of outliers and skewed data.

### **Familiarizing with the dataset 🔎**
Here’s an overview of the key values present in the analyzed dataset.

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/dataset_overview.png)

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/views_per_video_across_categories.png)

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/engagement_rate_across_categories.png)

### **Exploring Success Metrics Across Key Video Attributes 💡**

Let's zoom in on video duration to uncover how the length of your content influences viewer engagement and success metrics ⏳

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_video_duration.png)

Shifting focus to captions and exploring how their presence can enhance accessibility and boost audience engagement 📝

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_caption.png)

Let’s examine how video title length influences viewer curiosity and drives engagement ✍️

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_title_length.png)

Video descriptions hold valuable clues — let's see how they impact a video's overall performance 📝

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_description_length.png)

Emoji presence in titles and descriptions adds a visual pop — discover how they influence viewer engagement 😊

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_emoji_presence.png)

Text and faces in thumbnails are attention magnets — explore how they drive views and engagement 🎯

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/thumbnail_analysis.png)

Timing is everything—find out which days are prime for publishing to maximize views and engagement 📅

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/two_day_engagement_rate.png)

Relevant video tags are the hidden power behind discoverability - include these in your video to boost visibility and reach 🔍

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/success_metrics_across_video_tags.png)

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/word_clouds_for_video_tags.png)

A Revenue Perspective : Correlation Between Estimated RPM and Video Views 💰

![plot](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/hetvi-parekh/images/revenue_estimation.png)


# **Conclusion 🏁**

For this analysis, we examined the success metrics across various YouTube video features, concluding that—

1. ⏳ For **video duration**, keeping videos **under 15 minutes** tends to offer the best balance, achieving both higher engagement rates and broader viewership.

2. 🎥📄 **Including captions** in your videos boosts engagement and increases accessibility, allowing your content to reach a broader audience. 

3. ✏️ For optimal engagement and views, keeping **video titles concise with fewer than 7 words** tends to deliver the best results.

4. 📜 **Video Descriptions under 300 characters** tend to drive higher views, while longer ones offer more engagement and provide room for detailed context, which can benefit searchability and clarity.

5. 🤔 **Incorporating emojis in both the title and description** consistently drives higher engagement and views, making them an essential element for maximizing audience interaction.

6. **Using both text 🔠 and expressive faces 😄 in thumbnails** significantly boosts visibility, capturing attention and driving video engagement.

7. 📅 **Publishing videos on Fridays and Thursdays** yields the highest engagement rates, making them the prime days to maximize video performance.

8. When it comes to **video tags**, it's the **quality 🌟 that matters**, not the quantity, as relevant tags drive more engagement than just adding many. (Refer [here](#relevant-video-tags-are-the-hidden-power-behind-discoverability—--include-these-in-your-video-to-boost-visibility-and-reach-) for top tags used in trending videos)

9. 💸 Since **Revenue** is directly tied to views, **focusing on maximizing video views** should be a top priority to boost earnings.
# **dbt™ Data Modeling Challenge - Social Media Edition**

Submission by: [Jayeson Gao](https://www.linkedin.com/in/jayesongao)

*Note: view **[this writeup in Google Docs](https://docs.google.com/document/d/1egNWsOu8AHEGoMG0UKnR0IU1qeC1QueCydCiZiwLSAk/edit?usp=sharing)** if images don't load*

## **📋 Table of Contents**

1. [Intro & Objective](#🎯-introduction-and-objective)
2. [Data Sources & Lineage](#🕸️-data-sources-and-lineage)
    - [Sources](#sources-and-seeds)
    - [Model Layers](#intermediate-models)
    - [Data Lineage](#data-lineage)
3. [Methodology & Definitions](#⚒️-methodology-and-definitions)
    - [Tools Used](#tools)
    - [Data Preparation](#data-preparation)
    - [Key Metrics & Methodology](#key-metrics)
4. [Key Insights & Visualizations](#📊-key-insights-and-visualizations)
    - [Data Profile - What Stands Out?](#section-00)
    - [Stat Stuffers of 2019 thru Mid-2021: Audios/Artists That Took Over TikTok](#section-01)
    - [The "Best Performing" TikTok Audios - Standardized and Scored](#section-02)
    - [Predictors of Success: Which Song Attributes Do Well?](#section-03)
    - [Bonus 👀](#bonus-section)
5. [Summary & Conclusions](#📃-summary-and-conclusions)
6. [Reflection](#🪞-reflection)

***

## **🎯 Introduction and Objective**
Goal of this analysis is to uncover insights around TikTok audio virality and performance, specifically during TikTok's early days thru the first year of COVID (2019 thru mid-2021). Across the 30-months this analysis was performed on, we'll be able to find out things like:

1. Typically, how long does a TikTok sound’s virality last?
2. In that time frame, who was the King / Queen of TikTok audio by raw stats?
3. What audio was “best performing” overall? What about most consistent? Highest peaking?

… and more!

&nbsp;

*Note: all song urls are linked in the [appendix.md file](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/APPENDIX.md). For avid current and ex-TikTok users, how many of these audios do you remember 🙂?* 

***

## **🕸️ Data Sources and Lineage**

### **Sources and Seeds**
- *`stg_spotify_songs.sql`* kaggle Spotify dataset of 20k+ popular songs between 2000 and 2020
- *`stg_tiktok_songs_on_spotify.sql`* 4 combined Spotify datasets of popular TikTok songs between 2019 and 2022
- *`stg_tiktok_top_audio.sql`* monthly top 100 TikTok audios over a 30-month period scraped from tokboard.com (2019 to mid-2021)
- *`other_artists.csv`* manually populated dataset that identifies official artists not included in the Spotify datasets

*Note: all datasets I used were outside of the ones provided.*

### **Intermediate Models**
- *`int_tiktok_top_audio_cleaned.sql`* cleaned version of the scraped top 100 TikTok audio data
- *`int_combined_song_list.sql`* combined spotify dataset of the 20k+ popular songs and TikTok songs
- *`int_audio_performance.sql`* core metrics table handling all metric and scoring calculations

### **Mart Models**
- *`mrt_tiktok_performance_by_audio.sql`* core metrics summarized by TikTok audio
- *`mrt_tiktok_performance_by_author.sql`* core metrics summarized by TikTok author / song artist
- *`mrt_tiktok_top_audio_by_month 1:1`* of cleaned TikTok top 100 audio dataset
- *`mrt_spotify_song_detail.sql`* 1:1 of combined Spotify dataset

### **Macros**
- *`performance_scores.sql`* macro to handle performance score (success metric) composition / calculation

### **Other**
- *`add_genre.py`* (deprecated) python script to assign genre based on attributes to song tracks missing genre values

### **Data Lineage**

![data_lineage](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/data_lineage.png?raw=true)

***

## **⚒️ Methodology and Definitions**

### **Tools**
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™
- **[MotherDuck](https://www.motherduck.com/)** for data storage and computing
- **[Hex](https://hex.tech/)** for analyses and data visualization

### **Data Preparation**
This analysis is built off of two main datasets: Spotify song data from two kaggle sources and TikTok top audio data that I scraped with AI.

- For Spotify song data, ensured that the data from the two sources did not duplicate and removed variants of the same song that 
had slightly different attributes using window functions (*`row_number()`* for ex: acousticness for variant A: .91, for variant B: .90)

- Many fields in the TikTok top audio dataset were not properly formatted (ex: numeric fields stored as '1.6M views'). I used string parsing, 
datetime functions, data type conversions to extract the values I needed, in particular the user engagement data (# of viral videos, # of views) 
that were key for this analysis.


### **Key Metrics**
The two engagement metrics at the center of this analysis are the following: viral views and viral video count.

1. **Viral views** measure the total number of views accumulated across all videos that have gone viral. This highlights the ***depth of engagement***, showing the extent of consumption.
2. **Viral video count** is the count of videos that have achieved viral status by rapidly amassing hundreds of thousands of views. This highlights the ***spread of virality*** and how many pieces of content are able to achieve significant traction.

Since the focus of the analysis revolves around TikTok audio performance, I created a composite performance metric to score and compare each audio to identify which ones stand above the rest. The composition of this metric is as follows:

- **Totals**: these are virals views or viral videos associated with an audio across the 30-month period
- **Top 100 Appearances**: number of times an audio appeared on any monthly top 100 leaderboard per tokboard.com
- **Top 10 Appearances**: number of times an audio broke into any monthly top 10
- **Average Ranking**: average leaderboard rank when an audio has appeared on the leaderboard
- **Max Ranking**: the highest ranking an audio has achieved

Because these metrics operate on different scales, they were all normalized to 0-1 before being funneled into the following formula to calculate the composite score. Score weighting was 
determined based on a subjective interpretation of performance.

- *`performance_score`* = 0.3x `total` + 0.2x `top100_count` + 0.2x `top10_count` + 0.15x `avg_top100_rank` + 0.15x `max_rank`

As the definition of performance is highly variable depending on criteria, I shifted the weights around to create two performance score variants - one skewing toward consistency, and the other 
skewing toward peaks - since I was curious how that would impact results.

- *`consistency_score`* = 0.1x `total` + 0.5x `top100_count` + 0.1x `top10_count` + 0.2x `avg_top100_rank` + 0.1x `max_rank`
- *`peak_score`* = 0.1x `total` + 0.1x `top100_count` + 0.35x top10_count + 0.1x `avg_top100_rank` + 0.35x `max_rank`

**I performed this calculation twice, once on totals and monthly rankings based on the number of viral views and a second time based on the number of viral videos.** Because viral views and 
viral video count measure reach in different ways, I was interested in understanding how this would impact the results. This is where the performance calculation macro came in handy.

The idea behind this scoring method is that measuring performance requires context beyond gross stats and using leaderboard rankings help account for other factors like competitive dynamics.


***

## **📊 Key Insights and Visualizations**


### <sub> Section 00 </sub>
### **Data Profile - What Stands Out?**
To start, let's take a quick look at the attributes of the dataset.

*Note: these stats reflect the ~3,000 records of the top 100 leaderboard charts over 30 months.*

![data_profile](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/data_profile.png?raw=true)

Right off the jump, a couple things stand out:

1. **The transient nature of TikTok audio** - the average number of top 100 monthly leaderboard appearances is a mere 1.6, with official songs 
doing slightly better at 1.92. This suggests that audio virality is short-lived (1-2 months), fads and trends shift rapidly, but also that there
 are opportunities for different audios to enjoy the limelight.
2. **There are the top performers, then there are the rest** - with viral video and viral view averages nearly doubling the median, it appears 
that the dataset is heavily skewed by top performers. After a certain ranking on the leaderboard, there is likely a significant dropoff.

![data_profile_rank_buckets](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/data_profile_rank_buckets.png?raw=true)

This chart sheds more light onto our second observation - **audios that occupy the monthly top 10 spots accumulate a significantly higher volume of viral stats than the rest 
of the top 100**. This could be due to TikTok's algorithm or a reflection of the user base's capacity to process, participate, and promote viral trends or something else entirely. 
This, however, is outside the scope of this analysis.

*Note: if you’re wondering why this chart isn’t a perfect staircase, outlier months where ranks in a given rank bucket vastly outperform their rank counterparts in other months combined with 
the fact that rank values were ranked with `rank()` instead of `row_number()` causing certain ranks to be skipped at lower levels in given months, create a funky situation 
where some of the lower rank buckets “outperform” their higher rank counterparts.*

&nbsp;

### <sub> Section 01 </sub>
### **Stat Stuffers of 2019 thru Mid-2021: Audios/Artists That Took Over TikTok**
Before we dive into the meat of this analysis, let's take a look at the top performing audios and artists by gross stats alone.

![top_10_gross_audio](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_gross_audio.png?raw=true)

&nbsp;

### <sub> Section 02 </sub>
### **The "Best Performing" TikTok Audios - Standardized and Scored**
Moving onto the main course of this analysis, we'll score and rank each audio across this period using a composite performance score weighted comprehensively
using a combination of gross stats and virality/popularity relative to the competition. See methodology here: 


reaffirms the balance of the original performance score

Final jursidiction
- measure reach in two ways - viral content created and viral content consumed

&nbsp;
### <sub> Section 03 </sub>
### **Predictors of Success: Which Song Attributes Do Well?**
-- more likely to be consistent or peak
-- which variables highly impact performance

-- unimpressive .103% R-squared value means that only 8% of variance in the dependent variable is explained by the independent variables
-- suggests
    - many paths to popularity - reflection of hhumanity
    - limited dataset
    - looking at the wrong attributes

Importance_score vs coefficient_score

&nbsp;
### <sub> Bonus Section </sub>
### **Bonus**
-- Movement of Monkey Spinning Monkeys
-- Most dominant #1
-- Final top 10 more representative after late-2019 - skewed by total view count (as TikTok grew) or due to the wild-west nature of early TikTok

-- Lottery (Renegade)
-- Roxanne
-- What you know about love
-- Say So
-- Tap In

***

## **📃 Summary and Conclusions**

TikTok audio is highly transient

***

## **🪞 Reflection**
All things considered the dataset I used was pretty limited, given that I joined the challenge a little over a week before the due date
- better dataset (more comprehensive, with more attributes, more recent) - more accurate time series analysis
    - skew toward songs in 2020, knowing what I know now, perform analysis on separate years or even half years or quarter of years (transience of tiktok audio)
- Look at things like geography (where are these values coming from)
- Do a deeper analysis on what drives virality - number of trends/fads associated with each audio (hashtag analysis), accessibility of an audio
- D)
- Are there any Christmas songs that can compete with Mariah Carey
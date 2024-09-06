# dbt™ Data Modeling Challenge - Social Media Edition

Welcome to the [dbt™ Data Modeling Challenge - Social Media Edition](https://www.paradime.io/dbt-data-modeling-challenge)! This challenge invites you to showcase your data modeling skills using social media data.

## 📋 Table of Contents

1. [Intro & Objective] (#intro-&-objective)
2. [Data Sources & Lineage] (#data-sources-and-lineage)
    - [Sources] (#sources--seeds)
    - [Model Layers] (#intermediate-models)
    - [Data Lineage] (#data-lineage)
3. [Methodology + Metric Definitions] (#methodology--metrics-definition)
    - [Tools Used] (#tools)
    - [Data Preparation] (#data-preparation)
    - [Key Metrics & Definitions] (#key-metrics)
4. [Key Insights & Visualizations] (#key-insights--visualizations)
    - [Data Profile - What Stands Out]
    - [Stat Stuffers of 2019 thru Mid-2021: Audios/Artists That Took Over TikTok]
    - [The "Best Performing" TikTok Audios - Standardized and Scored]
    - [Predictors of Success: Which Song Attributes Do Well?]
5. [Summary & Conclusions]
6. [Reflection]

# Intro & Objective
Uncovering insights around tiktok audio popularity and performance across a variety of criteria, specifically during TikTok's early days 
thru the first year of COVID (roughly). Across the 30-months this analysis was performed on, we'll be able to find out things like:
1. In that time, who was the King / Queen of TikTok audio?
2. What audio held the most number 1 monthly leaderboard spots? Most top 10 appearances?
3. Are official songs or original sounds more likely to dominate the popularity leaderboards? 

-- Using leaderboard data as a proxy for a more comprehensive dataset to get an idea of the TikTok landscape across this time period
-- The two engagement metrics I'm most closely focusing on is viral views and viral video count. A good way to think about these metrics is the 
-- reach of these audios in the form of viral content created and viral content consumed.

For avid current and ex-TikTok users, how many of these audios do you remember? 

# Data Sources and Lineage

### Sources / Seeds
- *`stg_spotify_songs.sql`* kaggle spotify dataset of 20k+ popular songs between 2000 and 2020
- *`stg_tiktok_songs_on_spotify.sql`* 4 combined spotify datasets of popular tiktok songs between 2019 and 2022
- *`stg_tiktok_top_audio.sql`* top 100 tiktok audios by month over a 30-month period scraped from tokboard.com (2019 to mid-2021)
- *`other_artists.csv`* manually populated dataset that identifies official artists not included in the spotify datasets

*Note: all datasets I used were outside of the ones provided.*

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
- *`add_genre.py`* (deprecated) python script to assign genre based on attributes to song tracks missing genre values

### Data Lineage
![data lineage] /screenshots/data_lineage.png


# Methodology + Metrics Definitions

### Tools
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™
- **[MotherDuck](https://www.motherduck.com/)** for data storage and computing
- **[Hex](https://hex.tech/)** for analyses and data visualization

### Data Preparation
This analysis is built off of two datasets: spotify song data from two kaggle sources and tiktok top audio data that I scraped with AI.
1. For spotify song data, ensured that the data from the two sources did not duplicate *`select distinct`* and removed variants of the 
same song that had slightly different attributes using window functions: *`row_number()`* (ex: acousticness for variant A: .91, for variant B: .90)
2. Because the tiktok top audio dataset was scraped, many fields were weirdly formatted (ex: numeric fields stored as '1.6M views'). I used 
string parsing and datetime functions to extract the values I needed, in particular the user engagement data (# of viral videos, # of views) 
that are key for this analysis

### Key Metrics
Since the focus of the analysis revolves around tiktok audio performance, I created a composite performance metric to score and compare
each audio to identify which ones stand out. The composition of this metric is as follows:
- **Total Views**: these are views amassed across all viral videos associated with an audio across the 30-month period - in other words, viral views
- **Top 100 Appearances**: number of times an audio appeared on any monthly top 100 leaderboard per tokboard.com
- **Top 10 Appearances**: number of times an audio broke into any top 10 leaderboard by views
- **Average Ranking**: average leaderboard rank when an audio has appeared on the leaderboard
- **Max Ranking**: the highest ranking an audio has achieved

Because these metrics operate on different scales, they were all normalized to 0-1 before being funneled into the following formula to 
calculate the composite score. Score weighting was determined based on a subjective interpretation of performance.

- *`performance_score`* = 0.3x *`total`* + 0.2x *`top100_count`* + 0.2x *`top10_count`* + 0.15x *`avg_top100_rank`* + 0.15x `max_rank`*

As the definition of performance is highly variable depending on criteria, I shifted the weights around to create two performance score variants - one 
skewing toward consistency, and the other skewing toward peaks - since I was curious how that would impact results.

- *`consistency_score`* = 0.1x *`total`* + 0.5x *`top100_count`* + 0.1x *`top10_count`* + 0.2x *`avg_top100_rank`* + 0.1x *`max_rank`*
- *`peak_score`* = 0.1x *`total`* + 0.1x *`top100_count`* + 0.35x *`top10_count`* + 0.1x *`avg_top100_rank`* + 0.35x `max_rank`*

And just for fun, I reperformed this analysis on monthly rankings based on number of viral videos instead of number of views. This is where the 
performance calculation macro came in handy.

# Key Insights & Visualizations

### Data Profile - What Stands Out?
To start, let's take a quick look at the attributes of the dataset. (See references section for all song YouTube links)


Right off the jump, a couple things stand out:
1. Transient nature of TikTok audio: the average top 100 leaderboard appearance is a mere 1.6, with official songs doing slightly better at 1.92. 
This suggests that audio virality is short-lived (1-2 months), fads and trends shift rapidly, but also that *every* audio has a shot and spot in the limelight.
2. Top performers heavily skew dataset: with viral video and viral view averages nearly doubling the median, it appears that after a certain range of
spots on the leaderboard, there is significant dropoff.


This chart sheds more light onto our second observation - top 10 audios appear to peak significantly higher than the rest of the top 100. This could be
due to TikTok's algorithm or a reflection the user base's capacity to push and promote viral trends or something else entirely. This, however it outside the
scope of this analysis.

### Stat Stuffers of 2019 thru Mid-2021: Audios/Artists That Took Over TikTok
Before we dive into the meat of this analysis, let's take a look at the top performing audios and artists by gross stats alone.

Unsurprisingly, 


Very clearly, official songs dominate the top 10 leaderboards
-- total views
-- total viral videos
https://www.youtube.com/watch?v=JdOv2Qle4fM (Bagaikan Langit (cover))
https://www.youtube.com/watch?v=E0gFA08-9xM (Laxed (Siren Beat))

### The "Best Performing" TikTok Audios - Standardized and Scored
Moving onto the main course of this analysis, we'll score and rank each audio across this period using a composite performance score weighted comprehensively
using a combination of gross stats and virality/popularity relative to the competition. See methodology here: 


reaffirms the balance of the original performance score

Final jursidiction
- measure reach in two ways - viral content created and viral content consumed

### Predictors of Success: Which Song Attributes Do Well?
-- more likely to be consistent or peak
-- which variables highly impact performance

### Bonus
-- Movement of Monkey Spinning Monkeys
-- Most dominant #1
-- Final top 10 more representative after late-2019 - skewed by total view count (as TikTok grew) or due to the wild-west nature of early TikTok

-- Lottery (Renegade)
-- Roxanne


# Conclusion

# Reflection
All things considered the dataset I used was pretty limited, given that I joined the challenge a little over a week before the due date
- better dataset (more comprehensive, with more attributes, more recent) - more accurate time series analysis
- Look at things like geography (where are these values coming from)
- Do a deeper analysis on what drives virality - number of trends/fads associated with each audio (hashtag analysis), accessibility of an audio
- D)
- Are there any Christmas songs that can compete with Mariah Carey
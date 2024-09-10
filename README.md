# **dbt™ Data Modeling Challenge - Social Media Edition**

Submission by: [Jayeson Gao](https://www.linkedin.com/in/jayesongao)

*Note: view **[this writeup in Google Docs](https://docs.google.com/document/d/1egNWsOu8AHEGoMG0UKnR0IU1qeC1QueCydCiZiwLSAk/edit?usp=sharing)** if images don't load*

## **📋 Table of Contents**

1. [Intro & Objective](#-introduction-and-objective)
2. [Data Sources & Lineage](#-data-sources-and-lineage)
    - [Sources](#sources-and-seeds)
    - [Model Layers](#intermediate-models)
    - [Data Lineage](#data-lineage)
3. [Methodology & Definitions](#-methodology-and-definitions)
    - [Tools Used](#tools)
    - [Data Preparation](#data-preparation)
    - [Key Metrics & Methodology](#key-metrics-and-methodology)
4. [Key Insights & Visualizations](#-key-insights-and-visualizations)
    - [Data Profile - What Stands Out?](#section-00)
    - [Stat Stuffers of 2019 thru Mid-2021: Audios/Artists That Took Over TikTok](#section-01)
    - [The "Best Performing" TikTok Audios - Standardized and Scored](#section-02)
    - [Predictors of Success: Which Song Attributes Do Well?](#section-03)
    - [Bonus 👀](#bonus-section)
5. [Summary & Conclusions](#-summary-and-conclusions)
6. [Reflection](#-reflection)

***

## **🎯 Introduction and Objective**
Goal of this analysis is to **uncover insights around TikTok audio virality and success**, specifically during TikTok's early days thru the first year of COVID (2019 thru mid-2021). Across the 30-months this analysis was performed on, we'll be able to find out things like:

1. Typically, how long does a TikTok sound’s virality last?
2. In that time frame, who was the King / Queen of TikTok audio by raw stats?
3. What audio was “best performing” overall? What about most consistent? Highest peaking?

… and more!

&nbsp;

*Note: **all song urls are linked in the [appendix.md file](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/APPENDIX.md)**. Pop open this file on a second monitor and get ready to jam* 🎵🎧🎸🎹🥁 *!* 

*For avid current and ex-TikTok users, how many of these audios do you remember* 🙂 *?* 

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
- *`int_combined_song_list.sql`* combined Spotify dataset of the 20k+ popular songs and TikTok songs
- *`int_audio_performance.sql`* core metrics table handling all metric and scoring calculations

### **Mart Models**
- *`mrt_tiktok_performance_by_audio.sql`* core metrics summarized by TikTok audio
- *`mrt_tiktok_performance_by_author.sql`* core metrics summarized by TikTok author / song artist
- *`mrt_tiktok_top_audio_by_month`* 1:1 of cleaned TikTok top 100 audio dataset
- *`mrt_spotify_song_detail.sql`* 1:1 of combined Spotify dataset

### **Macros**
- *`performance_scores.sql`* macro to handle performance score (success metric) composition / calculation

### **Other**
- *`add_genre.py`* (deprecated because genre data is complex, one song can belong to many genres and it’s ambiguous if those genres truly apply) python script to assign genre based on attributes to song tracks missing genre values

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


### **Key Metrics and Methodology**
The two engagement metrics at the center of this analysis are the following: viral views and viral video count.

1. **👀 Viral views** measure the total number of views accumulated across all videos that have gone viral. This highlights the ***depth of engagement***, showing the extent of consumption.
2. **▶️ Viral video count** is the count of videos that have achieved viral status by rapidly amassing hundreds of thousands of views. This highlights the ***spread of virality*** and how many pieces of content are able to achieve significant traction.

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
skewing toward peaks - since I was curious how that would affect results.

- *`consistency_score`* = 0.1x `total` + 0.5x `top100_count` + 0.1x `top10_count` + 0.2x `avg_top100_rank` + 0.1x `max_rank`
- *`peak_score`* = 0.1x `total` + 0.1x `top100_count` + 0.35x top10_count + 0.1x `avg_top100_rank` + 0.35x `max_rank`

**I performed the *`performance_score`* calculation twice, once on totals and monthly rankings based on the number of viral views and a second time based on the number of viral videos.** Because viral views and 
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

Here we look at the top 10 by gross stats ranked by total number of viral views and number of viral videos. Interestingly enough, the top 2 on both leaderboards are occupied by [Laxed (Siren Beat)](https://www.youtube.com/watch?v=E0gFA08-9xM) 
by Jawsh 685 - the sound behind Savage Love with Jason Derulo - and [Banana (feat. Shaggy)](https://www.youtube.com/watch?v=eEYviw35to0) by Conkarah, with [Monkeys Spinning Monkeys](https://www.youtube.com/watch?v=NPdgPZ0u3zQ) by Kevin MacLeod, 
[Savage](https://www.youtube.com/watch?v=eJEKHdvntPI) by Megan Thee Stallion, [Oh No](https://www.youtube.com/watch?v=R75Xcfqy-2I) by Kreepa, and [Surrender](https://www.youtube.com/watch?v=caoP4dj2oro) by Natalie Taylor rounding out the top 6 on both charts.

We also make the following observations:

1. **Renegade and the influence of Charli D’Amelio** - if you were wondering what the ‘Renegade’ song was, it’s [Lottery](https://www.youtube.com/watch?v=mn4xwao3G5k) by K CAMP, which unsurprisingly makes a cameo at 9th on the viral views leaderboard.
2. **Steph Curry from way downtown** - 🎵I’m Steph Curry when I hit the 3 I hit the whoa 🎵 Well, not exactly Steph Curry, but KRYPTO9095’s song [Woah](https://www.youtube.com/watch?v=afRki2_aNKg) shoots in at the 10th spot by total viral views. 
3. **Official songs dominate in gross stats at the top** - even the original of the [Bagaikan Langit (cover)](https://www.youtube.com/watch?v=JdOv2Qle4fM) seems to be an official Indonesian song.

![top_10_gross_author](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_gross_author.png?raw=true)

![top_10_gross_author_table](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_gross_author_table.png?raw=true)

Shifting over to gross stats by audio author/artists, we observe the following:

1. **Queens of TikTok** - Can’t talk TikTok without bringing up Doja Cat and Megan Thee Stallion. With iconic songs like Say So, Kiss Me More, Savage, and Body, it’s not a surprise that the gross stats back it up.
2. **One hit wonders: all it takes is one** - Light purple represents artists with only 1 audio that has made any top 100 list over this time period. Here are the songs associated with these artists: Jawsh 685 ([Laxed](https://www.youtube.com/watch?v=E0gFA08-9xM)), Kreepa ([Oh No](https://www.youtube.com/watch?v=R75Xcfqy-2I)), K CAMP ([Lottery](https://www.youtube.com/watch?v=mn4xwao3G5k)), and KRYPTO9095 ([Woah](https://www.youtube.com/watch?v=afRki2_aNKg)), StaySolidRocky ([Party Girl](https://www.youtube.com/watch?v=0liraNXoK4U)).

&nbsp;

### <sub> Section 02 </sub>
### **The "Best Performing" TikTok Audios - Standardized and Scored**
Moving onto the main course of this analysis, we'll score and rank each audio across this period using a composite performance score
using a combination of gross stats and ranking stats ([see methodology](#key-metrics-and-methodology)). 

The initial approach I took to calculating performance score is off of viral view data. 

![top_10_best_performing](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_best_performing.png?raw=true)

- **COVID-19 blues?** - After computing all the normalized scores based on viral view count and viral view rankings, it appears that [Surrender](https://www.youtube.com/watch?v=caoP4dj2oro) by Natalie Taylor 
has claimed the title of “best performing”, but let’s take a closer look at the component scores.

![top_10_best_performing_normalized](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_best_performing_normalized.png?raw=true)

To recap, total views (norm_total_views) represents viral reach. Number of top 100 appearances (norm_top100_app) and average top 100 rank (norm_avg_top100_rank) measure the 
consistency of performance while number of top 10 appearances (norm_top10_app) and max rank (norm_max_rank) evaluate peak success.

With that said, what stands out?

1. **Funny business or monkey business?** - [Monkeys Spinning Monkeys](https://www.youtube.com/watch?v=NPdgPZ0u3zQ) breaks into the top 10 “best performing” and claims the number 7 spot with a norm_top10_app (green bar) 
value of 0, meaning that it has no top 10 appearances on any monthly viral views leaderboard. However, it boasts a strong norm_top100_app score of 0.86, second to only the 
top spot which is a testament to its consistency.
2. **The “best performers” all have high peaks** - 9 of 10 audios have norm_max_rank scores between 0.9 - 1 (Monkeys Spinning Monkeys at 0.89 🥲) indicating they have all 
peaked on a monthly leaderboard at some point. 6 of the 10 audios have the max norm_top10_app scores indicating multiple months where they have broken into the top 10. 
3. **[Surrender](https://www.youtube.com/watch?v=caoP4dj2oro) by Natalie Taylor: the hallmark of consistency** - Interestingly enough, the top spot doesn’t boast the greatest peak metrics, but is instead carried by its 
consistency and totals. With a norm_top100_app score of 1, the song has made the most number of top 100 monthly viral views leaderboards. 

A more detailed looks at what those normalized scores correspond to:

![top_10_best_performing_table](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_best_performing_table_appendix.png?raw=true)

Now what happens when we reallocate the weights to reward either consistent performance or peak performance?

![best_performing_consistency](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/best_performing_consistency.png?raw=true)

When we skew for consistency, what we find is that…

1. **Consistency is rare** - [Surrender](https://www.youtube.com/watch?v=caoP4dj2oro) is undisputedly the most consistent “best performer”, with a commanding edge over the rest of the top 10. Are we surprised by 
this after seeing the previous charts and tables?
2. **This [Spongebob](https://www.youtube.com/watch?v=4qXVIbs4CR0) audio remix is the lone representative of non-official song audio** - Or is it? While the sound that trends on TikTok is a remix, it is technically based off of an 
officially produced sound. Regardless, it cracks the top 5 here as a - in Gen Z terms - [certified hood classic 😉](https://www.urbandictionary.com/define.php?term=certified%20hood%20classic).

![best_performing_peak](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/best_performing_peak.png?raw=true)

When we skew for peak, we find that…

1. **Audios take turns in the viral spotlight** - There is little separating the “best performers”. Two audios are tied for first, and all top 10 audios are separated by a score difference of 0.04. 
In fact, there is not a major drop-off in performance score until rank 16. With many audios including former bangers like [Lalala](https://www.youtube.com/watch?v=FZZogxdiJMA), [Up](https://www.youtube.com/watch?v=N2LPTvuIQ5U), [Backyard Boy](https://www.youtube.com/watch?v=Mbj26vHDMII) laying claim to “best performer” when we skew for peak, it reinforces one of our initial 
observations: virality is short-lived and many audios can enjoy the viral limelight though at different times.
2. **Official songs reign supreme** - While we see 4 non-official audios/songs represented in this group, [Spongebob](https://www.youtube.com/watch?v=4qXVIbs4CR0) and [Hot Headzz Ya Ya](https://www.tiktok.com/music/Hott-Headzz-Ya-Ya-Ya-6833427876558293766?lang=en)  are based on officially produced sounds and created by 
smaller artists (not picked up in the data cleaning process) respectively. Even [Patatak](https://www.youtube.com/watch?v=EPrIMUo68g4), which is tied for 10th, is derived from a [Dominican Republic song](https://www.youtube.com/watch?v=bokSLKeWVyE).

&nbsp;

This leads us to the conclusion of this section: 

- **Which song truly deserves the title of “best performing” audio?**

Since viral views only measure reach in one dimension, I calculated a second performance score off of metrics and rankings based on viral video count.

Using [the methodology here](#key-metrics-and-methodology), swapped out total views for total videos and rankings based on views for rankings based on videos. Then, created a **final performance score that 
takes the average of the view-based performance score and video-based performance score**.


- *`final_performance_score`* = 0.5x *`performance_score_by_views`* + 0.5x *`performance_score_by_videos`*

&nbsp;

So then... 🥁 🥁 🥁 🥁 🥁 🥁 🥁 🥁 





Our final winner is…

![final_performance_scatter_plot_table](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/final_performance_scatter_plot_table.png?raw=true)

### ✨ **[Monkeys Spinning Monkeys](https://www.youtube.com/watch?v=NPdgPZ0u3zQ)** by **Kevin MacLeod**! ✨ 

Thanks to its modestly strong viral depth (score_by_views) and massively impressive viral spread (score_by_videos), it slips past Surrender for sole possession of number 1. 

&nbsp;

For those interested, below is a closer look at the top 10 scored by viral video metrics. 

![top_10_best_performing_normalized_viral_video](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_best_performing_normalized_viral_video.png?raw=true)

Absolute dominance by Monkeys Spinning Monkeys in every category.

![top_10_best_performing_table_appendix_viral_video](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/top_10_best_performing_table_appendix_viral_video.png?raw=true)

&nbsp;

### <sub> Section 03 </sub>
### **Predictors of Success: Which Song Attributes Do Well?**
This last section leverages the song attributes from the combined Spotify dataset to identify which song attributes are the strongest predictors of TikTok success based on the score we computed 
in the previous section. Here are the attributes and definition per [Spotify API docs](https://developer.spotify.com/documentation/web-api/reference/get-audio-features):

- **Valence** - A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track
- **Tempo** - The overall estimated tempo of a track in beats per minute (BPM)
- **Energy** - A measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. For example, death metal has high energy, while a Bach prelude scores low on the scale
- **Key** - The key the track is in. Integers map to pitches using standard Pitch Class notation.
- **Acousticness** - A confidence measure from 0.0 to 1.0 of whether the track is acoustic
- **Loudness** - The overall loudness of a track in decibels (dB). Values range between -60 and 0
- **Danceability** - Describes how suitable a track is for dancing. A value of 0.0 is least danceable and 1.0 is most danceable
- **Speechiness** - Detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value
- **Mode** - Indicates the modality (major or minor) of a track. Major is represented by 1 and minor is 0

*Note: this analysis only looks at available TikTok songs on Spotify and not original sounds*

![attributes_of_top_performing_audios](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/attributes_of_top_performing_audios.png?raw=true)

1. **Which features most consistently impact performance score?** Using random forest to calculate importance scores, it appears most features have a similar impact on performance with valence 
contributing slightly more than the rest. 
2. **Which features have the strongest magnitude of effect on performance score?** Using linear regression to calculate coefficient scores, valence and energy have the most sizable impact on performance 
score, though in different directions. An increase of 1 in valence increases performance score by 0.089, but since valence maxes out at 1, another way to look at this is an increase of 0.1 in valence 
increase performance score by 0.0089 (~0.01), which was nearly the difference between first and second place. 

![tiktok_audio_characteristics](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/tiktok_audio_characteristics.png?raw=true)

Lastly, I took a look at if there were characteristics of TikTok songs that made them different from other songs. Using logistic regression on the same set of song attributes to calculate coefficient scores, 
it seems that TikTok songs tend to be more speechier and more danceable but lower in energy. Reminder that the Spotify API docs cite death metal as an example of high energy. Without knowing what this attribute 
actually means and looks like across different genres, it’s hard to draw definitive conclusions.

The insights in this section were not exactly groundbreaking. In a future analysis, I would curate a more expansive set of attributes including categorical ones (recency/date release, geographic origins, 
genre of artists/authors, etc).

&nbsp;

### <sub> Bonus Section </sub>
### **Bonus - MoM Rankings of the Final “Best Performers”**
If you felt that the top 10 final “best performers” deserved more visualizations, I definitely agree. Below are the MoM rank movements by number of viral views and viral videos. 

*Note: At first glance, the final top 10 skew towards audio appearing in late 2019 and early 2020, partially because early TikTok days were a wild “wild-west” of content, audio-included. At the same time, if I were to 
perform this analysis again, I would’ve created separate winners by year, “eras”, or shorter time periods.*

![bonus_top_10_mom_by_views](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/bonus_top_10_mom_by_views.png?raw=true)

![bonus_top_10_mom_by_videos](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/jayeson-gao/screenshots/bonus_top_10_mom_by_videos.png?raw=true)

What stands out? Here are some fascinating highlights:

1. **Christmas consistency** - Mariah Carey’s [All I want for Christmas Is You](https://www.youtube.com/watch?v=RmUWWVZw28E) (orange; both charts) is the only holiday music represented in the final top 10. With an unmatched winter holiday 
performance consistency and iconic melody, it definitely deserves its spot.
2. **Unparalleled continuity** - Monkeys Spinning Monkeys may have stolen the show, but [Surrender](https://www.youtube.com/watch?v=caoP4dj2oro) by Natalie Taylor (teal; chart 1) never dipped below any top 100 spot for a span of 13 consecutive months! 
Widespread COVID-19 melancholy 🤔?
3. **Impressive dominance & resurgence** - Kina’s [Can We Kiss Forever?](https://www.youtube.com/watch?v=DKbfBSrjVHA) (green; chart 2) captured four top 10 spots in a 5-month span, then came back to claim a top 20 and top 50 spot in back-to-back months.
4. **Slipping into first is not an accident** - In terms of viral spread, there’s none that can top Kevin MacLeod’s [Monkeys Spinning Monkeys](https://www.youtube.com/watch?v=NPdgPZ0u3zQ) (blue; chart 2). Five top 10 appearances, 
three top spot titles - two in back-to-back months - are the reasons behind its massive video-based performance score.
5. **Spongebob** - In case you were wondering how the [Spongebob](https://www.youtube.com/watch?v=4qXVIbs4CR0) audio rankings looked, it’s the purple line in chart 1.

***

## **📃 Summary and Conclusions**

In this analysis, we learned that consistency is rare among TikTok sounds and trends are constantly evolving which give a variety of different audios time to shine in the spotlight. 

**🔝 Viral spread vs viral depth** - In my analysis, I aimed to find the "best performing" TikTok sound using these two dimensions. A song like [Lalala](https://www.youtube.com/watch?v=FZZogxdiJMA) was a top 10 performer based on viral depth (views) 
but not based on viral spread (videos). On the flipside, audios like [Steven Universe](https://www.youtube.com/watch?v=7_RVoLCx7MU), [Play Date](https://www.youtube.com/watch?v=rODr5Zfj8RA), [Savage](https://www.youtube.com/watch?v=eJEKHdvntPI) were 
top 10 performers based on viral spread (videos) and not depth.

- ❓ *Question for the reader - While I weighed both dimensions equally in the final scoring, what dimension do you think is a better, stronger, or more important measure of virality?*

**🥇 All it takes is one** - because trends are so short-lived, an audio that is pushed and circulated at the right time and place has an opportunity to blow up in viral reach. 

**🤪 Goofiness: a common denominator of success** - some of the best performing audios - by consistency, peak, and overall - including our winner, are meme tracks. Monkeys Spinning Monkeys, 
Spongebob, and Oh No are iconic comedic sounds that consistently placed well throughout the analysis and also take up way too much real-estate in my Gen Z brain (and likely the brains of millions of others).

**👑 The Queen of Christmas** - this analysis also inadvertently identified possibly the strongest performing Christmas sound with the most unique path to the final top 10: 
consistent Christmas peaks. Whether or not Mariah Carey is still the face of Christmas TikTok sound today would be an interesting question to answer with more recent data.

**🇰🇷 K-POP appreciation** - quick shoutout to BLACKPINK’s [How You Like That](https://www.youtube.com/watch?v=aHnHwrJjR3U) for repeated cameos across several “best performing” lists.

***

## **🪞 Reflection**
I definitely see many opportunities to expand on this analysis! As I joined a little over a week out from the submission date, had I had more time I would have looked at ways to obtain a much more 
comprehensive dataset with more attributes and for a more recent time period. It would be really cool to dive deeper and look at aspects like geographical breakdown of how audio is being used, hashtags 
to determine what types of content were created using these audios, audio performance by genre, etc.

Overall, **the tools provided were incredibly intuitive, fun to use, and made this analysis an enjoyable process**. Thank you to Paradime, Hex, and MotherDuck for setting up this challenge! 
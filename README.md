# Social Media Data Analysis - dbt™ Modeling Challenge

Analyzed with ❤️ by Sophie Li

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)
6. [Next Steps](#next-steps)

## Do you like clicking things?

View my Hex app [here](https://app.hex.tech/8c193c34-4d3e-4a07-8895-f56354e83a26/app/9f2ad93d-d433-4e0f-b594-c720070f553f/latest)! It's interactive 🚀

## Introduction
This project explores activity on the Hacker News website/forum through data analysis of user engagement, an exploration of unsupervised clustering of user posts, and a comparative content analysis to overall internet user search trends and activity using Google Trends data.

## Data Sources
I took inspiration from the Hacker News data source preloaded into MotherDuck, but used the Hacker News API to query data for a more recent time period.
- Dataset 1: Hacker News July 2024 Snapshot
    - `analytics.raw_data.stories`:  All stories and associated metadata published on Hacker News made between between 2024-07-12 and 2024-07-26 UTC.
    - `analytics.raw_data.comments`: All comments and associated metadata on the stories listed in `analytics.raw_data.stories`. This data was obtained on 2024-09-02, so any comments created after 2024-07-26 are discarded in the dbt staging layer.
    - `analytics.raw_data.entity_text`: All text elements (story title, story text, and comment text) associated with the above sources. This table was materialized directly in MotherDuck instead of dbt to utilize DuckDB/MotherDuck's [Full-Text Search](https://duckdb.org/docs/extensions/full_text_search.html) capabilities.
- Dataset 2: Google Trends 
    - The Google Trends website allows users to download historical trend data. This analysis contains trend data for selected search categories (e.g. News, Computers & Technology) as well as trend data for specific terms related to key events that occurred during the 2024-07-12 - 2024-07-26 timeframe, such as "CrowdStrike", "Olympics", and "Trump". This data was obtained on 2024-09-02, and is not guaranteed to remain stable over time.

### Data Lineage
####  Engagement model
Note: There are a few extra models materialized here due to a Hex Schema bug.
![engagement_lineage](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/cf22bc15ff22c8ef7f0923707a859e0ca2ce8438/images/engagement_lineage.png?raw=true)
#### Trending Terms model
![kw_lineage](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/cf22bc15ff22c8ef7f0923707a859e0ca2ce8438/images/kw_lineage.png?raw=true)

## Methodology
### Tools Used
- Paradime: SQL and dbt™ development
- MotherDuck: Data storage and computing
- Hex: Data visualization
- Additional tools:
    - Python: `requests`, `duckdb`, and `polars` libraries for API requests and data transformation. `nltk` and `scikit-learn` libraries for data analysis within the Hex platform.

### Applied Techniques
- Exploratory Data Analysis
- NLP and Unsupervised machine learning
    - Tokenization and Lemmatization
    - Full-Text Search with DuckDB/MotherDuck
    - Term Frequency–Inverse Document Frequency (TF-IDF)
    - K-means clustering
    - Principal Component Analysis (PCA) for dimensionality reduction

### Dataset Preparation, Cleaning, and Pre-Staging Transformation

The code used to obtain the raw data is available in `scripts/get_data`, and the code used to transform and upload the raw data to MotherDuck is available in `scripts/load_duckdb`. In order to run these scripts, you will need to set up a virtual environment with the following steps (instructions assume Unix-based OS):
- `python3.11 -m venv .venv --prompt challenge-env`
- `source .venv/bin/activate`
- `python3.11 -m pip install requirements.txt`

#### Dataset 1: Hacker News July 2024 Snapshot
This dataset was obtained by querying the [HN Search API](https://hn.algolia.com/api) Search and Items endpoints with the Python `requests` library and saving the responses as JSON files. I took advantage of DuckDB's ability to query [multiple files](https://duckdb.org/docs/data/multiple_files/overview.html) to load the JSON files into memory and clean the data by un-nesting the data and extracting the relevant columns. I also took advantage of the DuckDB [Python Function API](https://duckdb.org/docs/api/python/function.html) to write a `clean_html` custom DuckDB function, which provides superior HTML parsing and cleaning of story and comment text by extracting the plain text using the `lxml` library. 

While I was able to parse the `stories` data purely with DuckDB, the `comments` data was highly nested, with each child comment stored in a tree structure, rolling up to the story level. Because the size of each tree is variable, I could not use DuckDB to fully un-nest the data. Instead, I used `polars` to traverse each story's comment tree using iterative Breadth-First Search, appending each level of comments to the result DataFrame throughout the traversal. Uploading the data back to DuckDB for a final transformation was simple since DuckDB can query the `polars` DataFrame object type!

Finally, I used DuckDB to write the data into the Parquet file format for local exploration, and created remote tables in MotherDuck using their [seamless DuckDB integration](https://motherduck.com/docs/getting-started/connect-query-from-python/installation-authentication/).


#### Dataset 2: Google Trends
After manually downloading the data from the Google Trends UI, I used `polars` to clean the downloaded CSVs and extract only the 'rising' trends from the raw data. After minor data cleaning to transform the percentage strings (e.g. '+300%') into numerical values, I used DuckDB to write the data remotely to MotherDuck.

### Insight 1: How do we measure user engagement on Hacker News?
To acquaint myself with the Hacker News dataset, I decided to perform some exploratory data analysis on user engagement. Activity within internet communities generally follows the [1% Rule](https://en.wikipedia.org/wiki/1%25_rule), which states the majority of a website's users exclusively consume content rather than participate in the community. I created three engagement measures to evaluate the level of activity on the Hacker News website:
- `points`: the aggregate sum of upvotes and downvotes on a given Hacker News story.
- `num_comments`: the number of comments under each Hacker News story.
- `max_comment_depth`: The greatest number of comments nested under a single top-level comment for each story. This was calculated by using a recursive CTE to sum the number of children for each top-level comment, and choosing the greatest value per story.

The following plot shows the count distribution for each engagement measure. The skewness of the data is apparent even after applying a power transformation to the count (y) axis.

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_engagement_measures_summary.png?raw=true)

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_engagement_measures.png?raw=true)

Next, I wanted to conduct a deep dive into the most "engaging" posts to determine if there were any meaningful differences between the engagement measures. The following table allows you to compare two measures against each other to explore any rank differences. This data is subset the full dataset for posts that could be considered outliers (defined as a `value > Q3 + (1.5 * IQR)` in both the `points` measure (> 12) and the `num_comments` measure (> 5) for speed and readability purposes.

(Note: to colorblind readers, sorry about the colors! Single color palettes are limited to red, yellow, orange, and green.)

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_engagement_measures_table.png?raw=true)

Unsurprisingly, highly-upvoted posts tend to have a lot of comments 🧠 however, the relationship is not 1:1! As we can see in the table above, only 27 posts are both in the top 50 for both number of points and number of comments. This doesn't seem to improve with scale: 54 posts are both in the top 100 for both number of points and number of comments. This relationship is closer for comment depth and total number of comments, with 78 posts in the top 100 for both.

Finally, I wanted to utilize the comment depth measure to create a better indicator for "highly engaged" posts, called the `stir_score`. Stir score is defined as `max_comment_depth / num_comments` for any posts with comments, and `0` for any posts with no comments. The stir score measure boosts posts where users continually engage with each other in threads, which was the original intent of internet forums!

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_engagement_stir_Score.png?raw=true)

Examining the stir score for the top 100 most commented-on posts, we can see that there's a large variance! Posts on breaking topics like the Crowdstrike update and Biden's withdrawal seem to have lower stir scores, while higher stir scores can be generated by all sorts of posts: breaking news, technology updates, "opinion" posts, and more!

# Insight 2: What topics do Hacker News users post about?

Given the large size of the this Hacker News dataset (over 10,000 posts!) there . I considered fine-tuning a pre-existing classification model or creating word embeddings using pre-trained models like Word2Vec, spaCy, or DistillBERT, but I ultimately settled on **k-means clustering** using a matrix of Term Frequency–Inverse Document Frequency **(TF-IDF) features** from the post titles, with **Principal Component Analysis (PCA)** used for dimensionality reduction for visualization.

- Pros:
    - Very quick to train, considering both computational power 🖥️ and human power. The TF-IDF and PCA algorithms run quickly compared to non-linear algorithms, and unsupervised clustering means there is no need to spend hours labeling ground truth data, unlike supervised learning!
    - High explainability. The TF-IDF algorithm calculates a weighting factor for each token in a sentence, proportional to how often that token appears in the training corpus
- Cons:
    - Does not account for advanced semantic similarity in post titles, unlike newer NLP methods. Other embedding algorithms, like Word2Vec or Transformer models, take word order into account when computing sentence similarity.

Hover over the chart below to examine each story's cluster and engagement metrics!
![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_kmeans.png?raw=true)

We can examine the TF-IDF features to see which individual tokens are closest to each cluster center; since the k-means centroid value is the mean of all document vectors, the closest tokens can be interpreted as a cluster topic.

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_kmeans_top.png?raw=true)

...wow, Hacker News users sure love posting about AI!

There are a few features of note that stand out here. First, it is apparent that there are a couple tokens that are used very often on Hacker News. Some are obvious, like `hn` and `video`, which appear as part of the idiomatic `Ask/Show HN` and `[Video]` labels on posts. Others are less obvious: `ai` appears in the top 10 tokens for every cluster, and `build` / `tool`/ `google` appear in 2/4 clusters.

Cluster 1 appears to contain most of the "AI" posts, with `ai` as the closest token to the cluster centroid compared to the other clusters. Cluster 2 is very clearly the `Ask/Show HN` cluster, which contains user-generated content as opposed to news content aggregated from elsewhere on the web.

# Insight 3: Do Hacker News users discuss different topics than most internet users?

It's time for a break from the tech world! After gaining some insight into the topics that HN users post about, I wanted to gather some data about trends from the rest of the internet. I used Google Trends to obtain information about trending search terms and topics between 2024-07-12 and 2024-07-26. This information is captured at the worldwide level, since Hacker News also has a global user base. The following table allows you to interactively filter the _overall trending terms_ data by the following metrics:
- `general_category`: Trend category, provided by Google (e.g 'Computers & Electronics')
- `search_type`: Google Search type, either Web Search or News Search
- `related_trend_type`: Trend type, either 'search query' or 'topic'

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/gt_computers_queries.png?raw=true)

By examining this table, we can see clear patterns and differences between each facet. 

Overall, it seems that most trending traffic overall is related to **sports** (e.g. Olympics, Copa América), **current events** and related named entities (Donald Trump, Microsoft, Crowdstrike, etc.), or **celebrity news** (Shannen Doherty, Richard Simmons, Ralf Schumacher).

The usefulness of measuring topics for trend analysis can be seen by diving into a more specific category. For example, filtering for `general_category = computers-electronics` and `search_type = news-search`, we can see that the `topics` related trend type acts as a sort of aggregation for individual `queries`: the top queries (`blue screen, ブルー スクリーン, bsod, crowdstrike bsod`) can all by grouped to the `Blue Screen of Death` topic.

In addition to general trend information, the Google Trends UI allows users to look up related searches/topics associated with a given keyword search. Using this tool, I generated a dataset for terms and topics related to the Crowdstrike incident, which can be explored below. Comparing a non-technical trend name, like "outage", to a technical topic, like "safe-mode" yields the expected results: **the related search queries and topics for less technical trends are also less technical**. It is important to note that not all related terms will correlate to the Crowdstrike incident: for example, Scotiabank had an unrelated outage event in the same time period as the Crowdstrike incident.

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/gt_safe_mode_topics.png?raw=true)

After selecting the popular search terms and topics (which can be reviewed in the Appendix), I grouped them into four categories: `celebrity-news`, `sports-news`, `tech-news`, and `us-political-news`, as well as sub-categories (e.g. `Microsoft` for all Microsoft-related terms). I used the `outage`, `downtime`, and `downdetector` topics and terms to supplement the data with websites, apps, and services that were affected by the Crowdstrike incident. Searching the 1,000,000+ row `entity_text` was lighting fast ⚡ with MotherDuck's full-text search capabilities!

As we would suspect, the `tech-news` topic trends above all other topics, even before the Crowdstrike incident, which occurred at 04:09 UTC on July 19th. We can see the `tech-news` topic spike very soon afterwards, with a **485% increase** in story hits and a **900% increase** in comment volume between 0:00-06:00 UTC and 06:00-12:00 UTC on July 19th.

Interestingly, we can see that there is a discrepancy between the peak story volume and peak comment volume for the `us-political-news` category: the story volume peaked on July 17th, while the comment volume peaked on July 21st. This is due to massive comment volume on the post announcing [Joe Biden's withdrawal from the presidential election](https://news.ycombinator.com/item?id=41026741). Note that each term is only counted once per comment, which biases this metric towards comment volume rather than term frequency.

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_topics_over_time.png?raw=true)

Let's investigate the individual terms within each topic and subtopic.

Looking at the non-technical topic groups, we can observe the following:
- Hacker News users don't post or comment about celebrities much! Compared to the interest / growth shown by Google trends (2000% for Shannen Doherty), there was only a single post about her passing on Hacker News.
- Olympics over Copa: The Olympics dominated the sports category posts, with only a few posts and comments mentioning the Copa America. Since both are international events, the country hits could have been in reference to either event — or neither!
- As usual, Trump generates engagement. He is the most posted and commented on American political figure in this dataset. However, as described above, Biden's withdrawal started a large buzz on the forum.

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_terms_non_tech.png?raw=true)

As expected, the Hacker News comment section contains a mixture of technical terms(`page_fault`, `bitlocker`) along with non-technical terms. However, one key difference from the Google Trends dataset is the frequency of terms referring to app or cloud service outages. Although the Microsoft and airline outages are mentioned frequently, many others are mentioned sparingly: `Coles` was only mentioned seven times despite being one of the largest grocers in Australia, while other widely used apps and services like `TD Bank`, `EFTPOS`, `Grindr`, and the `UK National Lottery` were not mentioned at all. I believe that this discrepancy is worth investigating further, as it may point to a demographic difference between Hacker News users and general Internet users.

![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/hn_terms_tech.png?raw=true)

## Conclusions
- There's not one measure of social media engagement to rule them all. It's important to evaluate all measures available in your dataset, and generate or normalize new measures (possibly incorporating other data!) if those aren't sufficient.
- Although Hacker News is first and foremost a technology news hub, users comment and post on several topics, with some of the most engaged posts having little to nothing to do with technology!
- Unsupervised clustering isn't perfect, but it's a start! I was able to make sense of two out of the four clusters generated by the k-means clustering algorithm. Although TF-IDF vectorization may not be the most cutting-edge feature extraction technique, it does provide a highly explainable solution for this particular problem.
- Data cleaning and data integrity is hard! Since the Hacker News API is undocumented, I had to account for several unexpected data cleaning hurdles, including the highly nested structure of the comment data, deleted comments causing count mismatches, and merged stories. In the future, I would like to use `dbt test` to write and validate tests against this data.
- New data tools are really cool 😁 Although I have used DuckDB extensively, this was my first time using MotherDuck, dbt, Paradime, and Hex! Without these tools, I wouldn't have been able to prototype and build this analysis in such a short timeframe.

## Next Steps
- Alternate engagement measures. I believe that there's more to be unlocked here: for example, one can calculate an alternative "stir score" by considering the average comment depth, not just the max comment depth.
- Supervised clustering and word embeddings. I explained the rationale for using a simpler token approach above, but I remain curious about how different ML techniques will change the output of the clustering. Special shoutout to MotherDuck's very recent [embedding capabilities launch 🚀](https://motherduck.com/blog/sql-embeddings-for-semantic-meaning-in-text-and-rag/): this means that a hybrid search approach is possible for keyword analysis well!
- Deeper dives: Since we know that certain Hacker News stories follow specific paradigms, it would be interesting to explore and cluster a specific subset of posts further. For example, would it be possible to predict the popularity of an `Ask HN` post based on its title alone?
- Network visualization! I downloaded trend data for this project manually since the Google Trends API is not public. If I automated this process, I could gather enough data to generate visualizations between trending terms. It would also be possible to mirror that network visualization with the Hacker News data since Full-Text Search can enforce that all terms in a subgraph appear in a search query.
- Finally, I am intrigued by the disparity in app / service outage mentions between Hacker News and Google Trends. Finding latent variables that underlie demographic data is always difficult, but it sounds like an amazing challenge. One place to start would be to estimate the distribution of users within each timezone ([inspiration analysis](https://distributionofthings.com/world-population-by-time-zone/)) based on post/comment activity.
## Appendix
### Table 1: Key terms used in full-text search of Hacker News dataset
![](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/261543e6a1c23508393df6dbc5686028587319f1/images/appendix.png?raw=true)



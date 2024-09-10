# Social Media Data Analysis - dbt™ Modeling Challenge

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## Introduction

This project analyzes GitHub activities and discussions on Hacker News to gain insights into GitHub's ecosystem and its perception in the tech community. We focus on the period from **August 12-18, 2024**, including a significant outage on **August 14-15**, to understand user behavior, engagement patterns, and community sentiment.

## Data Sources

- Dataset 1: **GitHub Events**: A log of user activities on GitHub, including pushes, pull requests, issues, watches, and forks.
- Dataset 2: **Hacker News Posts**: Discussions and comments related to GitHub from Hacker News.
- Dataset 3: **Hacker News Sentiment and Topics**: Sentiment scores and topic classifications generated using LLMs.

### Data Preparation and Cleaning

#### Query GitHub Archive data from Bigquery

```
SELECT
  created_at,
  actor.login AS actor_login,
  repo.name AS repo_name,
  type AS event_type,
  CASE
    WHEN type = 'PushEvent' THEN JSON_EXTRACT_SCALAR(payload, '$.size')
    WHEN type IN ('IssuesEvent', 'PullRequestEvent') THEN JSON_EXTRACT_SCALAR(payload, '$.action')
    WHEN type = 'WatchEvent' THEN 'starred'
    WHEN type = 'ForkEvent' THEN 'forked'
    ELSE NULL
  END AS event_details,
  public,
  org.login AS org_login
FROM `githubarchive.day.2024*`
WHERE _TABLE_SUFFIX BETWEEN '0812' AND '0818'
  AND DATE(created_at) BETWEEN DATE('2024-08-12') AND DATE('2024-08-18')
  AND type IN ('PushEvent', 'PullRequestEvent', 'IssuesEvent', 'WatchEvent', 'ForkEvent')
 ```

**Export BigQuery table to GCS**

```
EXPORT DATA OPTIONS(
  uri='gs://dbt_modeling/github_data_*.csv',
  format='CSV',
  compression='GZIP',
  overwrite=true
) AS
SELECT * FROM `gitdiscoverer.gharchive.github_events`
```
**Process data locally**

```
mkdir -p /Users/raj/Desktop/downloaded_data_dbt/

gsutil -m cp "gs://dbt_modeling/github_data_*.csv" /Users/raj/Desktop/downloaded_data_dbt/

cat /Users/raj/Desktop/downloaded_data_dbt/github_data_*.csv > /Users/raj/Desktop/downloaded_data_dbt/github_events_data_uc.csv

gunzip -c /Users/raj/Desktop/downloaded_data_dbt/github_events_data_uc.csv > /Users/raj/Desktop/downloaded_data_dbt/github_events_data.csv

head -n 5 /Users/raj/Desktop/downloaded_data_dbt/github_events_data.csv
```

**Upload the csv to Motherduck for storage and compute to use it as a table**

#### Query Hacker News data from Bigquery

```
SELECT
 id,
 type,
 "by" AS author,
 TIMESTAMP_SECONDS(time) AS created_at,
 title,
 text,
 url,
 score,
 parent
FROM
 `bigquery-public-data.hacker_news.full`
WHERE
 TIMESTAMP_SECONDS(time) BETWEEN '2024-08-12' AND '2024-08-19'
 AND (LOWER(text) LIKE '%github%' OR LOWER(title) LIKE '%github%' OR LOWER(url) LIKE '%github.com%')
```

**Repeat the same steps and upload it to Motherduck**

- **For Hacker News Sentiment and Topics** 
Refer analyze_hn_data.ipynb notebook under analyses folder which generates **hn_sentiment_topics** file


### **Data Lineage**

![Lineage1](https://i.imgur.com/19C6Sy7.png)

![Lineage2](https://i.imgur.com/F1tqVlM.png)


## Methodology

### Tools Used

- **BigQuery**: Extraction of GitHub Archive and Hacker News data
- **Paradime**: SQL and dbt™ development for data transformation and modeling
- **MotherDuck**: Data storage and computing, hosting our data warehouse
- **Hex**: Data visualization and interactive dashboards
- **OpenAI GPT**: Sentiment analysis and topic modeling for Hacker News posts


### Applied Techniques

- Incremental dbt models for efficient data processing
- Dimensional modeling for GitHub events and users
- Sentiment analysis and topic modeling using LLMs
- Data visualization techniques for clear insight communication

## Insights

## Insight 1

![dbt](https://i.imgur.com/yLIweIm.png)

![dbt](https://i.imgur.com/FoSE0EW.png)

- The outage period on August 14-15 had a significant impact on both daily active users and daily active contributors. There is a visible dip in activity during those two days compared to the preceding and following days

![dbt](https://i.imgur.com/xYb0mqX.png)

- **githubdungchung/trigger** is the most active repository with 175,983 events, significantly more than others in the top 10.
- Activity among the top repositories is substantial, with all showing over 62,000 total events, indicating high engagement across various projects.

## Insight 2

![dbt](https://i.imgur.com/FzEYT7t.png)

- Repository tracking **(WatchEvent)** and code contributions **(PushEvent)** consistently dominate GitHub's event type distribution.
- The outage period temporarily shifts the focus towards collaboration and issue resolution, but the distribution quickly recovers post-outage.
- Steady presence of **PullRequestEvent** and **IssuesEvent** highlights active community engagement on GitHub.

### Insight 3

![dbt](https://i.imgur.com/JruP1if.png)

- **Outage Impact:**  The dip in both sentiment and mention count on August 15 likely corresponds to the GitHub outage, demonstrating how service disruptions significantly affect community engagement and perception.
- **Quick Recovery:**  The steady increase in sentiment from August 16 onwards, culminating in a sharp rise on August 18, suggests effective crisis management by GitHub and resilience in community trust.
- High mention counts early in the week (Aug 12-14) followed by a decrease indicate intense pre-outage discussion, while the inverse relationship between mention count and sentiment on some days (e.g., Aug 12 vs Aug 18) highlights that discussion volume doesn't always correlate with positive sentiment


Following visualization will show you:
- How sentiment varies over the days for different topics
- Which topics were most discussed (larger bubbles)
- How different main topics compare in terms of sentiment and mention frequency
- The distribution of subtopics within main topics

![dbt](https://i.imgur.com/YEjalD6.png)

- Most topics showed neutral to positive sentiment, with some fluctuations across days.
- Polarized reactions were observed for a few topics on specific days, despite a generally diverse discussion landscape.


![dbt](https://i.imgur.com/Y6yA2vs.png)

- **Sentiment Shift:** There's a noticeable shift in sentiment from August 14 to August 15, with more negative sentiments appearing on the 15th, likely corresponding to the peak of the GitHub outage.
- **Outage-Related Topics:**  Subtopics such as "downtime," "outage," "service interruption," and "technical issue" are prominent, particularly on August 15, indicating the community's focus on the GitHub service disruption.
- **Diverse Discussion:**  Despite the outage, there's a wide range of subtopics discussed (e.g., "open source," "cloud platforms," "project selection"), suggesting that while the outage was significant, it didn't completely dominate all GitHub-related discussions on Hacker News.


## Conclusions

Our analysis reveals several key findings:

1. GitHub maintains strong user engagement and contribution levels, even during the outage period, showcasing the resilience and dedication of its community.
2. Event type distribution reveals diverse user interactions with the platform, with code-related activities (PushEvent, PullRequestEvent) consistently dominating.
3. Hacker News sentiment remains largely positive throughout the period, with spikes in mention count correlating with significant GitHub events or announcements.
4. The outage period saw a dip in activity and sentiment, followed by a rapid recovery, demonstrating GitHub's ability to address issues and regain user trust.

These insights can inform strategic decisions on:
- Feature development prioritizing code collaboration tools
- Community management strategies, especially during service disruptions
- Marketing efforts leveraging positive sentiment and addressing areas of concern

Future work could include more granular analysis of repository-level activities, predictive modeling for user churn, and expanded sentiment analysis across multiple social media platforms like **reddit** and **twitter**.
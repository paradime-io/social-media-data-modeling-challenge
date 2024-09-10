# Social Media Data Analysis - dbt™ Modeling Challenge

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## Introduction

This project aims to analyze GitHub activities and related discussions on Hacker News to gain insights into GitHub's ecosystem and its perception in the tech community. We focus on the period from August 12-18, 2024, including a significant outage on August 14-15, to understand user behavior, engagement patterns, and community sentiment.

## Data Sources

- **GitHub Events**: A comprehensive log of user activities on GitHub, including pushes, pull requests, issues, watches, and forks.
- **Hacker News Posts**: Discussions and comments related to GitHub from the Hacker News platform.
- **Hacker News Sentiment and Topics**: LLM-generated sentiment scores and topic classifications for Hacker News posts.

### Data Lineage

![Data Lineage](path/to/data_lineage_image.png)

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

### Insight 1: GitHub Activity Patterns

#### Daily Active Users and Contributors


### Insight 2: Event Type Distribution

#### GitHub Event Type Distribution by Category


### Insight 3: Hacker News Sentiment Analysis

#### Hacker News Sentiment and Mention Count for GitHub


## Conclusions

Future work could include more granular analysis of repository-level activities, predictive modeling for user churn, and expanded sentiment analysis across multiple social media platforms.
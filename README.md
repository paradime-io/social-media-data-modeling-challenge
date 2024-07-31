# dbt™ Data Modeling Challenge - Social Media Edition

Welcome to the [dbt™ Data Modeling Challenge - Social Media Edition](https://www.paradime.io/dbt-data-modeling-challenge)! This challenge invites you to showcase your data modeling skills using social media data.

## 📋 Table of Contents

1. [Getting Started](#-getting-started)
   - [Registration and Verification](#1-registration-and-verification)
   - [Account Setup](#2-account-setup)
   - [Support and FAQs](#3-support-and-faqs)
2. [Competition Details](#-competition-details)
3. [Building Your Project](#-building-your-project)
   - [Master the Required Tools](#step-1-master-the-required-tools)
     - [Paradime](#paradime)
     - [MotherDuck](#motherduck)
     - [Hex](#hex)
   - [Bringing in New Data](#step-2-bringing-in-new-data)
   - [Generate Insights](#step-3-generate-insights)
     - [Need a spark of inspiration?](#need-a-spark-of-inspiration)
        - [Potential Insight Ideas](#potential-insight-ideas)
   - [Create Data Visualizations](#step-4-create-data-visualizations)
4. [Submission Guidelines](#-submission-guidelines)
5. [Submission Template](#-submission-template)

## 🚀 Getting Started

### 1. Registration and Verification
- **Submit Your Application**: Fill out the [registration form](https://www.paradime.io/dbt-data-modeling-challenge#div-registration-form)
- **Verification**: We'll review your application against the [entry requirements](https://www.paradime.io/dbt-data-modeling-challenge#div-eval-criteria-summary)

### 2. Account Setup
After verification, you'll receive two confirmation emails from Paradime:
- **Your Credentials for the dbt™ Data Modeling Challenge - Social Media Edition**
- **[Paradime] Activate your account**

Follow the instructions in these emails to set up your free accounts for:
- [MotherDuck](https://hubs.la/Q02HHmK-0)
- [Paradime](https://www.paradime.io/)
- [Hex](https://app.hex.tech/signup/social-media-hackathon)

### 3. Support and FAQs
- **Technical Support**: Join Paradime's [#social-media-data-challenge Slack channel](https://paradimers.slack.com/join/shared_invite/zt-1mzax4sb8-jgw~hXRlDHAx~KN0az18bw#/shared-invite/email).
- **Additional Support**: Check out the [MotherDuck Slack Community](https://join.slack.com/t/motherduckcommunity/shared_invite/zt-2hh1g7kec-Z9q8wLd_~alry9~VbMiVqA).
- **Troubleshooting Confirmation Emails**: 
  - Ensure you meet the [entry requirements](https://www.paradime.io/dbt-data-modeling-challenge#div-eval-criteria-summary)
  - Search for "mail@paradime.retool-email.com" in your registration email account.
  - If using a personal email to register, check LinkedIn for DMs from Parker Rogers (I ask for business email if applicable). 
  - Still no luck? DM Parker Rogers via Paradime's Challenge Slack.

## 🏆 Competition Details

Before starting your project, familiarize yourself with the following key information:

- [Entry Requirements](https://www.paradime.io/dbt-data-modeling-challenge#div-eval-criteria-summary)
- [Challenge Deliverables](https://www.paradime.io/dbt-data-modeling-challenge#div-eval-criteria-summary)
- [Judging Criteria](https://www.paradime.io/dbt-data-modeling-challenge#div-eval-criteria-summary)
- [Required Tools](https://www.paradime.io/dbt-data-modeling-challenge#div-who-should-participate)
- [Prizes](https://www.paradime.io/dbt-data-modeling-challenge#section-challenge-overview)

## 🛠 Building Your Project

**Deadline: September 9, 2024**

### Step 1: Master the Required Tools

To excel in this challenge, familiarize yourself with these essential tools:

#### Paradime

[Paradime](https://www.paradime.io/) is required for SQL and dbt™ development. Other Paradime features are optional.

##### Learning Resources:

- [Code IDE Tutorial](https://app.arcade.software/share/7kRyaYbPoGc5ofmJfmvY): Navigate the [code IDE](https://docs.paradime.io/app-help/documentation/code-ide) and master basic features.
- [Commands Panel Tutorial](https://www.youtube.com/watch?v=wQtIn-tnnbg): Learn valuable Paradime features:
  - [Integrated Terminal](https://docs.paradime.io/app-help/documentation/code-ide/terminal)
  - [Data Explorer](https://docs.paradime.io/app-help/documentation/code-ide/command-panel/data-explorer)
  - [Data Catalog](https://docs.paradime.io/app-help/documentation/code-ide/command-panel/docs-preview)
  - [Data Lineage](https://docs.paradime.io/app-help/documentation/code-ide/command-panel/lineage-preview)
- [DinoAI Copilot Tutorial](https://www.youtube.com/watch?v=KqiosgQFsuk): Enhance your SQL and dbt™ development with [DinoAI](https://docs.paradime.io/app-help/documentation/code-ide/dino-ai).
- [Paradime Documentation](https://docs.paradime.io/app-help): Comprehensive product documentation for additional learning.

#### MotherDuck

[MotherDuck](https://motherduck.com/) is required for data storage and compute. Other MotherDuck & DuckDB features are optional.

##### Learning Resources:

- [Getting started tutorial with Motherduck & DuckDB](https://motherduck.com/docs/getting-started/e2e-tutorial/)
- [Working with dbt and MotherDuck](https://motherduck.com/docs/integrations/transformation/dbt/): understand how to configure your dbt project and more!
- [How to connect MotherDuck and Hex](https://learn.hex.tech/docs/connect-to-data/data-connections/data-connections-introduction#supported-data-sources)
- [MotherDuck documentation website](https://motherduck.com/docs)

#### Hex

[Hex](https://hex.tech/) is required for data visualizations and additional analysis. Other Hex features are optional.

##### Learning Resources:

- [Getting started with Hex](https://learn.hex.tech/docs/getting-started)
- [Writing SQL in Hex](https://learn.hex.tech/docs/explore-data/cells/sql-cells/sql-cells-introduction)
- [Hex Use Case Gallery](https://hex.tech/use-cases/) for inspiration and examples
- [Hex Foundations YouTube course](https://www.youtube.com/playlist?list=PLB_A53wXEFlo-rL8Gbqv387wMjB1K6mkX)

### Step 2: Bringing in New Data
You can bring in any data you want as long as it's user-generated social media data or relevant data to supplement the user-generated social media data.

#### How to bring in New Data

- Your MotherDuck account includes a sample social media dataset, [hacker_news](https://news.ycombinator.com/), which contains posts and comments. 
- Your Paradime account links to this GitHub repository, with a pre-configured dbt™ model, stg_hacker_news.sql, which references the hackernews table in MotherDuck. 

*Important:* These resources are provided merely as a convenience. You are not required to use this in your project. In fact, to excel in this challenge, you must bring in data on your own. 

#### How to bring new data into MotherDuck
1. Query data directly from your [local machine](https://motherduck.com/docs/key-tasks/loading-data-into-motherduck/loading-data-from-local-machine/) or [an object storage service](https://motherduck.com/docs/key-tasks/loading-data-into-motherduck/loading-data-from-cloud-or-https/) (AWS S3, Azure Blob Storage, Google Cloud Storage).
2. Query data directly from [Hugging Face](https://duckdb.org/docs/extensions/httpfs/hugging_face), which has countless social media datasets at your disposal.

### Step 3: Generate Insights
Use Paradime, MotherDuck, and Hex to uncover compelling insights from social media data. Aim for accurate, relevant, and engaging discoveries.

### Need a spark of inspiration?

Check out these resources:
- **[Winning Strategies for Paradime's Movie Data Modeling Challenge](https://www.paradime.io/blog/winning-strategies-movie-challenge):** Learn the strategies, best practices, and insights uncovered from winning participants in previous Data Modeling Challenges.
- **Explore winning submissions from Paradime's recent Data Modeling Challenges:**
  - [Nikita Volynets' Submission](https://github.com/nikita-volynets/nba-challenge-dbt-paradime/blob/main/README.md) - 2nd Place winner from Paradime's dbt Data Modeling Challenge - NBA Edition.
  - [Spence Perry's Submission](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/blob/nba-spence-perry/README.md) - 1st place winner from Paradime's dbt Data Modeling Challenge - NBA Edition.
  - [Isin Pesch's Submission](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/README.md) - 1st place winner from Paradime's dbt Data Modeling Challenge - Movie Edition.

#### Potential Insight Ideas

Your primary goal is to use Paradime, MotherDuck, and Hex to unearth compelling insights from social media data. With so many social media platforms, chat forums, and supplementary datasets, the possibilities for discovery are virtually limitless. Aim to generate accurate, relevant, scroll-stopping insights. Here are some ideas:

- **COVID-19 Sentiment Analysis**
   - **Analysis Question:** How has the sentiment around COVID-19 on Reddit changed over time? Why?
   - **Required Social Media Data**: [Reddit posts and comments related to COVID-19](https://www.kaggle.com/datasets/pavellexyr/the-reddit-covid-dataset), or similar dataset.
   - **Optional/Supplementary Data**: Key dates, news, events, and/or anything that points to why sentiment has changed over time.

- **Donald Trump Popularity Trends**
   - **Analysis Question:** How has Donald Trump's popularity changed over time?
   - **Required Social Media Data**: A sample of Twitter posts, mentions, and engagement, containing the words "Donald Trump" over the last 10 years.
   - **Optional/Supplementary Data**: Key dates, news, events, and/or anything that points to why popularity has changed over time.

- **Top YouTube Creators Study**
   - **Analysis Question:** Who are the biggest YouTube creators, and why?
   - **Required Social Media Data**: YouTube comments, engagement metrics, etc.
   - **Optional/Supplementary Data**: [Trending YouTube Video statistics](https://www.kaggle.com/datasets/datasnaek/youtube-new?select=CAvideos.csv), or similar datasets.

- **2022 NFL Superbowl Commercial Impact**
   - **Analysis Question:** Which Commercials were most popular during the 2022 NFL Superbowl?
   - **Required Social Media Data**: Twitter and/or Reddit posts, mentions, and engagement during the 4-hour time block of the NFL Superbowl. Only pull data that contains information about [brands that had Superbowl commercials](https://www.foxsports.com/stories/nfl/super-bowl-commercials-2022).
   - **Optional/Supplementary Data**:
     - For public companies that advertised, pull stock market data to see if there's any correlation between Superbowl commercial success and stock price.
     - Using [Superbowl advertisement cost data](https://money.usnews.com/money/personal-finance/spending/articles/how-much-does-the-average-super-bowl-commercial-cost), identify which brands had the highest social engagement per dollar spent.

### Step 4: Create Data Visualizations
Use Hex to build impactful visualizations that complement your insights.

## 📤 Submission Guidelines

**Deadline: September 9, 2024**

Follow this step-by-step tutorial to submit your project:

1. Email your submission to Parker Rogers (parker@paradime.io)
2. Subject: "<first_and_last_name> - dbt Data Modeling Challenge - Social Media Edition"
3. Include:
   - GitHub branch link with your dbt™ models
   - README.md file (use the template below)

## 📝 Submission Template

Use this template as a starting point for your submission. Feel free to customize it to best showcase your project:

```markdown
# Social Media Data Analysis - dbt™ Modeling Challenge

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## Introduction
[Brief project overview and goals]

## Data Sources
- Dataset 1: [Name] - [Description]
- Dataset 2: [Name] - [Description]
- [Add more as needed]

### Data Lineage
[Insert data lineage image]

## Methodology
### Tools Used
- Paradime: SQL and dbt™ development
- MotherDuck: Data storage and computing
- Hex: Data visualization
- [Other tools]

### Applied Techniques
- [List key techniques and practices used]

## Insights

### Insight 1
- Title
- Visualization
- Analysis

[Repeat for additional insights]

## Conclusions
[Summarize key findings and their implications]

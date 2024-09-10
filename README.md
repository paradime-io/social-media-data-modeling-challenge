


# dbt™ Data Modeling Challenge - Social Media Edition

[dbt™ Data Modeling Challenge - Social Media Edition](https://www.paradime.io/dbt-data-modeling-challenge)! This challenge invites you to showcase your data modeling skills using social media data.

## 📋 Table of Contents

1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
   - 2.1 [Data Lineage](#data-lineage)
3. [Methodology](#methodology)
   - 3.1 [Tools Used](#tools-used)
   - 3.2 [Applied Techniques](#applied-techniques)
4. [Insights](#insights)
   - 4.1 [Total Posts](#total-posts)
   - 4.2 [User Comparision by each Social Media](#user-comparision-by-each-social-media)
   - 4.3 [Comments by Posts](#comments-by-posts)
   - 4.4 [Technology Topics Covered](#technology-topics-covered)
5. [Conclusions](#conclusions)

## Introduction
This project aims to provide valuable marketing insights into which tech-focused social media platform—Hacker News or Slashdot—offers a better return on investment for engagement and content promotion.

## Data Sources
- **Dataset 1: Hacker News MotherDuck**
This dataset includes **all interactions on Hacker News** from the year 2022. It contains various types of data such as:
	-   Posts
	-   Comments
	-   Other user-generated content
	
- **Dataset 2: Slashdot posts**
This dataset was obtained by **web scraping the Slashdot story archive** for all posts made in the year 2022. The data was retrieved to allow for comparison with the 2022 Hacker News dataset.

	You can access the **Slashdot archive** used for scraping via the following link: [Chronological Story Archive on Slashdot](https://slashdot.org/archive.pl?op=bytime&keyword=&year=2022&page=1)

- **Dataset 3: Technology Keywords**
This dataset contains **943 technology-related keywords** extracted from [kaggle.com](https://www.kaggle.com/datasets/fxowl97/software-technology-keywords).

### Data Lineage
[Insert data lineage image]

## Methodology
### Tools Used
- Paradime: SQL and dbt™ development
- MotherDuck: Data storage and computing
- Hex: Data visualization
- Python: Extract and convert to table unstructured data

### Applied Techniques
**- Slashdot Web Scraping (source/raw)**
This code scrapes posts data from Slashdot using **BeautifulSoup**, **requests**, and **pandas**. The code follows **Object-Oriented Programming (OOP) principles**, promoting scalability and cleaner organization. Below is a summary of the key functions, listed in the order they are executed:

1.  **Get Page**: This function retrieves the main pages containing the links to individual posts. There are 29 pages to iterate through, each containing multiple post links.
    
2.  **Extract Links**: This function collects all post links from the current page by targeting the `div` with the class `"grid_24"`. The `href` attributes from the `a` tags are extracted, concatenated with the HTTPS prefix, and validated to match the correct post link pattern.
    
3.  **Extract Content**: Once inside a post, this function extracts the following details:
    
    -   **Title**: Retrieved from the `span` tag with the class `"story-title"`.
    -   **Article Content**: Extracted from the `div` tags with the class `"p"`. In cases where multiple `div` tags are present, the content is concatenated with the join method.
	-   **Author**: The author’s name is located in the same `span` tag as the publication date. There are two possible patterns for extracting the author:
	    -   If the author is linked to a social media profile, it will appear within an `a` tag, and the name is extracted from the `a` tag's text.
	    -   If no `a` tag is present, the author’s name is extracted from the plain text in the `span` tag, which needs to be separated from the publication date.
	   
	-   **Publication Date**: This is extracted from the `datetime` attribute of the `time` tag within the same `span` tag.
    -   **Number of Comments**: Extracted from the `span` tag with the class `"comment-bubble"`.
    -   **ID**: A simple counter for indexing posts.
    
    All extracted data is stored in a dictionary for further processing.
    
4.  **Save to DataFrame**: The dictionary is converted into a structured pandas DataFrame, making it possible to move to MotherDuck.
    
5.  **Run**: This function run the entire process, iterating over the pages, extracting the links, and calling the content extraction functions.
    
Finally, the resulting data is saved in **MotherDuck** as a source table (as configured in source.yml) for the staging step.

**- Staging**
1.   **stg_slashdot**: This stage performs an initial filtering of the data, focusing on records where the `record_type` is "story" (the primary focus for analysis). It also includes basic field standardization.
    
2.   **stg_slashdot_cleaning**: The scraped source data contains some unclean elements, such as:
    
	    -   **Author**: The author field often includes unnecessary text like tabs, spaces, or the phrase "Posted by" before the username. To clean this, the `REGEXP_REPLACE` function was used to remove "Posted by" and non-alphabetic characters.

	    -   **Publication Date**: The publication date field contains extraneous characters and is not in the correct datetime format. A regex pattern was used to remove any characters that are not part of the date or time, and then the `STRPTIME` function was applied to convert the cleaned string into a proper datetime format.

**- Intermediate Layer**
1. **int_all_post**: This step involves a straightforward union of the two staging datasets (Hacker News and Slashdot) into a single base. This combined dataset makes it easier and more efficient to  create the final data marts.

2. **int_hacker_news_keywords and int_slashdot_keywords**: A dataset with numerous technology-related keywords was obtained to help compare which themes, considered important to us, are most frequently discussed across various social media platforms. An intermediate layer was created to link these themes to post titles and count how often each keyword appears in the posts. Below are the techniques used:

	For each staging dataset (Hacker News and Slashdot), a **cross join** was used to link every post with the list of technology-related keywords. The records were then filtered to retain only those where the keyword appears in the post title. Next, the data was grouped by keyword, and the **COUNT** function was applied to determine how many times each keyword appeared across the posts.

	**Note**: Since the dataset contains a limited number of keywords, the resulting data will not represent the entire breadth of themes discussed across these platforms.

**- Marts**
1. **media_metrics**: This mart provides general metrics to compare both social media platforms. The following metrics are calculated:

	-   **Total Posts**: Counts the total number of posts from each social media platform.
	
	-   **Distinct Authors**: A distinct count of the users who posted on each social media platform.

	-   **Total Comments**: The total number of comments across all posts.

	-   **Comments per Post**: The average number of comments per post, calculated by dividing the total number of comments by the total number of posts. This shows the average engagement each post receives on each platform.

2. **Posts by Date (or months)**: This mart table counts the number of posts by date, allowing for analysis of posting trends over time, particularly to observe changes in post activity by month.

3. **Principal Themes**: This table combines the theme counts from both social media platforms. It also calculates the percentage of each theme based on the total occurrences of all themes across both platforms.

4. **User by Each Media**: This table calculates the total number of posts made by each user on both social media platforms. It also determines the percentage of posts contributed by each user relative to the total posts on their respective platform.

## Insights

### Total Posts

![total_posts](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/demik_freitas/analyses/images/total_posts_by_media_.png?raw=true)
Analyzing the total number of posts on Hacker News and Slashdot reveals a significant discrepancy, with Hacker News hosting a much larger volume of posts. This suggests that Hacker News has a broader reach and higher activity levels. However, this does not diminish the relevance of Slashdot; it may simply cater to a more specialized or niche audience.

### User Comparision by each Social Media

![total_posts](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/demik_freitas/analyses/images/different_authors_by_media.png?raw=true)

Looking at the data, we see that Slashdot has only 5 active authors, while Hacker News has over ten thousand users posting daily. This indicates with a small group of individuals responsible for generating posts and only the wider audience to comment. In contrast, Hacker News functions more like an open forum, with a much larger and more diverse group of users contributing posts regularly.

![total_posts](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/demik_freitas/analyses/images/top_media_authors.png?raw=true)
Despite Hacker News having over 40,000 more posts than Slashdot, the graph of the top 10 most active users shows that two authors from Slashdot appear among the top posters. This highlights that Slashdot has a core group of specialized contributors responsible for writing and assigning content to the site, whereas Hacker News fosters more distributed participation.

### Comments by Posts

![total_posts](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/demik_freitas/analyses/images/comments_by_posts.png?raw=true)
Despite Hacker News having a larger number of posts and contributors, this analysis reveals that Slashdot has a more engaged community. On average, each post on Slashdot receives 72 comments, which is 80% higher than the average of 13 comments per post on Hacker News. This indicates that while Hacker News has broader participation, Slashdot posts generate significantly more engagement from its audience.

### Technology Topics Covered

For the analysis, the percentage of occurrences of each technology-related topic was calculated based on the total number of technology-related mentions. This approach helps identify the most discussed topics across the media platforms.

The analysis was conducted separately for each platform:

-   **Slashdot**: On Slashdot, **36%** of the mentions are related to operating systems, indicating a strong focus on this topic. The remaining mentions are distributed across various other technology subjects.

![total_posts](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/demik_freitas/analyses/images/themes_slashdot.png?raw=true)
-   **Hacker News**: In contrast, while operating systems do appear among the top 10 most discussed topics, they do not dominate the top ranks. Instead, Hacker News features a broader mix of topics, including tools, programming languages, and other technology themes, reflecting a more diverse range of interests.

![total_posts](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/demik_freitas/analyses/images/themes_hacker_news.png?raw=true)
## Conclusions

This analysis shows that Hacker News has a significantly higher volume of posts compared to Slashdot, reflecting their distinct models: Hacker News operates with a more open approach, allowing a wide range of users to contribute posts, while Slashdot has a more closed model, with content generated primarily by a specific group of users.

Despite the lower volume of posts, Slashdot has much higher engagement. This makes it a valuable platform for gaining in-depth opinions and experiences, particularly on products and social media. The 2022 analysis indicates that social media discussions are notably prevalent on Slashdot, making it a relevant platform for in-depth insights in this area.

Por News offers more freedom to discuss and write about products, announcements, or campaigns due to its higher volume of posts and greater visibility. Its broader reach can provide greater exposure for content.
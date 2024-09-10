

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
   - 4.1 [Insight 1](#insight-1)
   - 4.2 [Insight 2](#insight-2)
   - 4.3 [Insight 3](#insight-3)
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

### Insight 1
- Title
- Visualization
- Analysis

[Repeat for additional insights]

## Conclusions
[Summarize key findings and their implications]

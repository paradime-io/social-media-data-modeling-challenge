# The Impact of Social Media Usage on Mental Health - dbt™ Modeling Challenge

***Hi ✋, I'm [Rasmus Engelbrecht](https://www.linkedin.com/in/rasmusengelbrechtsorensen/)***


## Table of Contents  📝
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## Introduction
Welcome to this analysis exploring how social media usage impacts mental health. 
In this report, I'll dive into survey data that reveals how various social media habits might affect mental well-being. 
By examining patterns in social media usage, such as time spent online and the number of platforms used, I aim to uncover insights into their effects on mental health. 
Along the way, we'll look at key variables like purposeless use, distraction frequency, and the influence of specific platforms like TikTok.
I'll load the dataset from Hugging Face into Motherduck, do some dbt data modeling in Paradime, and finally do visualisations and statistical analysis in Hex.

If you want to go more into depth, you can view the full Hex Notebook [here](https://app.hex.tech/c7e89ceb-cdfb-4937-a7c2-39913a269634/app/37474c32-c68d-4d07-82c9-6ddfb7d622b3/latest).


## Data Sources 💿
- **Correlation Between Social Media and Mental Health:** The survey dataset based on 481 respondents was created as part of a Statistics course at a university.

### Dataset References

The dataset used for this analysis is available from the following sources:

- [GitHub Repository](https://github.com/Daerkns/Correlation-Between-Social-Media-and-Mental-Health?tab=readme-ov-file)
- [Hugging Face Dataset](https://huggingface.co/datasets/sayanroy058/Social_Media_And_Twitter_Mental_Health_Dataset)


### Data Lineage 🔗
![Data Lineage](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/rasmus-engelbrecht/images/lineage.png)

## Methodology 🛠️
### Tools Used

- **[Paradime](https://www.paradime.io/)** for SQL and dbt™ development.
- **[MotherDuck](https://motherduck.com/)** for data storage and computing.
- **[Hex](https://hex.tech/)** for data visualization.
- **[Github](https://www.github.com/)** for version control.
- **[Hugging Face](https://huggingface.co/)** Data source and loading.
- **[ChatGPT](https://chatgpt.com/)** assistance for writing findings more clean and grammar/spelling checks.


### Applied Techniques
- [List key techniques and practices used]

## Insights

This analysis explores the impact of social media usage patterns on various aspects of mental health, using a dataset that captures survey responses on social media habits and their psychological effects. The survey includes responses from a total of 481 respondents.

### Key Variables

- **Purposeless Use**: Respondents indicate how often they use social media without a specific purpose, highlighting aimless scrolling behaviors.
- **Distraction Frequency**: Measures how often respondents get distracted by social media when engaged in other activities.
- **Restlessness**: Assesses the level of restlessness respondents feel when they haven't used social media for a while, reflecting potential dependency.
- **Distraction Scale**: A self-rated scale (1-5) that gauges how easily respondents are distracted in general.
- **Worry Scale**: A self-rated scale (1-5) measuring how much respondents are bothered by worries, providing insight into their anxiety levels.
- **Concentration Difficulty**: Captures whether respondents struggle to concentrate on tasks, possibly linked to social media-induced distractions.
- **Comparison Scale**: Assesses how frequently respondents compare themselves to others on social media, highlighting the social comparison effect.
- **Comparison Feelings**: Explores respondents' general feelings about the comparisons they make on social media, revealing potential negative emotional impacts.
- **Validation Seek**: Measures how often respondents seek validation through social media, reflecting their need for external approval.
- **Depression Frequency**: Gauges how often respondents feel depressed or down, indicating potential links between social media use and mood disorders.
- **Interest Fluctuation**: A self-rated scale (1-5) that measures how frequently respondents' interest in daily activities fluctuates, possibly influenced by their social media habits.
- **Health Issues**: A self-rated scale (1-5) that assesses how often respondents face health issues, potentially correlating with their social media behaviors.

These variables help frame the relationship between social media usage patterns and their effects on mental well-being, allowing for deeper analysis of potential correlations and causations.


### Age vs Social Media Usage
![Age vs Social Media Usage](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/rasmus-engelbrecht/images/age_vs_social_media_use.png)


### Social Media Usage vs Mental Health
![Social Media Usage vs Mental Health](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/rasmus-engelbrecht/images/social_media_use_vs_mental_health.png)


### Distraction by Age Group
![Distraction by Age Group](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/rasmus-engelbrecht/images/distraction_by_age_group.png)


### Tiktok vs Mental Health
![Social Media Usage vs Mental Health](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/rasmus-engelbrecht/images/tiktok_vs_mental_health.png)

### Regression: Determinants of Mental Health
In this section, I use a statistical model to explore the determinants of mental health scores, examining how various factors, including social media usage and demographic characteristics, influence mental health outcomes.
While we did oberserve some interesting relationships in the visualisations above, we need a more robust way to understand the significance of the observations.
For the outcome variable, we calculate the aggregate ´mental_health_score´ measured as the sum of the mental health score components.

![Determinants of Mental Health](https://github.com/paradime-io/social-media-data-modeling-challenge/blob/rasmus-engelbrecht/images/ols_regression.png)

#### Conclusion
The analysis of mental health scores reveals several key insights:

**Age:** The negative coefficient for age indicates that older individuals tend to have lower mental health scores, which means that, in this dataset, older people generally report better mental health. 

**Daily Time Spent on Platforms:** The positive coefficient for daily time spent on social media platforms means that more time spent online is associated with worse mental health scores.

**Number of Platforms Used:** A higher count of social media platforms used is associated with worse mental health scores. 

**Gender and Relationship Status:** Gender and relationship status variables did not show statistically significant effects on mental health scores in this model. Nonetheless, we do find that females spend more time on social media, so some of the effects could be covered by Daily Time Spent.

**Platform-Specific Effects:** Among different social media platforms, only TikTok showed a significant positive association with worse mental health scores. This might suggest that TikTok's specific content, algorithm, or user interaction patterns could be particularly detrimental to mental health.

**Overall Model Performance:** The model has an R-squared value of 0.202, indicating that approximately 20% of the variance in mental health scores can be explained by the model. While this provides some insight, a substantial amount of variability remains unexplained, suggesting that other factors not included in this model may also be influencing mental health outcomes.


## Conclusions
In this analysis I chose to focus on how social media usage impacts mental health:

- **Age and Social Media Usage:** Younger individuals tend to spend more time on social media, and this increased usage correlates with poorer mental health scores. Younger respondents also report higher frequencies of distraction, which is 44% greater compared to older age groups.

- **TikTok’s Impact:** The most striking finding is that TikTok users exhibit the worst mental health outcomes among all platforms studied. They report higher levels of depression, restlessness, and health issues, and they engage more in purposeless social media use. This suggests a particularly negative impact of TikTok on mental well-being.

- **Intensity of Social Media Usage:** Spending more time on social media and using multiple platforms are both linked to worse mental health.

- **Limitations:** The statistical model explains about 20% of the variance in mental health scores, highlighting that while our analysis provides valuable insights, many factors influencing mental health remain unexplored.

Overall, the data highlights significant concerns about social media’s role in mental health, particularly with platforms like TikTok, emphasizing the need for further research. This survey was conducted as part of a university course and I do not have any knowledge of potential biases in the actual methodology used. Hence, in order to validate my findings, I would probably want to conduct my own survey with a wider audience. Nonetheless, this has been a super exciting dataset to explore.



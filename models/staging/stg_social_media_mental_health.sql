with base as (
    select
        -- Generate a unique ID based on timestamp, age, and gender
        timestamp,

        -- Renaming columns
        age,
        gender,
        relationship,
        occupation,
        affiliations,
        "Social Media Use" as social_media_use,
        platforms,
        "Daily Time" as daily_time_group,
        "9. How often do you find yourself using Social media without a specific purpose?"
            as purposeless_use,
        "10. How often do you get distracted by Social media when you are busy doing something?"
            as distraction_frequency,
        "11. Do you feel restless if you haven't used Social media in a while?"
            as restlessness,
        "12. On a scale of 1 to 5, how easily distracted are you?"
            as distraction_scale,
        "13. On a scale of 1 to 5, how much are you bothered by worries?"
            as worry_scale,
        "14. Do you find it difficult to concentrate on things?"
            as concentration_difficulty,
        "15. On a scale of 1-5, how often do you compare yourself to other successful people through the use of social media?"
            as comparison_scale,
        "16. Following the previous question, how do you feel about these comparisons, generally speaking?"
            as comparison_feelings,
        "17. How often do you look to seek validation from features of social media?"
            as validation_seek,
        "18. How often do you feel depressed or down?" as depression_frequency,
        "19. On a scale of 1 to 5, how frequently does your interest in daily activities fluctuate?"
            as interest_fluctuation,
        "20. On a scale of 1 to 5, how often do you face health issues?"
            as health_issues,
        md5(concat(
            cast(timestamp as string),
            cast(age as string),
            cast(gender as string)
        )) as id
    from
        {{ source('huggingface', 'social_media_and_twitter_mental_health') }}
),

transformed as (
    select
        *,
        case
            when daily_time_group = 'Less than an Hour' then 0
            when daily_time_group = 'Between 1 and 2 hours' then 1
            when daily_time_group = 'Between 2 and 3 hours' then 2
            when daily_time_group = 'Between 3 and 4 hours' then 3
            when daily_time_group = 'Between 4 and 5 hours' then 4
            when daily_time_group = 'More than 5 hours' then 5
        end as daily_time,

        case
            when age < 18 then '0-17'
            when age between 18 and 24 then '18-24'
            when age between 25 and 34 then '25-34'
            when age between 35 and 44 then '35-44'
            when age >= 45 then '45+'
            else 'Unknown'
        end as age_group,

        -- Count the number of platforms
        array_length(split(platforms, ',')) as platform_count
    from
        base
)

select * from transformed

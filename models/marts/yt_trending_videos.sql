{{ 
    config(materialized = 'table') 
}}

with base as (
    select *
    from {{ ref('int_yt_combined_data') }}
),

-- Deduping at video_id & trending date level first.

country_dedupe as (

    select
        *,
        row_number()
            over (
                partition by video_id, trending_date
                order by view_count desc nulls last
            )
            as country_dedupe
    from base
),

-- Deduping at trending_date level next.

first_trending_date_dedupe as (

    select
        * exclude (country_dedupe),
        row_number()
            over (partition by video_id order by trending_date asc nulls last)
            as first_trending_date_dedupe
    from country_dedupe
    where country_dedupe = 1
)


select
    * exclude (first_trending_date_dedupe),
    -- Field created to sort data by the number of videos in each category, in descending order. 
    -- This field is intended for visualizations, as Hex lacks the capability to sort data in combined charts.    
    (case when category_name = 'Entertainment' then 'a. Entertainment'
        when category_name = 'People & Blogs' then 'b. People & Blogs'
        when category_name = 'Sports' then 'c. Sports'
        when category_name = 'Music' then 'd. Music'
        when category_name = 'Gaming' then 'e. Gaming'
        when category_name = 'News & Politics' then 'f. News & Politics'
        when category_name = 'Comedy' then 'g. Comedy'
        when category_name = 'Film & Animation' then 'h. Film & Animation'
        when category_name = 'Howto & Style' then 'i. Howto & Style'
        when category_name = 'Autos & Vehicles' then 'j. Autos & Vehicles'
        when category_name = 'Science & Technology' then 'k. Science & Technology'
        when category_name = 'Education' then 'l. Education'
        when category_name = 'Travel & Events' then 'm. Travel & Events'
        when category_name = 'Pets & Animals' then 'n. Pets & Animals'
        when category_name = 'Nonprofits & Activism' then 'o. Nonprofits & Activism'
        else 'p. Others'
    end) as category_name_sorting_purpose 
from
    first_trending_date_dedupe
where first_trending_date_dedupe = 1

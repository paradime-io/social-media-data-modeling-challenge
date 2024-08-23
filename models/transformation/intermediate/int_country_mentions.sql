-- int_country_mentions.sql

with filtered_insta_data as (
    select
        post_id,
        unnest(string_to_array(regexp_replace(lower(description), '#([a-z0-9_]+)', '# \1', 'g'), ' ')) as word
    from
        {{ ref('stg_instagram_data') }}
    where
        category in ('travel_&_adventure', 'food_&_dining')

),

filtered_twitter_data as (
    select
        twitter_data_id,
        unnest(string_to_array(regexp_replace(lower(tweet_content), '#([a-z0-9_]+)', '# \1', 'g'), ' ')) as word
    from
        {{ ref('stg_twitter_data') }}
    where
        lower(tweet_content) like '%#travel%' 
        or lower(tweet_content) like '%#vacation%'
        or lower(tweet_content) like '%#wanderlust%'
        or lower(tweet_content) like '%#explore%'
        or lower(tweet_content) like '%#tourism%'
        or lower(tweet_content) like '%#adventure%'
        or lower(tweet_content) like '%#travelgram%'
        or lower(tweet_content) like '%#trip%'
        or lower(tweet_content) like '%#holiday%'
        or lower(tweet_content) like '%#tourist%'
        or lower(tweet_content) like '%#instatravel%'
        or lower(tweet_content) like '%#getaway%'
        or lower(tweet_content) like '%#traveldiaries%'
        or lower(tweet_content) like '%#roamtheplanet%'
        or lower(tweet_content) like '%#luxurytravel%'
        or lower(tweet_content) like '%#beachlife%'
        or lower(tweet_content) like '%#globetrotter%'
        or lower(tweet_content) like '%#passportready%'
        or lower(tweet_content) like '%#vacay%'
        or lower(tweet_content) like '%#aroundtheworld%'
),

world_countries as(
    select distinct
        country_name
    from {{ ref('stg_world_cities_countries') }}
),

matched_countries as (
    select distinct
        i.post_id,
        c.country_name as country_name_mentioned,
        'instagram' as source
    from filtered_insta_data i
    inner join world_countries c
        on i.word = lower(c.country_name) -- Match country
    union all

    select distinct
        t.twitter_data_id as post_id,
        c.country_name as country_name_mentioned,
        'twitter' as source
    from filtered_twitter_data t
    inner join world_countries c
        on t.word = lower(c.country_name) -- Match country
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['post_id', 'country_name_mentioned' ]) }} as unique_key,
        *
    from matched_countries
)
select *
from final



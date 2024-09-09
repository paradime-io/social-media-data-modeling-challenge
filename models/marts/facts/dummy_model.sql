-- depends_on: {{ ref('fct_google_trends') }}
-- depends_on: {{ ref('fct_instagram_metrics') }}
-- depends_on: {{ ref('fct_reddit_posts_and_comments') }}
-- depends_on: {{ ref('fct_tiktok_metrics') }}
-- depends_on: {{ ref('fct_tweets') }}
-- depends_on: {{ ref('fct_twitter_metrics') }}
-- depends_on: {{ ref('fct_youtube_metrics') }}
-- depends_on: {{ ref('dim_athletes') }}
-- depends_on: {{ ref('dim_countries') }}
-- depends_on: {{ ref('dim_sports') }}

select null as id
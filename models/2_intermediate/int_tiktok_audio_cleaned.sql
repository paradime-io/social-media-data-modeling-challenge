with tiktok_top as (
    select
        to_date(date, 'YYYY-MM') as year_month
        , track_name
        , track_author
        , rank_by_videos
        , views
        , viral_video_count
        , CASE 
            WHEN views LIKE '%B%' THEN CAST(REPLACE(views, 'B views', '') AS DECIMAL(10,1)) * 1000000000
            WHEN views LIKE '%M%' THEN CAST(REPLACE(views, 'M views', '') AS DECIMAL(10,1)) * 1000000
            ELSE CAST(REPLACE(views, ' views', '') AS DECIMAL(10,0))
        END AS views_cleaned
        , CASE 
            WHEN viral_video_count LIKE '%K%' THEN CAST(REPLACE(viral_video_count, 'K popular videos', '') AS DECIMAL(10,1)) * 1000
            WHEN viral_video_count LIKE '%k%' THEN CAST(REPLACE(viral_video_count, 'k popular videos', '') AS DECIMAL(10,1)) * 1000
            ELSE CAST(REPLACE(viral_video_count, ' popular videos', '') AS DECIMAL(10,1)) * 1000
        END AS viral_video_count_cleaned
        , CASE
            WHEN viral_video_count_cleaned != 0 THEN views_cleaned / viral_video_count_cleaned
            ELSE 0
            END AS avg_view_per_viral_video
        , case when lower(track_name) like '%original sound%' then 'original sound'
            when track_name in (select track_name from dbt_jayeson_gao.int_combined_song_list) or track_author in (select distinct track_artist from dbt_jayeson_gao.int_combined_song_list)  
                then 'official song'
            else 'undetermined'


)
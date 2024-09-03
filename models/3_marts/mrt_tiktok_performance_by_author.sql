with other_artists as (
    select
        *
    from {{ ref('other_artists') }}
), 

author as (
select
  track_author
  , count(track_name) as audio_count
  , sum(total_views) as total_views
  , sum(total_viral_videos) as total_viral_videos
  , sum(top10_vw_app) as top_10_app_count
  , sum(top100_vw_app) as top_100_app_count
  , avg(base_performance_score) as avg_base_performance_score
  , avg(consistency_score) as avg_consistency_score
  , avg(peak_score) as avg_peak_score
  , case when track_author in (select distinct track_artist from {{ ref('int_audio_performance')}}) then 'official artist'
        or or track_author in (select artist_list from other_artists)
        else 'other / tiktok user'
    end as author_category
from dbt_jayeson_gao.int_audio_performance
group by 1
)

select *
from author
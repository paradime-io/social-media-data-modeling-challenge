{{ 
    config(materialized = 'table') 
}}


with base as (
select *
from {{ ref('yt_trending_videos_deduped') }}
),


same_day_trending as (

select a.*, b.same_day_trending_den, same_day_trending_num/same_day_trending_den as same_day_trending_rate
from
(select category_name, count(*) as same_day_trending_num
from
(select datediff('day', publish_date, snapshot_date) as days_diff, category_name, video_id
from
(select *, row_number() over (partition by video_id order by snapshot_date asc nulls last) as first_trending_date_rank
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '0 days' from base)
and category_name is not null)
where first_trending_date_rank = 1)
where days_diff = 0
group by 1
) a

left join

(select category_name, count(*) as same_day_trending_den
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '0 days' from base)
and trending_date_dedupe = 1
group by 1) b
on a.category_name = b.category_name
),


first_day_trending as (

select a.*, b.first_day_trending_den, first_day_trending_num/first_day_trending_den as first_day_trending_rate
from
(select category_name, count(*) as first_day_trending_num
from
(select datediff('day', publish_date, snapshot_date) as days_diff, category_name, video_id
from
(select *, row_number() over (partition by video_id order by snapshot_date asc nulls last) as first_trending_date_rank
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '1 days' from base)
and category_name is not null)
where first_trending_date_rank = 1)
where days_diff <= 1
group by 1
) a

left join

(select category_name, count(*) as first_day_trending_den
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '1 days' from base)
and trending_date_dedupe = 1
group by 1) b
on a.category_name = b.category_name
),


second_day_trending as (

select a.*, b.second_day_trending_den, second_day_trending_num/second_day_trending_den as second_day_trending_rate
from
(select category_name, count(*) as second_day_trending_num
from
(select datediff('day', publish_date, snapshot_date) as days_diff, category_name, video_id
from
(select *, row_number() over (partition by video_id order by snapshot_date asc nulls last) as first_trending_date_rank
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '2 days' from base)
and category_name is not null)
where first_trending_date_rank = 1)
where days_diff <= 2
group by 1
) a

left join

(select category_name, count(*) as second_day_trending_den
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '2 days' from base)
and trending_date_dedupe = 1
group by 1) b
on a.category_name = b.category_name
),


third_day_trending as (

select a.*, b.third_day_trending_den, third_day_trending_num/third_day_trending_den as third_day_trending_rate
from
(select category_name, count(*) as third_day_trending_num
from
(select datediff('day', publish_date, snapshot_date) as days_diff, category_name, video_id
from
(select *, row_number() over (partition by video_id order by snapshot_date asc nulls last) as first_trending_date_rank
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '3 days' from base)
and category_name is not null)
where first_trending_date_rank = 1)
where days_diff <= 3
group by 1
) a

left join

(select category_name, count(*) as third_day_trending_den
from base
where publish_date between '2023-10-26' and (select max(publish_date) - interval '3 days' from base)
and trending_date_dedupe = 1
group by 1) b
on a.category_name = b.category_name    
)


select a.*, b.* exclude(category_name), c.* exclude(category_name), d.* exclude(category_name),
       e.* exclude(category_name)
from
(select distinct category_name 
from base
where category_name is not null) a

join

same_day_trending b
on a.category_name = b.category_name

join

first_day_trending c
on a.category_name = c.category_name

join

second_day_trending d
on a.category_name = d.category_name

join

third_day_trending e
on a.category_name = e.category_name

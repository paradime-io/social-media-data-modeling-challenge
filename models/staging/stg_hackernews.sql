with hackernews as (
  select
    parent
    ,id
    ,descendants
    ,type as post_type
    ,title
    ,text
    ,url
    ,score -- The story's score, or the votes for a pollopt.
    ,lpad(extract(year from time)::varchar, 4, '0') as post_year
    ,lpad(extract(month from time)::varchar, 2, '0') as post_month
  from {{ source('hns', 'hacker_news_2022_2023') }}
  -- Ensure there is content (& not deleted etc)
  where
    deleted is not true
    and post_type != 'pollopt' -- Don't use poll options at this time
    and (
        ((post_type = 'story') and (title is not null))
        or ((post_type = 'comment') and (text is not null))
        or ((post_type = 'poll') and (title is not null))
        or ((post_type = 'job') and (title is not null))
    )
)
select 
  *
from hackernews
-- Filter out those with parents that aren't in current id
where (parent in (select id from hackernews)) or (parent is null)
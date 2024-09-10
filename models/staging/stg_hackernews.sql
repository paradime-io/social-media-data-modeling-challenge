with hackernews as (
  select
    parent
    ,id
    ,post_type
    ,title
    ,text
    ,url
    ,score -- The story's score, or the votes for a pollopt.
    ,post_year
    ,post_month
  from {{ source('hns', 'hn_to_2023') }}
  -- Ensure there is content 
  where
    -- Take data from 2022 to Nov 2023, since last HN post date is Nov 1
    ((post_year == '2022' and post_month >= '01') or (post_year == '2023' and post_month < '11'))

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
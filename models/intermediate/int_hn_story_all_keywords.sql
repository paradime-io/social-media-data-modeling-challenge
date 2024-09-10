-- Find posts with all related keywords, including
-- ML keywords
-- Data keywords 
-- Job skills keywords
-- Job Roles

with keywords_to_match as (
	select distinct keywords 
	from {{ ref('int_keywords') }}
)

, posts as (
  select
    p.id
    ,p.post_year
    ,p.post_month
    ,lower(p.title) as title
    ,lower(p.text) as text
  from {{ ref('stg_hackernews') }} p
  where ((post_type = 'story'))
    -- Must have at least 3 words in title / text
    and (regexp_matches(title, '^(?:\S+\s+){2,}\S+') 
     or regexp_matches(text, '^(?:\S+\s+){2,}\S+'))
)

, posts_w_keywords as (
    select
    p.id
    ,coalesce(k.keywords, k2.keywords) as keywords
    ,p.post_year
    ,p.post_month
    ,p.title
    ,p.text
    ,row_number() over (partition by p.id, coalesce(k.keywords, k2.keywords)) as rn
    from posts p
    -- Check if keyword is in title/text, and appears after space or at start
    left join keywords_to_match k
    on (p.title LIKE k.keywords || '%'
        OR p.title LIKE '% ' || k.keywords || '%') 
    left join keywords_to_match k2
    on (p.text LIKE k2.keywords || '%'
        OR p.text LIKE '% ' || k2.keywords || '%') 
    where k.keywords is not null
    or k2.keywords is not null
)

select 
  id
  ,keywords
  ,post_year
  ,post_month
  ,title
  ,text
from posts_w_keywords
where rn = 1 -- Ensure there's no repeated id/keyword combo
order by 1 asc, 2 asc
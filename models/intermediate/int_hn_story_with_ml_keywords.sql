with keywords_to_match as (
  select
    lower(ml_keywords) as ml_keywords 
  from {{ ref('int_ml_keywords') }}
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
    ,coalesce(k.ml_keywords, k2.ml_keywords) as ml_keywords
    ,p.post_year
    ,p.post_month
    ,p.title
    ,p.text
    ,row_number() over (partition by p.id, coalesce(k.ml_keywords, k2.ml_keywords) order by p.post_year asc, p.post_month asc) as rn
    from posts p
    -- Check if keyword is in title/text
    left join keywords_to_match k
    on position(k.ml_keywords in p.title) > 0 
    left join keywords_to_match k2
    on position(k2.ml_keywords in p.text) > 0 
    where k.ml_keywords is not null
    or k2.ml_keywords is not null
)

select 
  id
  ,ml_keywords
  ,post_year
  ,post_month
  ,title
  ,text
from posts_w_keywords
where rn = 1 -- Ensure there's no repeated id/keyword combo
order by 1 asc, 2 asc
with keywords_to_match as (
  select
    lower(programming_languages) as programming_languages 
  from {{ ref('int_programming_language_keywords') }}
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
    ,coalesce(k.programming_languages, k2.programming_languages) as programming_languages
    ,p.post_year
    ,p.post_month
    ,p.title
    ,p.text
    ,row_number() over (partition by p.id, coalesce(k.programming_languages, k2.programming_languages)) as rn
    from posts p
    -- Check if keyword is in title/text, and appears after space or at start
    left join keywords_to_match k
    on (p.title LIKE k.programming_languages || '%'
        OR p.title LIKE '% ' || k.programming_languages || '%')
    left join keywords_to_match k2
    on (p.text LIKE k2.programming_languages || '%'
        OR p.text LIKE '% ' || k2.programming_languages || '%')
    where k.programming_languages is not null
    or k2.programming_languages is not null
)

select 
  id
  ,programming_languages
  ,post_year
  ,post_month
  ,title
  ,text
from posts_w_keywords
where rn = 1 -- Ensure there's no repeated id/keyword combo
order by 1 asc, 2 asc
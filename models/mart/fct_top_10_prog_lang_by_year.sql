-- Top 10 programming languages in HN Stories (by year)
with hn_posts as (
    select 
    post_year
    ,post_month
    ,programming_languages
    ,count(id) as n_posts
    from {{ ref('int_hn_story_with_programming_lang') }}
group by 1,2,3
)

select 
    post_year
    ,post_month
    ,programming_languages
    ,n_posts
from (
    select 
        post_year
        ,post_month
        ,programming_languages
        ,n_posts
        ,row_number() over (partition by post_year, post_month order by n_posts desc) as keyword_rank
    from hn_posts
)
where keyword_rank <= 10
order by 1 asc, 3 desc
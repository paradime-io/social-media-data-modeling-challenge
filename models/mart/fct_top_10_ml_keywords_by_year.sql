with hn_ml_posts as (
    select 
    post_year
    ,post_month
    ,ml_keywords
    ,count(id) as n_posts
    from {{ ref('int_hn_story_with_ml_keywords') }}
group by 1,2,3
)

select 
    post_year
    ,post_month
    ,ml_keywords
    ,n_posts
from (
    select 
        post_year
        ,post_month
        ,ml_keywords
        ,n_posts
        ,row_number() over (partition by post_year, post_month order by n_posts desc) as keyword_rank
    from hn_ml_posts
)
where keyword_rank <= 10
order by 1 asc, 3 desc
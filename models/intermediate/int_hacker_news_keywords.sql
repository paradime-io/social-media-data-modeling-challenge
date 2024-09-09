with keywords_occurences as (
    select
        title,
        upper(technologykeys) as technologykeys,
        COUNT(title) OVER () AS qtt_posts
    from {{ ref('stg_hacker_news') }}
    cross join {{ ref('technologyKeywords') }}
    where upper(title) like concat('% ', upper(technologykeys), ' %')
),

total_keywords as (
    select
        technologykeys,
        count(*) as ocurrences,
        qtt_posts
    from keywords_occurences
    group by technologykeys, qtt_posts
    order by ocurrences
)

select *
from total_keywords
order by ocurrences desc

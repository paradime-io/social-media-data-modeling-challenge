select 
    programming_languages
    ,count(id) as n_posts
    from {{ ref('int_hn_story_with_programming_lang') }}
group by 1
order by 2 desc 
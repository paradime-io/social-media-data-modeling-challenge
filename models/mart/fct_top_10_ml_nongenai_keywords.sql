select 
    ml_keywords
    ,count(id) as n_posts
    from (
        select * 
        from {{ ref('int_hn_story_with_ml_keywords') }}
        where ml_keywords not like 'open%ai'
            and ml_keywords not like '%gpt'
            and ml_keywords not like 'llm'
            and ml_keywords not like 'gen%ai'
            and ml_keywords not like 'chat%bot'
            and ml_keywords not like 'language%model'
            and ml_keywords not like 'arize'
            and ml_keywords not like 'bard'
    )
group by 1
order by 2 desc 
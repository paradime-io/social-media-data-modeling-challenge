-- Run after getting sentiment scores w/ Python's nltk
select 
  *
from (
    select 
    ml_keywords
    ,post_year
    ,post_month
    ,avg(neg) as avg_neg
    ,avg(neu) as avg_neu
    ,avg(pos) as avg_pos
from (
    select 
    s.id
    ,s.post_year
    ,s.post_month
    ,g.ml_keywords
    ,g.neg
    ,g.neu
    ,g.pos
    ,g.compound
    from top_ml_keywords_sentiment g
    join int_hn_story_with_ml_keywords s
    using (id)
)
group by 1,2,3
)
unpivot (
  sentiment_score for sentiment_label in (avg_neu, avg_neg, avg_pos)
)
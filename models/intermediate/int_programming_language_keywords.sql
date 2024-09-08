-- Programming languages used by developers according to survey data
with programming_languages as (
  select distinct lang
  from
    (select 
      unnest(programming_languages_used) as lang
    from {{ ref('stg_kaggle_survey') }}
    )
  
  union all 

  select distinct lang
  from
    (select 
      unnest(programming_languages_used) as lang
    from {{ ref('stg_stackoverflow_survey') }}
    )
)

select 
  distinct trim(lower(lang)) as programming_languages
from programming_languages
where 
  lower(lang) not in ('na', 'other', 'none', '')
  and lower(lang) is not null
order by 1 asc
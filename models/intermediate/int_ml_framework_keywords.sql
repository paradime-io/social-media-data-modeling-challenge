with ml_frameworks as (
  select distinct ml_keywords
  from
      (select 
      unnest(ml_frameworks_used) as ml_keywords
      from {{ ref('stg_kaggle_survey') }}
      )
)

select 
  distinct trim(lower(ml_keywords)) as ml_frameworks
from ml_frameworks
where 
  lower(ml_keywords) not in ('na', 'other', 'none', '')
  and lower(ml_keywords) is not null
order by 1 asc
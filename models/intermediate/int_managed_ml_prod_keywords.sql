with ml_key as (
  select distinct ml_keywords
  from
      (select 
      unnest(managed_ml_products_used) as ml_keywords
      from {{ ref('stg_kaggle_survey') }}
      )
)

select 
  distinct trim(lower(ml_keywords)) as managed_ml_products_used
from ml_key
where 
  lower(ml_keywords) not in ('na', 'other', 'none', '')
  and lower(ml_keywords) is not null
order by 1 asc
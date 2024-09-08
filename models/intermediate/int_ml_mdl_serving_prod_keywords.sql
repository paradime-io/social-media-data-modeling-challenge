with ml_key as (
  select distinct ml_keywords
  from
      (select 
      unnest(ml_model_serving_products_used) as ml_keywords
      from {{ ref('stg_kaggle_survey') }}
      )
)

select 
  distinct trim(lower(ml_keywords)) as ml_model_serving_products_used
from ml_key
where 
  lower(ml_keywords) not in ('na', 'other', 'none', '')
  and lower(ml_keywords) is not null
order by 1 asc
select 
  distinct trim(lower(ml_hub_used)) as ml_hub_used
from {{ ref('stg_kaggle_survey') }}
where 
  lower(ml_hub_used) not in ('na', 'other', 'none', '')
  and lower(ml_hub_used) is not null
order by 1 asc
select so.country_name salary_country_name, 
bm.country_name burger_country_name,
so.dollar_salary dollar_salary,
bm.local_to_dollar_price dollar_burger,
round(so.dollar_salary/bm.local_to_dollar_price,1) dollar_burger_salary, 
from {{ ref('stg_survey_cleaned_agg') }} so
cross join {{ ref('stg_bigmac_dollar') }} bm
order by so.country_name   
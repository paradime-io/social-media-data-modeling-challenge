select so.country_name, 
bm.iso_a3,
so.nr_resp,
so.dollar_salary dollar_salary,
bm.local_to_dollar_price dollar_burger,
round(so.dollar_salary/bm.local_to_dollar_price,1) dollar_burger_salary, 
from {{ ref('survey_cleaned_agg') }} so
join {{ ref('bigmac_dollar') }} bm
on so.country_name = bm.country_name
order by so.country_name   
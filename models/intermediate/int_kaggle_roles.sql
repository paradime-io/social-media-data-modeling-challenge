select
  job_role
	,replace(yearly_comp_usd, '$', '') as yearly_comp_usd
	,job_industry
	,country
	,programming_languages_used
	,managed_ml_products_used
	,automated_ml_tools_used
	,ml_model_serving_products_used
	,ml_model_monitoring_tools_used
	,data_products_used
from {{ ref('stg_kaggle_survey') }}
where yearly_comp_usd is not null 
and country like '%United States%'
order by 2 desc
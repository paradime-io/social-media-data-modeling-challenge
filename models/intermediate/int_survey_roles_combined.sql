with survey as (
	select 
	trim(lower(job_role)) as job_role
	,yearly_comp_usd
    ,'kaggle' as survey_source
    ,programming_languages_used
	from {{ ref('int_kaggle_roles') }}

	union all 

	select 
	trim(lower(job_role)) as job_role
	,yearly_comp_usd
	,'stackoverflow' as survey_source
    ,programming_languages_used
	from {{ ref('int_stackoverflow_roles') }}
)

    select 
    row_number() over () as user_id
    ,{{ clean_job_roles('job_role') }} as job_role
    ,yearly_comp_usd
    ,survey_source
    ,programming_languages_used
    from survey
order by 1,2,3 asc

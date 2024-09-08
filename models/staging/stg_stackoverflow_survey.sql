with so_2022 as (
  select
    -- Rename for consistency & clarity
    Employment as employment_status
    ,RemoteWork as remote_work
    ,CodingActivities as code_written_outside_work
    ,EdLevel as education_level
    ,LearnCode as coding_learning_sources
    ,LearnCodeOnline as coding_learning_resources_used
    ,LearnCodeCoursesCert as course_or_cert_used
    ,YearsCode as years_code
    ,YearsCodePro as years_code_pro
    ,DevType as job_role
    ,OrgSize as company_size
    ,Country as country
    ,Currency as currency
    ,CompTotal as comp_total
    ,CompFreq as comp_freq
    ,LanguageHaveWorkedWith as programming_languages_used
    ,LanguageWantToWorkWith as programming_languages_to_use
    ,PlatformHaveWorkedWith as cloud_platforms_used
    ,PlatformWantToWorkWith as cloud_platforms_to_use
    ,Age as age
from {{ source('so', 'stackoverflow_dev_survey_2022') }}
)
, so_2023 as (
  select
    -- Rename for consistency & clarity
    Employment as employment_status
    ,RemoteWork as remote_work
    ,CodingActivities as code_written_outside_work
    ,EdLevel as education_level
    ,LearnCode as coding_learning_sources
    ,LearnCodeOnline as coding_learning_resources_used
    ,LearnCodeCoursesCert as course_or_cert_used
    ,YearsCode as years_code
    ,YearsCodePro as years_code_pro
    ,DevType as job_role
    ,OrgSize as company_size
    ,Country as country
    ,Currency as currency
    ,CompTotal as comp_total -- yearly_comp_usd
    ,LanguageHaveWorkedWith as programming_languages_used
    ,LanguageWantToWorkWith as programming_languages_to_use
    ,PlatformHaveWorkedWith as cloud_platforms_used
    ,PlatformWantToWorkWith as cloud_platforms_to_use
    ,Age as age
from {{ source('so', 'stackoverflow_dev_survey_2023') }}
)

, combined_so as (
select 
  '2022' as survey_year
	,split(employment_status, ';') as employment_status
	,remote_work
	,split(code_written_outside_work, ';') as code_written_outside_work
	,split(education_level, ';') as education_level
	,split(coding_learning_sources, ';') as coding_learning_sources
	,split(coding_learning_resources_used, ';') as coding_learning_resources_used
	,split(course_or_cert_used, ';') as course_or_cert_used
	,years_code
	,years_code_pro
	,split(job_role, ';') as job_role
	,company_size
	,country
	,currency
	,comp_total
	,comp_freq
	,split(programming_languages_used, ';') as programming_languages_used
	,split(programming_languages_to_use, ';') as programming_languages_to_use
	,split(cloud_platforms_used, ';') as cloud_platforms_used
	,split(cloud_platforms_to_use, ';') as cloud_platforms_to_use
	,age
from so_2022

union all 

select 
  '2023' as survey_year
	,split(employment_status, ';') as employment_status
	,remote_work
	,split(code_written_outside_work, ';') as code_written_outside_work
	,split(education_level, ';') as education_level
	,split(coding_learning_sources, ';') as coding_learning_sources
	,split(coding_learning_resources_used, ';') as coding_learning_resources_used
	,split(course_or_cert_used, ';') as course_or_cert_used
	,years_code
	,years_code_pro
	,split(job_role, ';') as job_role
	,company_size
	,country
	,currency
	,comp_total
	,null as comp_freq
	,split(programming_languages_used, ';') as programming_languages_used
	,split(programming_languages_to_use, ';') as programming_languages_to_use
	,split(cloud_platforms_used, ';') as cloud_platforms_used
	,split(cloud_platforms_to_use, ';') as cloud_platforms_to_use
	,age
from so_2023
)

select * from combined_so
order by job_role
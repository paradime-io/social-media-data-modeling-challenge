select
    survey_source
    ,job_role
    ,trim(lower(programming_languages)) as programming_languages
    ,count(distinct user_id) as n_people
from (
    select
    user_id 
    ,job_role
    ,unnest(programming_languages_used) as programming_languages
    ,survey_source
from {{ ref('int_survey_roles_combined') }}
)
where lower(programming_languages) like '%rust%'
group by 1,2,3 
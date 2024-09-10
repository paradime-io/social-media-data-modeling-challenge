select
    survey_source
    ,job_role
    ,yearly_comp_usd
    ,count(user_id) as n_people
from (
    select
    user_id 
    ,job_role
    ,case 
        when yearly_comp_usd like '%1,000,000%' then '> 1,000,000'
        else yearly_comp_usd
    end as yearly_comp_usd
    ,survey_source
from {{ ref('int_survey_roles_combined') }}
)
group by 1,2,3 
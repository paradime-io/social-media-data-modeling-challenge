select
    mapped_country_name as country_name,
    count(Responseid) as Nr_resp,
    median(cast(Comptotal as double)) as Local_salary,
    median(cast(Convertedcompyearly as double)) as Dollar_salary
from {{ ref('stg_survey_mapping') }}
where Convertedcompyearly <> 'NA'
group by mapped_country_name
having count(Responseid) > 5
order by mapped_country_name

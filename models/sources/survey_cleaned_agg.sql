select
    Country,
    Country as Country_name,
    count(Responseid) as Nr_resp,
    median(cast(Comptotal as double)) as Local_salary,
    median(cast(Convertedcompyearly as double)) as Dollar_salary
from {{ source('main', 'survey_results_public') }}
where Responseid not in (
        14355,
        34279,
        17375,
        8815,
        27269,
        52486,
        46993,
        59888,
        20038,
        24678,
        624,
        19713
    )
    and Convertedcompyearly <> 'NA'
group by Country
having count(Responseid) > 5
order by Country

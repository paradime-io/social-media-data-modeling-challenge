with filtered_comp as (
select 
    job_role
    ,comp_total
    ,comp_freq
    ,currency
    ,country
    ,education_level
    ,programming_languages_used
    ,cloud_platforms_used
    ,course_or_cert_used
from {{ ref('stg_stackoverflow_survey') }}
where position('e' in comp_total) = 0 
and ((comp_total is not null) and (comp_total not in ('NA')))
and currency like '%USD%'
)

, cleaned_comp as (
select
    job_role
    ,case 
        when ((comp_freq = 'Monthly') and (comp_total::bigint < 5000)) then comp_total::bigint * 12
        when ((comp_freq = 'Weekly') and (comp_total::bigint < 5000)) then comp_total::bigint * 52
        else comp_total::bigint
    end as yearly_comp_usd
    ,comp_total
    ,comp_freq
    ,country
    ,education_level
    ,programming_languages_used
    ,cloud_platforms_used
    ,course_or_cert_used
from filtered_comp
)

select
    array_to_string(job_role, ', ') as job_role
    ,case 
        when yearly_comp_usd < 999 then '0-999'
        when (yearly_comp_usd >= 999) and (yearly_comp_usd < 2000) then '1,000-1,999'
        when (yearly_comp_usd >= 10000) and (yearly_comp_usd < 15000) then '10,000-14,999'
        when (yearly_comp_usd >= 100000) and (yearly_comp_usd < 125000) then '100,000-124,999'
        when (yearly_comp_usd >= 125000) and (yearly_comp_usd < 150000) then '125,000-149,999'
        when (yearly_comp_usd >= 15000) and (yearly_comp_usd < 20000) then '15,000-19,999'
        when (yearly_comp_usd >= 150000) and (yearly_comp_usd < 200000) then '150,000-199,999'
        when (yearly_comp_usd >= 2000) and (yearly_comp_usd < 3000) then '2,000-2,999'
        when (yearly_comp_usd >= 20000) and (yearly_comp_usd < 25000) then '20,000-24,999'
        when (yearly_comp_usd >= 200000) and (yearly_comp_usd < 250000) then '200,000-249,999'
        when (yearly_comp_usd >= 25000) and (yearly_comp_usd < 30000) then '25,000-29,999'
        when (yearly_comp_usd >= 250000) and (yearly_comp_usd < 300000) then '250,000-299,999'
        when (yearly_comp_usd >= 3000) and (yearly_comp_usd < 4000) then '3,000-3,999'
        when (yearly_comp_usd >= 30000) and (yearly_comp_usd < 40000) then '30,000-39,999'
        when (yearly_comp_usd >= 300000) and (yearly_comp_usd < 500000) then '300,000-499,999'
        when (yearly_comp_usd >= 4000) and (yearly_comp_usd < 5000) then '4,000-4,999'
        when (yearly_comp_usd >= 40000) and (yearly_comp_usd < 50000) then '40,000-49,999'
        when (yearly_comp_usd >= 5000) and (yearly_comp_usd < 7500) then '5,000-7,499'
        when (yearly_comp_usd >= 50000) and (yearly_comp_usd < 60000) then '50,000-59,999'
        when (yearly_comp_usd >= 500000) and (yearly_comp_usd < 1000000) then '500,000-999,999'
        when (yearly_comp_usd >= 60000) and (yearly_comp_usd < 70000) then '60,000-69,999'
        when (yearly_comp_usd >= 7500) and (yearly_comp_usd < 10000) then '7,500-9,999'
        when (yearly_comp_usd >= 70000) and (yearly_comp_usd < 80000) then '70,000-79,999'
        when (yearly_comp_usd >= 80000) and (yearly_comp_usd < 90000) then '80,000-89,999'
        when (yearly_comp_usd >= 90000) and (yearly_comp_usd < 100000) then '90,000-99,999'
        when (yearly_comp_usd >= 1000000) then '> 1,000,000'				
        else ''
    end as yearly_comp_usd
    ,country
    ,education_level
    ,programming_languages_used
    ,cloud_platforms_used
    ,course_or_cert_used
from cleaned_comp
where country like '%United States%'
order by 2 asc
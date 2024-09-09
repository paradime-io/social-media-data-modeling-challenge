with
    intermediate as (
        select
            id
            , given_name
            , family_name
            , full_name
            , gender
            , nationality
            , country_of_birth
            , country_of_residence
            , birth_date
            , num_of_events
            , sports
            , gold_medals
            , silver_medals
            , bronze_medals
            , total_medals
        from {{ ref('int_athletes_bio_pivoted') }}
    )

    , creating_columns as (
        select
            id
            , given_name
            , family_name
            , full_name
            , gender
            , cast(floor(datediff('day', birth_date, current_date()) / 365.25) as int) as age
            , num_of_events
            , gold_medals
            , silver_medals
            , bronze_medals
            , total_medals
            , case when gold_medals > 0 then true else false end as is_gold_medalist
            , case when silver_medals > 0 then true else false end as is_silver_medalist
            , case when bronze_medals > 0 then true else false end as is_bronze_medalist
            , case when total_medals > 0 then true else false end as is_medalist
            , sports[1] as main_sport_id
            , sports[2] as secondary_sport_id
            , nationality as nationality_id
            , country_of_birth as country_of_birth_id
            , country_of_residence as country_of_residence_id
        from intermediate
    )

select *
from creating_columns
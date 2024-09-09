with
    staging as (
        select
            id
            , given_name
            , family_name
            , gender
            , nationality
            , country_of_birth
            , country_of_residence
            , birth_date
            , num_of_events
            , disciplines
            , medals
            , extended_bios
        from {{ ref('stg_olympics_api__athletes_bio') }}
    )

    , unnesting as (
        select
            id
            , given_name
            , family_name
            , gender
            , nationality
            , country_of_birth
            , country_of_residence
            , birth_date
            , num_of_events
            , unnest(disciplines) as sports
            , unnest(medals) as medals
            , unnest(extended_bios) as extended_bios
        from staging
    )

    , pivoting as (
        select
            id
            , given_name
            , family_name
            , concat(given_name, ' ', family_name) as full_name
            , gender
            , nationality
            , country_of_birth
            , country_of_residence
            , birth_date
            , num_of_events
            , array_agg(sports.code) filter (sports.code is not null) as sports
            , {{ pivot_medals('medals.medal_type', '1') }} as gold_medals
            , {{ pivot_medals('medals.medal_type', '2') }} as silver_medals
            , {{ pivot_medals('medals.medal_type', '3') }} as bronze_medals
            , {{ pivot_medals('medals.medal_type', 'total') }} as total_medals
            , {{ pivot_social_media('extended_bios.code', 'INSTAGRAM', 'extended_bios.value') }} as instagram_url
            , {{ pivot_social_media('extended_bios.code', 'TIKTOK', 'extended_bios.value') }} as tiktok_url
            , {{ pivot_social_media('extended_bios.code', 'TWITTER', 'extended_bios.value') }} as x_twitter_url
            , {{ pivot_social_media('extended_bios.code', 'YOUTUBE', 'extended_bios.value') }} as youtube_url
            from unnesting
            group by all
    )

select *
from pivoting
with split_platforms as (
    -- Split the platforms column into individual rows
    select
        id,
        trim(platform) as platform  -- Trim whitespace around each platform
    from (
        select
            id,
            -- Split platforms column by commas and unnest the array
            unnest(split(platforms, ',')) as platform
        from
            {{ ref('stg_social_media_mental_health') }}
        where
            platforms is not null
            and platforms != 'N/A'
    )
)

select
    id,
    platform
from
    split_platforms

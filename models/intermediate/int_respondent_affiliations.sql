with split_affiliations as (
    -- Split the affiliations column into individual rows
    select
        id,
        -- Trim whitespace around each affiliation.
        trim(affiliation) as affiliation
    from (
        select
            id,
            -- Split affiliations column by commas and unnest the array
            unnest(split(affiliations, ',')) as affiliation
        from
            {{ ref('stg_social_media_mental_health') }}
        where
            affiliations is not null
            and affiliations != 'N/A'
    )
)

select
    id,
    affiliation
from
    split_affiliations

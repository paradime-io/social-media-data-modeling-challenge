with base as (
    select
        *
        exclude (platforms, affiliations)
    from {{ ref('stg_social_media_mental_health') }}
)

select
    b.*,
    -- Include the affiliation column from int_respondent_affiliations
    a.affiliation
from
    base as b
left join
    {{ ref('int_respondent_affiliations') }} as a
    on
        b.id = a.id  -- Join on the respondent ID

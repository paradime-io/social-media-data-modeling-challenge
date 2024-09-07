with base as (
    select
        *
        exclude (platforms, affiliations)
    from {{ ref('stg_social_media_mental_health') }}
)

select
    b.*,
    p.platform  -- Include the platform column from int_respondent_platforms
from
    base as b
left join
    {{ ref('int_respondent_platforms') }} as p
    on
        b.id = p.id  -- Join on the respondent ID

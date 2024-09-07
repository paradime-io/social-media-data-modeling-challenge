select
    *
    exclude (platforms, affiliations)
from {{ ref('stg_social_media_mental_health') }}

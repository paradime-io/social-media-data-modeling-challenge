with
    source as (
        select
            url
            , id
            , lower(text) as text
            , sentiment
        from {{ source('web_scraping', 'tweets') }}
    )

select distinct *
from source
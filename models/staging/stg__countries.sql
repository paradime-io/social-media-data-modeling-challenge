select distinct
    tsongs.country as country_code,
    country.country_name,
    country.country_region
from {{ ref('base_universal_top_spotify_songs') }} as tsongs
left join {{ ref('base_countries') }} as country
    on tsongs.country = country.country_code
union
select distinct
    country.country_code,
    country.country_name,
    country.country_region
from {{ ref('base_spotify_top_50_playlists') }} as t50
left join {{ ref('base_countries') }} as country
    on lower(t50.country) = lower(country.country_name)

select 
median(position) as median_position,
art.artists,
song.song,
pool.song_age,
country.country_region
from {{ ref('more_than_five_year_old_songs_in_top10_by_country_by_snapshot_date') }} pool
left join {{ ref('dim_artists') }} art on
	pool.fk_artists = art.artists_pk
left join {{ ref('dim_countries') }} country
on
	pool.fk_country = country.countries_pk

left join {{ ref('dim_songs') }} song
on
	pool.fk_song = song.song_pk
where pool.song_age >= 25
group by all

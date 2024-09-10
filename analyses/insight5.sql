--Artists with old songs
select 
pool.snapshot_date,
position,
art.artists,
country.country_code,
country.country_region,
song.song,
song.release_date,
pool.song_age
from {{ ref('more_than_five_year_old_songs_in_top10_by_country_by_snapshot_date') }} pool
inner join {{ ref('artists_top10_in_more_than_one_country_by_snapshot_date') }} pool2
on pool.fk_artists = pool2.fk_artists and pool.snapshot_date = pool2.snapshot_date and pool.fk_country = pool2.fk_country
left join {{ ref('dim_artists') }} art on
	pool.fk_artists = art.artists_pk
left join {{ ref('dim_countries') }} country
on
	pool.fk_country = country.countries_pk

left join {{ ref('dim_songs') }} song
on
	pool.fk_song = song.song_pk
where song_age >= 25 and pool2.count_artist_distinct_country >= 15
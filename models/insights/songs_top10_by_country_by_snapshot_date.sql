SELECT
pool.snapshot_date,
pool.position ,
pool.popularity ,
pool.release_date ,
art.artists ,
country.country_name , country.country_region ,
song.song ,
song.spotify_id 
FROM
	{{ ref('fact_qualified_songs') }}  pool
left join {{ ref('dim_artists') }} art on
	pool.artists_pk = art.artists_pk
left join {{ ref('dim_countries') }} country
on
	pool.countries_pk = country.countries_pk
left join {{ ref('dim_songs') }} song
on
	pool.song_pk = song.song_pk
where position <= 10
group by all

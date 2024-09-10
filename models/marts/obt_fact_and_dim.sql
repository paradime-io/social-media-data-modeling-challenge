select *
FROM
	{{ ref('fact_qualified_songs') }}  pool
left join {{ ref('dim_artists') }} art on
	pool.fk_artists = art.artists_pk
left join {{ ref('dim_countries') }} country
on
	pool.fk_country = country.countries_pk
left join {{ ref('dim_songs') }} song
on
	pool.fk_song = song.song_pk
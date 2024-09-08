select *
FROM
	{{ ref('fact_qualified_songs') }}  pool
left join {{ ref('dim_artists') }} art on
	pool.artists_pk = art.fk_artists
left join {{ ref('dim_countries') }} country
on
	pool.countries_pk = country.fk_country
left join {{ ref('dim_songs') }} song
on
	pool.song_pk = song.fk_song
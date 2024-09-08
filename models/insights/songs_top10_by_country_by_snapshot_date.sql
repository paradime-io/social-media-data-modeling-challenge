SELECT
pool.snapshot_date,
pool.position ,
pool.popularity ,
pool.release_date ,
fk_artists,
fk_country,
fk_song,
FROM
	{{ ref('fact_qualified_songs') }}  pool
where position <= 10
group by all

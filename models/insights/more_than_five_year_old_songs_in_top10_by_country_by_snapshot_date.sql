SELECT
snapshot_date,
position ,
release_date ,
fk_artists ,
fk_country,
fk_song,
year(snapshot_date) - year(pool.release_date) as song_age
FROM
	{{ ref('fact_qualified_songs') }}  pool
where position <= 10
and year(snapshot_date) - year(pool.release_date) >= 5
group by all
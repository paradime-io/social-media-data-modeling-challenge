with pool as (
SELECT
pool.snapshot_date,
pool.release_date ,
fk_song,
fk_artists,
fk_country,
count(distinct fk_country) over (partition by snapshot_date, fk_song) as count_song_distinct_country
FROM
	{{ ref('fact_qualified_songs') }}  pool
where position <= 10
and fk_country is not null 
group by 
pool.snapshot_date,
pool.position ,
pool.release_date ,
fk_song,
fk_artists,
fk_country
)
select * from pool 
where count_song_distinct_country > 2
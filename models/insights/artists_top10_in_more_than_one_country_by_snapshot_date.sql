with pool as (
SELECT
pool.snapshot_date,
pool.release_date ,
pool.fk_artists,
pool.fk_song,
pool.fk_country,
count(distinct fk_country) over (partition by snapshot_date, fk_artists) as count_artist_distinct_country
FROM
	{{ ref('fact_qualified_songs') }}  pool
where position <= 10
and pool.fk_country is not null 
group by 
pool.snapshot_date,
pool.release_date ,
pool.fk_artists,
pool.fk_song,
pool.fk_country
)
select 
snapshot_date, 
fk_country,
fk_artists,
count_artist_distinct_country,
count(distinct fk_song) as count_distinct_song 
from pool 
where count_artist_distinct_country > 2
group by all
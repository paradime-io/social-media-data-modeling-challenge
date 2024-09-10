with pool as (
    select
        snapshot_date,
        position,
        release_date,
        fk_artists,
        fk_country,
        fk_song,
        min(snapshot_date)
            over (partition by fk_song order by fk_song)
            as first_month_all_country,
        max(snapshot_date)
            over (partition by fk_song order by fk_song)
            as max_month_all_country,
        date_diff(
            'month',
            min(snapshot_date) over (partition by fk_song order by fk_song),
            max(snapshot_date) over (partition by fk_song order by fk_song)
        ) as estimated_number_month_top_50_all_countries,
        min(snapshot_date)
            over (partition by fk_country, fk_song order by fk_country, fk_song)
            as first_month_country,
        max(snapshot_date)
            over (partition by fk_country, fk_song order by fk_country, fk_song)
            as max_month_country,
        date_diff(
            'month',
            min(snapshot_date)
                over (partition by fk_country, fk_song order by fk_country, fk_song),
            max(snapshot_date)
                over (
                    partition by fk_country, fk_song
                    order by fk_country, fk_song
                )
        ) as estimated_number_month_top_50_by_countries
    from
        {{ ref('fact_qualified_songs') }}
    where position <= 10
--and year(snapshot_date) - year(pool.release_date) >= 5
)

select
    snapshot_date,
    fk_country,
    fk_song,
    fk_artists,
    estimated_number_month_top_50_by_countries,
    first_month_country,
    max_month_country,
    estimated_number_month_top_50_all_countries,
    first_month_all_country,
    max_month_all_country
from pool
where  
(estimated_number_month_top_50_by_countries >= 6 and first_month_country <= snapshot_date and (max_month_country = snapshot_date or max_month_country = snapshot_date))
or 
(estimated_number_month_top_50_all_countries >=6  and first_month_all_country <= snapshot_date and (max_month_all_country = snapshot_date or max_month_all_country = snapshot_date))
and position <= 10
group by all


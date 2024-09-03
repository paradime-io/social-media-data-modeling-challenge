WITH preprocessed_genres AS (
    SELECT
    track_id,
    track_name,
    genres,
    REGEXP_REPLACE(
        REGEXP_REPLACE(CAST(genres AS STRING), '\\[|\\]', ''), 
        '''', ''
    ) AS genre_string
FROM {{ ref('int_spotify_apple_joined') }}
),

final as (
SELECT 
    track_id,
    track_name,
    genre_string,
    CASE 
        WHEN genre_string ILIKE '%country%' THEN 'Country'
        WHEN genre_string ILIKE '%disco%' THEN 'Disco'
        WHEN genre_string ILIKE '%latin%' OR genre_string ILIKE '%trap latino%' THEN 'Latin'
        WHEN genre_string ILIKE '%bhangra%' OR genre_string ILIKE '%desi%' OR genre_string ILIKE '%punjabi%' THEN 'Bhangra'
        WHEN genre_string ILIKE '%house%' THEN 'House'
        WHEN genre_string ILIKE '%hip hop%' OR genre_string ILIKE '%rap%' THEN 'Hip Hop'
        WHEN genre_string ILIKE '%dance%' OR genre_string ILIKE '%edm%' OR genre_string ILIKE '%euro%' THEN 'Dance'
        WHEN genre_string ILIKE '%jazz%' THEN 'Jazz'
        WHEN genre_string ILIKE '%pop%' THEN 'Pop'
        WHEN genre_string ILIKE '%indie%' THEN 'Indie'
        WHEN genre_string ILIKE '%rock%' THEN 'Rock'
        WHEN genre_string ILIKE '%club%' THEN 'Club'
        WHEN genre_string ILIKE '%bollywood%' OR genre_string ILIKE '%desi%' THEN 'Bollywood'
        WHEN genre_string ILIKE '%trance%' THEN 'Trance'
        WHEN genre_string ILIKE '%soundtrack%' OR genre_string ILIKE '%video game music%' THEN 'Soundtrack'
        WHEN genre_string ILIKE '%funk%' THEN 'Funk'
        WHEN genre_string ILIKE '%sinhala%' THEN 'Sinhala Pop'
        WHEN genre_string ILIKE '%urbano espanol%' THEN 'Latin'
        WHEN genre_string ILIKE '%adoracao%' OR genre_string ILIKE '%brazilian gospel%' THEN 'Gospel'
        WHEN genre_string ILIKE '%euphoric hardstyle%' OR genre_string ILIKE '%hardstyle%' OR genre_string ILIKE '%rawstyle%' THEN 'Hardstyle'
        WHEN genre_string ILIKE '%otacore%' THEN 'Anime'
        WHEN genre_string ILIKE '%nwobhm%' THEN 'Metal'
        WHEN genre_string ILIKE '%carnaval%' THEN 'Carnaval'
        WHEN genre_string ILIKE '%lo-fi beats%' OR genre_string ILIKE '%lo-fi cover%' THEN 'Lo-Fi'
        WHEN genre_string ILIKE '%groove room%' THEN 'Groove'
        WHEN genre_string ILIKE '%neo soul%' OR genre_string ILIKE '%r&b%' THEN 'R&B'
        WHEN genre_string ILIKE '%brooklyn drill%' THEN 'Drill'
        WHEN genre_string ILIKE '%bardcore%' THEN 'Bardcore'
        WHEN genre_string ILIKE '%electro%' OR genre_string ILIKE '%ghettotech%' THEN 'Electro'
        WHEN genre_string ILIKE '%rif%' THEN 'Rock'
        WHEN genre_string ILIKE '%reggae fusion%' THEN 'Reggae Fusion'
        ELSE 'Other'
    END AS generalized_genre
FROM preprocessed_genres
)

select * from final 

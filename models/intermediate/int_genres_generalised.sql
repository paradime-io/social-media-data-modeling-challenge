WITH preprocessed_genres AS (
    SELECT
        track_id,
        track_name,
        artist_name,
        genres,
        REGEXP_REPLACE(
            REGEXP_REPLACE(CAST(genres AS STRING), '\\[|\\]', ''), 
            '''', ''
        ) AS genre_string
    FROM {{ ref('int_spotify_full_tracks') }}
),

preprocess_genre AS (
    SELECT 
        track_id,
        track_name,
        genre_string,
        artist_name, 
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
),

prepreprocesses_genre AS (
    SELECT  
        track_id,
        track_name,
        genre_string,
        CASE 
            WHEN artist_name = 'James Arthur' THEN 'Pop'
            WHEN artist_name = 'Dua Lipa' THEN 'Pop'
            WHEN artist_name = 'Cults' THEN 'Indie'
            WHEN artist_name = 'Loubet' THEN 'Country'
            WHEN artist_name = 'HVME' THEN 'EDM'
            WHEN artist_name = 'David Penn' THEN 'House'
            WHEN artist_name = 'E-40' THEN 'Hip Hop'
            WHEN artist_name = 'Adele' THEN 'Pop'
            WHEN artist_name = 'LiSA' THEN 'Anime'
            WHEN artist_name = 'Goldfinger' THEN 'Rock'
            WHEN artist_name = 'Avicii' THEN 'EDM'
            WHEN artist_name = 'Ying Yang Twins' THEN 'Hip Hop'
            WHEN artist_name = 'Tech N9ne' THEN 'Hip Hop'
            WHEN artist_name = 'Queen' THEN 'Rock'
            WHEN artist_name = 'K3' THEN 'Pop'
            WHEN artist_name = 'A.c.t' THEN 'Progressive Rock'
            WHEN artist_name = 'Tiësto' THEN 'Trance'
            WHEN artist_name = 'Hank Mobley' THEN 'Jazz'
            WHEN artist_name = 'Eminem' THEN 'Hip Hop'
            WHEN artist_name = 'Roar' THEN 'Indie Rock'
            WHEN artist_name = 'Kevin MacLeod' THEN 'Soundtrack'
            WHEN artist_name = 'Maluma' THEN 'Latin'
            WHEN artist_name = 'Andra Day' THEN 'R&B'
            WHEN lower(trim(artist_name)) = 'wizkid' THEN 'Afrobeats'
            WHEN artist_name = 'Juan' THEN 'Latin'
            WHEN artist_name = 'Akon' THEN 'R&B'
            WHEN artist_name = 'Sam Smith' THEN 'Pop'
            WHEN artist_name = 'Soufian' THEN 'Hip Hop'
            WHEN artist_name = 'Ilan Eshkeri' THEN 'Soundtrack'
            WHEN artist_name = 'Drake' THEN 'Hip Hop'
            WHEN artist_name = 'Pharmacist' THEN 'Hip Hop'
            WHEN artist_name = 'Black Eyed Peas' THEN 'Hip Hop'
            WHEN artist_name = 'Blondie' THEN 'Rock'
            WHEN artist_name = 'NF' THEN 'Hip Hop'
            WHEN artist_name = 'Stellar' THEN 'K-Pop'
            WHEN artist_name = 'Pixies' THEN 'Indie Rock'
            WHEN artist_name = 'Sundre' THEN 'Indie'
            WHEN lower(trim(artist_name)) = 'masterd' THEN 'Hip Hop'
            WHEN artist_name = 'Michael Jackson' THEN 'Pop'
            WHEN artist_name = 'Noisecontrollers' THEN 'Hardstyle'
            WHEN artist_name = 'Becky G' THEN 'Latin'
            WHEN artist_name = 'KAROL G' THEN 'Latin'
            WHEN artist_name = 'Jack Stauber' THEN 'Indie'
            WHEN artist_name = 'Armin van Buuren' THEN 'Trance'
            WHEN artist_name = 'Wintertime' THEN 'Hip Hop'
            WHEN artist_name = 'Endor' THEN 'House'
            WHEN artist_name = 'MitiS' THEN 'EDM'
            WHEN artist_name = 'J. Cole' THEN 'Hip Hop'
            WHEN artist_name = 'El Esca' THEN 'Latin'
            WHEN artist_name = 'XXXTENTACION' THEN 'Hip Hop'
            WHEN artist_name = 'Hollywood Undead' THEN 'Rock'
            WHEN artist_name = 'Sigurd Barrett' THEN 'Children’s Music'
            WHEN artist_name = 'Hannah Montana' THEN 'Pop'
            WHEN artist_name = 'Moca' THEN 'Hip Hop'
            WHEN artist_name = 'Justin Timberlake' THEN 'Pop'
            WHEN artist_name = 'Ashmit' THEN 'Hip Hop'
            WHEN artist_name = 'ACR' THEN 'Rock'
            WHEN artist_name = 'DJ Godfather' THEN 'Ghettotech'
            WHEN artist_name = 'Sada Baby' THEN 'Hip Hop'
            WHEN artist_name = 'Bruno Mars' THEN 'Pop'
            WHEN artist_name = 'Savage' THEN 'Hip Hop'
            WHEN artist_name = 'OMC' THEN 'Pop'
            WHEN artist_name = 'John Wolf' THEN 'Country'
            WHEN artist_name = 'Cele' THEN 'Indie'
            WHEN artist_name = 'Lemon Demon' THEN 'Indie'
            WHEN artist_name = 'Synk' THEN 'Electronic'
            WHEN artist_name = 'MC Teteu' THEN 'Funk'
            WHEN artist_name = 'Bazzi' THEN 'Pop'
            WHEN artist_name = 'Stef Bos' THEN 'Pop'
            WHEN artist_name = 'Lady Gaga' THEN 'Pop'
            ELSE generalized_genre
        END AS genres
    FROM preprocess_genre
)

SELECT * FROM prepreprocesses_genre

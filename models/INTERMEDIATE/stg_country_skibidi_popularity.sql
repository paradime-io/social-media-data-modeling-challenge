WITH geomap_youtube AS (
    SELECT 
        "Country" as country,
        "skibidi toilet: (8/1/20 - 8/13/24)" as skibidi_popularity,
        'Youtube' as search_engine
    FROM 
        {{ source('dbt_paradime_nancy_amandi', 'geoMap__Youtube') }}
    ),
geomap_web_search AS (
    SELECT 
        "Country" as country,
        "skibidi toilet: (8/1/20 - 8/13/24) - popularity measure" as skibidi_popularity,
        'Web search' as search_engine
    FROM 
        {{ source('dbt_paradime_nancy_amandi', 'geoMap1_Websearch') }}
    )
SELECT * FROM geomap_youtube
UNION ALL
SELECT * FROM geomap_web_search
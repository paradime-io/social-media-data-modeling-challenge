SELECT 
    CAST("Week" AS DATE) AS week,
    "skibidi toilet",
    "review phim",
    "sourav joshi vlogs",
    "dhar mann",
    "olivia rodrigo"
FROM
    {{ source('dbt_paradime_nancy_amandi', 'top_google_trends_search_timelin') }}
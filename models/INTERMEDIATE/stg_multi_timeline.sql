WITH multitimeline_websearch AS (
    SELECT 
        strftime('%Y%m%d', CAST("Week" AS DATE)) AS date_id,
        "Week" as week_start,
        CASE 
            WHEN "skibidi toilet: (Worldwide) - popularity measure(%)" = '<1' THEN 0
            ELSE CAST("skibidi toilet: (Worldwide) - popularity measure(%)" AS INT)
        END as skibidi_popularity,
        'Web search' as search_engine
    FROM 
        {{ source('dbt_paradime_nancy_amandi', 'multiTimeline__Websearch') }}
),
multitimeline_youtube AS (
    SELECT 
        strftime('%Y%m%d', CAST("Week" AS DATE)) AS date_id,
        "Week" as week_start,
        CASE 
            WHEN "skibidi toilet: (Worldwide)" = '<1' THEN 0
            ELSE CAST("skibidi toilet: (Worldwide)" AS INT)
        END as skibidi_popularity,
        'Youtube' as search_engine
    FROM 
        {{ source('dbt_paradime_nancy_amandi', 'multiTimeline_Youtube') }}
)

SELECT * FROM multitimeline_websearch
UNION ALL
SELECT * FROM multitimeline_youtube

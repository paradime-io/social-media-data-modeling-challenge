WITH distinct_yt_country AS (
    SELECT
    distinct country
    FROM {{ ref('stg_yt_trending') }} 
),
    country_code_mapping AS (
    SELECT
    * 
    FROM {{source('main','country_code_mapping')}}
    )
,
    final AS (
        SELECT 
        distinct_yt_country.country as country_code,
        country_code_mapping.Name as country_desc
        FROM distinct_yt_country
        LEFT OUTER JOIN country_code_mapping ON
        distinct_yt_country.country = country_code_mapping.Code
    )
SELECT
country_code,
country_desc
FROM final


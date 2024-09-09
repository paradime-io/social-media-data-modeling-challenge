WITH distinct_yt_country AS (
    SELECT DISTINCT
        country
    FROM {{ ref('stg_yt_trending') }} 
    WHERE trending_date >= current_date - {{ var('days_to_load', 5) }}
)
, country_code_mapping AS (
    SELECT
    * 
    FROM {{source('main','country_code_mapping')}}
)
, joined AS (
        SELECT 
            distinct_yt_country.country AS country_code,
            country_code_mapping.Name AS country_desc
        FROM distinct_yt_country
        LEFT OUTER JOIN country_code_mapping ON
            distinct_yt_country.country = country_code_mapping.Code
)
, add_keys AS (
        SELECT
            -- Surrogate key
            {{ dbt_utils.generate_surrogate_key(['country_code', 'country_desc']) }}  AS dim_yt_country_sk,
            country_code,
            country_desc
        FROM joined
)
SELECT
    dim_yt_country_sk,
    country_code,
    country_desc
FROM add_keys


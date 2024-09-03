WITH prep_yt_category AS (
    SELECT 
    *
    FROM {{ref('prep_yt_category')}}
)
, dim_country AS (
    SELECT
        dim_yt_country_sk,
        country_code
    FROM {{ref('dim_country')}}
)
, add_keys AS (
    SELECT
        --Primary Key
        prep_yt_category.dim_yt_category_sk,

        --Natural Key
        prep_yt_category.category_business_id,
        prep_yt_category.category_id,

        --Foreign Keys
        dim_country.dim_yt_country_sk,
        --Attributes
        prep_yt_category.category_title,
        prep_yt_category.category_assigned,
        prep_yt_category.country_code,
        prep_yt_category.category_date,
        get_current_timestamp() as etl_timestamp
    FROM prep_yt_category
    LEFT OUTER JOIN dim_country
        ON prep_yt_category.country_code = dim_country.country_code  
)
SELECT
    dim_yt_category_sk,
    category_business_id,
    category_id,
    dim_yt_country_sk,
    category_title,
    category_assigned,
    country_code,
    category_date,
    etl_timestamp
FROM add_keys

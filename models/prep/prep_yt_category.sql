WITH stg_yt_category AS (
    SELECT 
    *
    FROM {{ ref('stg_yt_category') }}
)
, get_max_category_date AS (
    SELECT
        max(category_date) AS max_category_date
    FROM stg_yt_category
)
, add_keys AS (
    SELECT
        -- surrogate key
        {{dbt_utils.generate_surrogate_key(['id', 'country', 'assignable'])}} AS dim_yt_category_sk,
        id||'-'||country||'-'||assignable AS category_business_id,
        id AS category_id,
        title AS category_title,
        assignable AS category_assigned,
        country AS country_code,
        category_date
    FROM stg_yt_category
    INNER JOIN get_max_category_date
        ON stg_yt_category.category_date = get_max_category_date.max_category_date

)
SELECT
    dim_yt_category_sk,
    category_business_id,
    category_id,
    category_title,
    category_assigned,
    country_code,
    category_date
FROM add_keys

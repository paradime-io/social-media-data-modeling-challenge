WITH source AS (
    SELECT 
        sid,
        profile_id,
        post_date,
        post_time,
        post_type,
        description,
        description_category
    FROM {{ ref('stg_instagram') }}
)

SELECT
    *,
    LENGTH(description) AS description_length,
    EXTRACT(DOW FROM post_date) AS post_day_of_week,
    EXTRACT(HOUR FROM post_time) AS post_hour_of_day
FROM source
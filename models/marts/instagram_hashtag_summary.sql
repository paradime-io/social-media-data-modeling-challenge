{{ config(
    materialized='table'
) }}

SELECT *
FROM {{ ref('int_instagram_hashtags') }}
{{ config(
    materialized='incremental',
    unique_key='id'
) }}

WITH hacker_news_data AS (
    SELECT
      id,
      type,
      author,
      created_at,
      title,
      text,
      url,
      score,
      parent
    FROM
      {{ source('raw', 'hacker_news') }}
    {% if is_incremental() %}
      -- Only process new records in incremental runs
      WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
    {% else %}
      -- On full runs, use dynamic or configured start date and cast to date
      WHERE created_at >= CAST('{{ var("start_date", "2024-08-12") }}' AS DATE)
    {% endif %}
)

SELECT
  id,
  type,
  author,
  created_at,
  title,
  text,
  url,
  score,
  parent
FROM
  hacker_news_data

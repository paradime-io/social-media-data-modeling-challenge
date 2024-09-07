SELECT * FROM {{ source('dbt_paradime_nancy_amandi', 'Youtube_playlist_comments') }}
OFFSET 1
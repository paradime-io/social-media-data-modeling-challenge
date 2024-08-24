SELECT *
FROM {{ ref ('stg_argentina_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_australia_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_bolivia_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_chile_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_ecuador_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_guatemala_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_honduras_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_indonesia_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_malaysia_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_mexico_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_mongolia_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_myanmar_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_new_zealand_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_nicaragua_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_panama_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_paraguay_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_peru_youtube') }}
UNION ALL
SELECT * 
FROM {{ ref ('stg_philippines_youtube') }}
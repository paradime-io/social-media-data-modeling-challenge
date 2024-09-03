WITH raw_date AS (
    SELECT
    *
    FROM {{ source('main', 'raw_date')}}
)
, transform AS (
    SELECT
        CAST(strftime(full_date, '%Y%m%d') AS integer) AS dim_date_sk,
        full_date,
        EXTRACT(MONTH FROM full_date) AS month_number,
        strftime( full_date, '%Y-%m') AS date_month,
        concat (EXTRACT(YEAR FROM full_date), '-Q', EXTRACT(QUARTER FROM full_date)) AS date_quarter,
        EXTRACT(YEAR FROM full_date) AS date_year,
        CASE WHEN(isodow(full_date) BETWEEN 1 AND 5) THEN FALSE ELSE TRUE END  AS is_weekend
    FROM raw_date
)
SELECT
    dim_date_sk,
    full_date,
    month_number,
    date_month,
    date_quarter,
    date_year,
    is_weekend
FROM transform
   

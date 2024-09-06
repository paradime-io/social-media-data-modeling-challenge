select mapped_country_name country_name, 
iso_a3,
currency_code,
local_price, 
dollar_ex, 
round(local_price/dollar_ex,1) local_to_dollar_price, 
FROM {{ ref('bigmac_mapping') }}
where date = '2024-07-01'
order by mapped_country_name 
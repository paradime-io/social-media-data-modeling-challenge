select name, 
iso_a3,
currency_code,
local_price, 
dollar_ex, 
round(local_price/dollar_ex,1) local_to_dollar_price, 
FROM {{ source('main', 'big_mac_source_data_v2') }} 
where date = '2024-07-01'
order by name 
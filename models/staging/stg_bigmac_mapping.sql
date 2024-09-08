-- Replace country names in big_mac_source_data
SELECT COALESCE(cnm.new_name, bmsd.name) AS mapped_country_name, bmsd.*
FROM {{ source('main', 'big_mac_source_data_v2') }}  bmsd
LEFT JOIN {{ ref('stg_country_mapping') }} cnm
ON bmsd.name = cnm.old_name
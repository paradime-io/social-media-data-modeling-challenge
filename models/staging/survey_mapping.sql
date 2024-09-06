-- Replace country names in survey_results_public
SELECT COALESCE(cnm.new_name, srp.Country) AS mapped_country_name , srp.*
FROM {{ source('main', 'survey_results_public') }} srp
LEFT JOIN {{ ref('country_mapping') }} cnm
ON srp.Country = cnm.old_name

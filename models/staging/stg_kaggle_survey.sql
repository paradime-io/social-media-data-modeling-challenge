with kaggle_data as (
  SELECT
  row_number() over (order by (select null)) as row_num
  ,Q2 AS age
  ,Q3 AS gender
  ,Q4 AS country
  ,Q5 AS student
  ,concat_ws('|',
      nullif(Q6_1, '')
      ,nullif(Q6_2, '')
      ,nullif(Q6_3, '')
      ,nullif(Q6_4, '')
      ,nullif(Q6_5, '')
      ,nullif(Q6_6, '')
      ,nullif(Q6_7, '')
      ,nullif(Q6_8, '')
      ,nullif(Q6_9, '')
      ,nullif(Q6_10, '')
      ,nullif(Q6_11, '')
      ,nullif(Q6_12, '')
    ) AS data_science_learning_platform
  ,concat_ws('|',
      nullif(Q7_1, '')
      ,nullif(Q7_2, '')
      ,nullif(Q7_3, '')
      ,nullif(Q7_4, '')
      ,nullif(Q7_5, '')
      ,nullif(Q7_6, '')
      ,nullif(Q7_7, '')
    ) AS helpful_platforms_learning_ds
  ,Q8 AS highest_education_level_attained_or_planned
  ,Q9 AS published_academic_research
  ,concat_ws('|',
      nullif(Q10_1, '')
      ,nullif(Q10_2, '')
      ,nullif(Q10_3, '')
    ) AS ml_usage_in_research
  ,Q11 AS years_coding_experience
  ,concat_ws('|',
      nullif(Q12_1, '')
      ,nullif(Q12_2, '')
      ,nullif(Q12_3, '')
      ,nullif(Q12_4, '')
      ,nullif(Q12_5, '')
      ,nullif(Q12_6, '')
      ,nullif(Q12_7, '')
      ,nullif(Q12_8, '')
      ,nullif(Q12_9, '')
      ,nullif(Q12_10, '')
      ,nullif(Q12_11, '')
      ,nullif(Q12_12, '')
      ,nullif(Q12_13, '')
      ,nullif(Q12_14, '')
      ,nullif(Q12_15, '')
    ) AS programming_languages_used
  ,concat_ws('|',
      nullif(Q13_1, '')
      ,nullif(Q13_2, '')
      ,nullif(Q13_3, '')
      ,nullif(Q13_4, '')
      ,nullif(Q13_5, '')
      ,nullif(Q13_6, '')
      ,nullif(Q13_7, '')
      ,nullif(Q13_8, '')
      ,nullif(Q13_9, '')
      ,nullif(Q13_10, '')
      ,nullif(Q13_11, '')
      ,nullif(Q13_12, '')
      ,nullif(Q13_13, '')
      ,nullif(Q13_14, '')
    ) AS ides_used
  ,Q16 AS years_using_ml
  ,concat_ws('|',
      nullif(Q17_1, '')
      ,nullif(Q17_2, '')
      ,nullif(Q17_3, '')
      ,nullif(Q17_4, '')
      ,nullif(Q17_5, '')
      ,nullif(Q17_6, '')
      ,nullif(Q17_7, '')
      ,nullif(Q17_8, '')
      ,nullif(Q17_9, '')
      ,nullif(Q17_10, '')
      ,nullif(Q17_11, '')
      ,nullif(Q17_12, '')
      ,nullif(Q17_13, '')
      ,nullif(Q17_14, '')
      ,nullif(Q17_15, '')
    ) AS ml_frameworks_used
  ,concat_ws('|',
      nullif(Q18_1, '')
      ,nullif(Q18_2, '')
      ,nullif(Q18_3, '')
      ,nullif(Q18_4, '')
      ,nullif(Q18_5, '')
      ,nullif(Q18_6, '')
      ,nullif(Q18_7, '')
      ,nullif(Q18_8, '')
      ,nullif(Q18_9, '')
      ,nullif(Q18_10, '')
      ,nullif(Q18_11, '')
      ,nullif(Q18_12, '')
      ,nullif(Q18_13, '')
      ,nullif(Q18_14, '')
    ) AS ml_algos_used
  ,concat_ws('|',
      nullif(Q19_1, '')
      ,nullif(Q19_2, '')
      ,nullif(Q19_3, '')
      ,nullif(Q19_4, '')
      ,nullif(Q19_5, '')
      ,nullif(Q19_6, '')
      ,nullif(Q19_7, '')
      ,nullif(Q19_8, '')
    ) AS cv_methods_used
  ,concat_ws('|',
      nullif(Q20_1, '')
      ,nullif(Q20_2, '')
      ,nullif(Q20_3, '')
      ,nullif(Q20_4, '')
      ,nullif(Q20_5, '')
      ,nullif(Q20_6, '')
    ) AS nlp_methods_used
  ,concat_ws('|',
      nullif(Q21_1, '')
      ,nullif(Q21_2, '')
      ,nullif(Q21_3, '')
      ,nullif(Q21_4, '')
      ,nullif(Q21_5, '')
      ,nullif(Q21_6, '')
      ,nullif(Q21_7, '')
      ,nullif(Q21_8, '')
      ,nullif(Q21_9, '')
      ,nullif(Q21_10, '')
    ) AS pretrained_model_sources_used
  ,Q22 AS ml_hub_used
  ,Q23 AS job_role
  ,Q24 AS job_industry
  ,Q25 AS company_size
  ,Q26 AS data_science_team_size
  ,Q29 AS yearly_comp_usd
  ,Q30 AS ml_cloud_spending_last_5yrs_usd
  ,concat_ws('|',
      nullif(Q31_1, '')
      ,nullif(Q31_2, '')
      ,nullif(Q31_3, '')
      ,nullif(Q31_4, '')
      ,nullif(Q31_5, '')
      ,nullif(Q31_6, '')
      ,nullif(Q31_7, '')
      ,nullif(Q31_8, '')
      ,nullif(Q31_9, '')
      ,nullif(Q31_10, '')
      ,nullif(Q31_11, '')
      ,nullif(Q31_12, '')
    ) AS cloud_platforms_used
  ,concat_ws('|',
      nullif(Q35_1, '')
      ,nullif(Q35_2, '')
      ,nullif(Q35_3, '')
      ,nullif(Q35_4, '')
      ,nullif(Q35_5, '')
      ,nullif(Q35_6, '')
      ,nullif(Q35_7, '')
      ,nullif(Q35_8, '')
      ,nullif(Q35_9, '')
      ,nullif(Q35_10, '')
      ,nullif(Q35_11, '')
      ,nullif(Q35_12, '')
      ,nullif(Q35_13, '')
      ,nullif(Q35_14, '')
      ,nullif(Q35_15, '')
      ,nullif(Q35_16, '')
    ) AS data_products_used
  ,concat_ws('|',
      nullif(Q36_1, '')
      ,nullif(Q36_2, '')
      ,nullif(Q36_3, '')
      ,nullif(Q36_4, '')
      ,nullif(Q36_5, '')
      ,nullif(Q36_6, '')
      ,nullif(Q36_7, '')
      ,nullif(Q36_8, '')
      ,nullif(Q36_9, '')
      ,nullif(Q36_10, '')
      ,nullif(Q36_11, '')
      ,nullif(Q36_12, '')
      ,nullif(Q36_13, '')
      ,nullif(Q36_14, '')
      ,nullif(Q36_15, '')
    ) AS bi_tools_used
  ,concat_ws('|',
      nullif(Q37_1, '')
      ,nullif(Q37_2, '')
      ,nullif(Q37_3, '')
      ,nullif(Q37_4, '')
      ,nullif(Q37_5, '')
      ,nullif(Q37_6, '')
      ,nullif(Q37_7, '')
      ,nullif(Q37_8, '')
      ,nullif(Q37_9, '')
      ,nullif(Q37_10, '')
      ,nullif(Q37_11, '')
      ,nullif(Q37_12, '')
      ,nullif(Q37_13, '')
    ) AS managed_ml_products_used
  ,concat_ws('|',
      nullif(Q38_1, '')
      ,nullif(Q38_2, '')
      ,nullif(Q38_3, '')
      ,nullif(Q38_4, '')
      ,nullif(Q38_5, '')
      ,nullif(Q38_6, '')
      ,nullif(Q38_7, '')
      ,nullif(Q38_8, '')
    ) AS automated_ml_tools_used
  ,concat_ws('|',
      nullif(Q39_1, '')
      ,nullif(Q39_2, '')
      ,nullif(Q39_3, '')
      ,nullif(Q39_4, '')
      ,nullif(Q39_5, '')
      ,nullif(Q39_6, '')
      ,nullif(Q39_7, '')
      ,nullif(Q39_8, '')
      ,nullif(Q39_9, '')
      ,nullif(Q39_10, '')
      ,nullif(Q39_11, '')
      ,nullif(Q39_12, '')
    ) AS ml_model_serving_products_used
  ,concat_ws('|',
      nullif(Q40_1, '')
      ,nullif(Q40_2, '')
      ,nullif(Q40_3, '')
      ,nullif(Q40_4, '')
      ,nullif(Q40_5, '')
      ,nullif(Q40_6, '')
      ,nullif(Q40_7, '')
      ,nullif(Q40_8, '')
      ,nullif(Q40_9, '')
      ,nullif(Q40_10, '')
      ,nullif(Q40_11, '')
      ,nullif(Q40_12, '')
      ,nullif(Q40_13, '')
      ,nullif(Q40_14, '')
      ,nullif(Q40_15, '')
    ) AS ml_model_monitoring_tools_used
  ,concat_ws('|',
      nullif(Q44_1, '')
      ,nullif(Q44_2, '')
      ,nullif(Q44_3, '')
      ,nullif(Q44_4, '')
      ,nullif(Q44_5, '')
      ,nullif(Q44_6, '')
      ,nullif(Q44_7, '')
      ,nullif(Q44_8, '')
      ,nullif(Q44_9, '')
      ,nullif(Q44_10, '')
      ,nullif(Q44_11, '')
      ,nullif(Q44_12, '')
    ) AS favorite_data_science_media_sources
FROM {{ source('kaggle', 'kaggle_mlds_survey_2022') }} 
)

,condensed_kaggle as (
  select 
    age
    ,gender
    ,country
    ,student
    ,split(data_science_learning_platform, '|') as data_science_learning_platform
    ,split(helpful_platforms_learning_ds, '|') as helpful_platforms_learning_ds
    ,highest_education_level_attained_or_planned
    ,published_academic_research
    ,split(ml_usage_in_research, '|') as ml_usage_in_research
    ,years_coding_experience
    ,split(programming_languages_used, '|') as programming_languages_used
    ,split(ides_used, '|') as ides_used
    ,years_using_ml
    ,split(ml_frameworks_used, '|') as ml_frameworks_used
    ,split(ml_algos_used, '|') as ml_algos_used
    ,split(cv_methods_used, '|') as cv_methods_used
    ,split(nlp_methods_used, '|') as nlp_methods_used
    ,split(pretrained_model_sources_used, '|') as pretrained_model_sources_used
    ,ml_hub_used
    ,job_role
    ,job_industry
    ,company_size
    ,data_science_team_size
    ,yearly_comp_usd
    ,ml_cloud_spending_last_5yrs_usd
    ,split(cloud_platforms_used, '|') as cloud_platforms_used
    ,split(data_products_used, '|') as data_products_used
    ,split(bi_tools_used, '|') as bi_tools_used
    ,split(managed_ml_products_used, '|') as managed_ml_products_used
    ,split(automated_ml_tools_used, '|') as automated_ml_tools_used
    ,split(ml_model_serving_products_used, '|') as ml_model_serving_products_used
    ,split(ml_model_monitoring_tools_used, '|') as ml_model_monitoring_tools_used
    ,split(favorite_data_science_media_sources, '|') as favorite_data_science_media_sources
  from kaggle_data
  where row_num != 1 -- Exclude survey Q from data
)

select 
  *
from condensed_kaggle
order by job_role

with custom_keywords as (
  select array['ai agent'
              ,'activation function'
              ,'active learning'
              ,'anomaly detection'
              ,'artificial intelligence'
              ,'attention mechanism'
              ,'autoencoder'
              ,'automl'
              ,'azure ml studio'
              ,'bagging'
              ,'bard'
              ,'backpropagation'
              ,'batch normalization'
              ,'boosting'
              ,'chat bot'
              ,'chatbot'
              ,'cloud ai'
              ,'clustering'
              ,'convolutional neural network'
              ,'cross validation'
              ,'cross-validation'
              ,'decision tree'
              ,'deep learning'
              ,'dense neural network'
              ,'dimensionality reduction'
              ,'dropout'
              ,'edge model'
              ,'ensemble learning'
              ,'evolutionary approach'
              ,'feature extraction'
              ,'gemini flash'
              ,'gemini pro'
              ,'gen ai'
              ,'genai'
              ,'generative ai'
              ,'generative adversarial network'
              ,'gbm'
              ,'gpt'
              ,'gradient boosting'
              ,'gradient descent'
              ,'graph neural network'
              ,'hyperparameter'
              ,'kaggle data'
              ,'k nearest neighbors'
              ,'k-nearest neighbors'
              ,'knn'
              ,'language model'
              ,'linear regression'
              ,'llm'
              ,'logistic regression'
              ,'lstm'
              ,'ml algo'
              ,'ml model'
              ,'mlps'
              ,'multi model server'
              ,'neural network'
              ,'nlp'
              ,'natural language processing'
              ,'ngc models'
              ,'openai'
              ,'openvino'
              ,'overfitting'
              ,'pca'
              ,'perceptron'
              ,'trained model'
              ,'validation data'
              ,'principal component analysis'
              ,'random forest'
              ,'recurrent neural network'
              ,'regression'
              ,'regularization'
              ,'reinforcement learning'
              ,'rnn'
              ,'sagemaker'
              ,'scikit learn'
              ,'sgd'
              ,'singular value decomposition'
              ,'stochastic gradient descent'
              ,'support vector machine'
              ,'supervised learning'
              ,'svm'
              ,'tensorflow extended'
              ,'tflite'
              ,'tfx'
              ,'transfer learning'
              ,'underfitting'
              ,'unsupervised learning'
              ,'vertex ai'
              ,'word2vec'] 
              as keyword_array
  )

, ml_key as (
  select unnest(keyword_array) as ml_keywords
  from custom_keywords

  union all
  select ml_algorithms as ml_keywords
  from {{ ref('int_ml_algo_keywords') }}

  union all
  select ml_frameworks as ml_keywords
  from {{ ref('int_ml_framework_keywords') }}

  union all
  select ml_hub_used as ml_keywords
  from {{ ref('int_ml_hub_keywords') }}

  union all
  select managed_ml_products_used as ml_keywords
  from {{ ref('int_managed_ml_prod_keywords') }}

  union all
  select ml_model_serving_products_used as ml_keywords
  from {{ ref('int_ml_mdl_serving_prod_keywords') }}

  union all
  select ml_model_monitoring_tools_used as ml_keywords
  from {{ ref('int_ml_mdl_monitor_keywords') }}
)

, plural_keywords as (
  select ml_keywords 
  from ml_key
  where ml_keywords like '%s'
  and substring(ml_keywords, 1, length(ml_keywords)-1) in (select ml_keywords from ml_key)
)

select 
  distinct trim(lower(ml_keywords)) as ml_keywords
from ml_key
where 
  ml_keywords not in (select ml_keywords from plural_keywords)
  and lower(ml_keywords) not in ('na', 'other', 'none', '', 'no / none', 'nan')
  and lower(ml_keywords) is not null
order by 1 asc
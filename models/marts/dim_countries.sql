select 
uuid() as countries_pk,
* 
from {{ ref('stg__countries') }}
select 
uuid() as artists_pk,
*
from {{ ref('stg__artists') }}
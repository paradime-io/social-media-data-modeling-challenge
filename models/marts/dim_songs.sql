select 
uuid() as song_pk,
a.* 
from {{ ref('stg__songs') }} a
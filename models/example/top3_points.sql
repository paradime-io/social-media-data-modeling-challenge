SELECT *, extract (years from "Created At") AS year,
rank() over (partition by year order by Points desc) as rnk_points,
  from {{ source('main', 'hn') }} 
QUALIFY rnk_points <= 3 
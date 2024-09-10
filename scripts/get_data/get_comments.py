# %%
import gzip
import json
import os
import requests
import time

import duckdb
# %%
endpoint_items = "https://hn.algolia.com/api/v1/items/"
con = duckdb.connect("md:")
# %%
read_stories_sql = """
--begin-sql
select 
  unnest(hits,  max_depth := 2),
  nbHits::int as nb_hits,
  queried_at::timestamp as queried_at,
  query_params as query_params
from read_json('../../raw_data/stories/*.json.gz')
--end-sql
"""
df_stories = con.query(read_stories_sql).pl()
df_story_ids = df_stories.select("story_id").to_series()
# %%
write_list = []

# iterate through selected stories and query HackerNews API
for i in range(len(df_story_ids)):
    res = requests.get(f"{endpoint_items}{df_story_ids[i]}")
    write_list.extend([res.json()])
    if (i+1) % 1000 == 0:
        with gzip.open(os.path.join("../../raw_data/comments/", f"comments_{i}.json.gz"), "wt", encoding="utf-8") as f:
            json.dump(write_list, f)
        write_list = []
    time.sleep(0.5)
# %%
with gzip.open(os.path.join("../../raw_data/comments/", f"comments_{i}.json.gz"), "wt", encoding="utf-8") as f:
    json.dump(write_list, f)

# %%
import duckdb
import lxml.html
import html

# %%
data_path = "../../raw_data/"
con = duckdb.connect("md:")
# %%
con.create_function(
    "decode_html",
    lambda x: lxml.html.fromstring(x).text_content(),
    ["varchar"],
    "varchar",
)
# %%
read_stories_sql = """
select 
  unnest(hits,  max_depth := 2),
  nbHits::int as nb_hits,
  queried_at::timestamp as queried_at,
  query_params as query_params
from read_json('../../raw_data/stories/*.json.gz')
"""
dt_stories = con.query(read_stories_sql)

# %%
stories_tx_sql = """
select
  story_id::integer as id,
  created_at::timestamp as created_at,
  updated_at::timestamp as updated_at,
  author::varchar as author,
  points::integer as points,
  title::varchar as title,
  url::varchar as url,
  nullif(
    decode_html(
      coalesce(story_text, '<root></root>')
    ), ''
  ) as story_text,
  num_comments::integer as num_comments,
  children::integer[] as children,
  _tags::varchar[] as tags,
  nb_hits,
  queried_at,
  query_params
from
  dt_stories
"""
dt_stories_tx = con.sql(stories_tx_sql)
# %%
write_stories_sql = """
copy
  (select * from dt_stories_tx)
to '../../staged_data/stories.pq'
(format 'parquet')
"""
con.sql(write_stories_sql)
# %%
con.sql("create schema analytics.raw_data;")
# %%
insert_stories_sql = """
create or replace table analytics.raw_data.stories as
(
  select * from dt_stories_tx
)
"""
con.sql(insert_stories_sql)

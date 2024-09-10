# %%
import duckdb
import polars as pl

# %%
con = duckdb.connect("md:")
## %%
con.sql(
    """
        create or replace table analytics.raw_data.entity_text as (
        select
          id as hn_id,
          created_at,
          'story' as text_category,
          text_subcategory,
          md5(concat_ws('|', id, text_category,  text_subcategory)) as id,
          text_value
        from (
          unpivot analytics.raw_data.stories
          on title as story_title, story_text
          into
          name text_subcategory
          value text_value
        )
        union all
        select
          id as hn_id,
          created_at,
          'comment' as text_category,
          'comment_text' as text_subcategory,
          md5(concat_ws('|', id, text_category,  text_subcategory)) as id,
          text as text_value
        from analytics.raw_data.comments
        )
    """
)

con.sql("pragma create_fts_index(analytics.raw_data.entity_text, id, text_value);")

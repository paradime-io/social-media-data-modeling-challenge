# %%
import duckdb
import glob
import lxml.html
import polars as pl

from pathlib import Path

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
def explode_comments(df_base):
    df_list = []
    df_next = df_base
    level = 0
    while not df_next.is_empty():
        # Create a dataframe with the current top-level comments
        # If this is the top-level, store the story id (nested comments may have been moved from
        # other stories)
        if level == 0:
            df_next = (
                df_next.explode("children")
                .select(
                    pl.col("story_id").alias("parent_story_id"),
                    pl.col("children"),
                    pl.lit(level).alias("level"),
                )
                .unnest("children")
            )
        else:
            df_next = (
                df_next.explode("children")
                .select(
                    pl.col("parent_story_id"),
                    pl.col("children"),
                    pl.lit(level).alias("level"),
                )
                .unnest("children")
            )

        print(df_next.shape)

        # Append all current leaf notes
        children = df_next.filter(pl.col("children") == [])
        df_list.append(children.with_columns(pl.lit([-1]).alias("children")))
        df_next = df_next.filter(pl.col("children") != [])

        # If there's more we can expand, append the current children along with
        # an extracted list of child ids per comment
        if len(df_next) > 0:
            df_list.append(
                df_next.join(
                    df_next.explode("children")
                    .select(
                        "id", pl.col("children").struct.field("id").alias("children")
                    )
                    .group_by("id")
                    .agg("children"),
                    on=pl.col("id"),
                )
                .with_columns(pl.col("children_right").alias("children"))
                .drop("children_right")
            )
            # )
        level += 1

    df_final = pl.concat(df_list)
    # Replace [-1] list items with null
    df_final = df_final.with_columns(
        pl.when(pl.col("children").list.first() != -1).then(pl.col("children"))
    )
    return df_final


# %%
for path in glob.glob("../../raw_data/comments/*.json.gz"):
    filename = Path(path).name.replace(".json.gz", "")
    print(filename)
    read_comments_sql = f"""
    select 
      *
    from
      read_json('{path}')
    """
    df_base = con.query(read_comments_sql).pl()
    df_final = explode_comments(df_base)

    transform_sql = """
    select
      id,
      author,
      children,
      created_at::timestamp as created_at,
      created_at_i,
      parent_id,
      parent_story_id,
      story_id,
      decode_html(text) as text,
      type,
      level
    from
      df_final
    """
    df_final = con.sql(transform_sql)

    write_comments_sql = f"""
    copy
    (select * from df_final)
    to '../../staged_data/comments/{filename}.pq'
    (format 'parquet')
    """
    con.sql(write_comments_sql)
# %%
insert_comments_sql = """
create or replace table analytics.raw_data.comments as
(
  select * from read_parquet('../../staged_data/comments/*.pq')
)
"""
con.sql(insert_comments_sql)

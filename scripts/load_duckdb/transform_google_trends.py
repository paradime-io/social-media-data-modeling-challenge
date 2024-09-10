# %%
import os
import duckdb
import polars as pl

# %%
data_path = "../../raw_data/google_trends/"
subdirectories = next(os.walk("../../raw_data/google_trends/"))[1]
con = duckdb.connect("md:")

# %%
df_dict = {directory: [] for directory in subdirectories}
for directory in subdirectories:
    directory_path = os.path.join(data_path, directory)
    for subdir, dirs, files in os.walk(directory_path):
        for file_name in files:
            file_attrs_list = os.path.splitext(file_name)[0].split("_")
            if directory == "general":
                names = [
                    "country",
                    "general_category",
                    "search_type",
                    "related_trend_type",
                ]
            else:
                names = [
                    "country",
                    "trend_name",
                    "trend_type",
                    "search_type",
                    "related_trend_type",
                ]
            file_attrs_map = dict(zip(names, file_attrs_list))
            file_path = os.path.join(directory_path, file_name)
            df = (
                pl.read_csv(
                    file_path,
                    columns=[0, 1],
                    has_header=False,
                    schema={"related_trend_name": pl.String, "value": pl.String},
                )
                .with_row_index(name="row_num")
                # filter out "top" data since we're interested in trends
                .with_columns(
                    pl.when(
                        (pl.col("related_trend_name") == "RISING")
                        & (pl.col("value").is_null())
                    )
                    .then(pl.col("row_num"))
                    .alias("csv_start")
                )
                .filter(
                    (pl.min("csv_start") < pl.col("row_num"))
                    & (
                        pl.col("related_trend_name").is_not_null()
                        & pl.col("value").is_not_null()
                    )
                )
                .select(
                    pl.col("related_trend_name"),
                    pl.col("value"),
                    pl.when(pl.col("value") != "Breakout")
                    .then(pl.col("value").str.replace_all("\+|\,|\%", ""))
                    .otherwise(2**63 - 1)
                    .cast(pl.Int64)
                    .alias("value_pct_growth"),
                )
            )
            df_tx = pl.concat(
                [
                    df,
                    pl.DataFrame(file_attrs_map).select(
                        pl.all().repeat_by(len(df)).explode()
                    ),
                ],
                how="horizontal",
            ).with_row_index()
            df_dict[directory].append(df_tx)
# %%
df_related_trends = []
for key in df_dict:
    # fix search_type to be more selective
    df_dict[key] = pl.concat(df_dict[key]).with_columns(
        pl.when(pl.col("search_type") == "search")
        .then(pl.lit("web-search"))
        .otherwise(pl.lit("news-search"))
        .alias("search_type")
    )
    if key != "general":
        df_related_trends.append(df_dict[key])
# %%
df_dict["general"].write_csv("../../staged_data/google_trends/gt_overall_trends.csv")

# %%
df_related_trends = pl.concat(df_related_trends)
df_related_trends.write_csv("../../staged_data/google_trends/gt_related_trends.csv")
# %%
insert_general_trends = """
create or replace table analytics.raw_data.gt_overall_trends as
  select * from read_csv('../../staged_data/google_trends/gt_overall_trends.csv')
"""
con.sql(insert_general_trends)

# %%
insert_related_trends = """
create or replace table analytics.raw_data.gt_related_trends as
  select * from read_csv('../../staged_data/google_trends/gt_related_trends.csv')
"""
con.sql(insert_related_trends)
# %%

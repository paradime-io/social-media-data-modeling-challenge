# %%
import gzip
import json
import logging
import requests
import os

from datetime import datetime, timedelta, UTC


# %%
def get_posix_time(dt):
    return round((dt - datetime(1970, 1, 1)) / timedelta(seconds=1))


# %%
endpoint_search = "http://hn.algolia.com/api/v1/search_by_date?"

hits_per_page_stories = 1000

story_params = {"tags": "story", "hitsPerPage": hits_per_page_stories}

start_date = datetime.strptime("2024-07-12", "%Y-%m-%d")
end_date = start_date + timedelta(days=14)
# %%
for i in range(0, (end_date - start_date).days * 2 * 12, 12):
    query_start = start_date + timedelta(hours=i)
    query_end = query_start + timedelta(hours=12)

    story_params["numericFilters"] = (
        f"created_at_i>={get_posix_time(query_start)},created_at_i<{get_posix_time(query_end)}"
    )
    file_name = f"stories_{get_posix_time(query_start)}.json.gz"

    if os.path.exists(os.path.join("../../raw_data/stories/", file_name)):
        print("skipping", query_start)
        continue
    print(query_start)
    req_start = datetime.now(UTC)
    res = requests.get(endpoint_search, story_params)
    if res.json()["nbHits"] > 1000:
        logging.warning(
            f"Query starting at {query_start} returned more than 1000 results"
        )
        break

    res_dict = res.json()
    res_dict["queried_at"] = (req_start + res.elapsed).isoformat()
    res_dict["query_params"] = story_params
    with gzip.open(
        os.path.join("../../raw_data/stories/", file_name), "wt", encoding="utf-8"
    ) as f:
        json.dump(res_dict, f)

# %%
# Get comments per day
comments_params = {
    "tags": "comment",
    "hitsPerPage": 10,
}

res_dict = {}
ct = 0
for i in range(0, (end_date - start_date).days):
    query_start = start_date + timedelta(days=i)
    query_end = query_start + timedelta(days=1)

    comments_params["numericFilters"] = (
        f"created_at_i>={get_posix_time(query_start)},created_at_i<{get_posix_time(query_end)}"
    )

    res = requests.get(endpoint_search, comments_params)
    res_dict[i] = {
        "query_start": query_start.isoformat(),
        # "end_date": end_date.isoformat(),
        "num_comments": res.json()["nbHits"],
    }
    ct = ct + res.json()["nbHits"]

with gzip.open(
    os.path.join("../../raw_data/aggregates/", "comments_agg.json.gz"),
    "wt",
    encoding="utf-8",
) as f:
    json.dump(res_dict, f)
# %%

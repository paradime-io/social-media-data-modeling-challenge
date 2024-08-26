from app_store_scraper import AppStore
import pandas as pd
import numpy as np
import json, os, uuid

# download nba app reviews
nba_reviews = AppStore('us', 'nba-live-games-scores', '484672289')
nba_reviews.review()

nb_df = pd.DataFrame(np.array(nba_reviews.reviews),columns=['review'])
nba_df2 = nba_df.join(pd.DataFrame(nba_df.pop('review').tolist()))

# download nhl app reviews

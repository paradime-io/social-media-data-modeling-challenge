# first we need to install the google play scraper package with pip install google-play-scraper

from google_play_scraper import app, Sort, reviews_all
import pandas as pd
import numpy as np
import json, os, uuid

g_names = ['com.bamnetworks.mobile.android.gameday.atbat', 'com.nhl.gc1112.free', 'com.nbaimd.gametime.nba2011', 'com.gotv.nflgamecenter.us.lite']
a_names = ['nfl']
a_ids = ['389781154']

# download mlb app reviews
mlb_reviews = reviews_all(
        'com.bamnetworks.mobile.android.gameday.atbat',
        sleep_milliseconds=0, # defaults to 0
        lang='en', # defaults to 'en'
        country='us', # defaults to 'us'
        sort=Sort.NEWEST, # defaults to Sort.MOST_RELEVANT
    )

mlb_df = pd.DataFrame(np.array(mlb_reviews),columns=['review'])
mlb_df2 = mlb_df.join(pd.DataFrame(mlb_df.pop('review').tolist()))

# download nhl app reviews
nhl_reviews = reviews_all(
        'com.nhl.gc1112.free',
        sleep_milliseconds=0, # defaults to 0
        lang='en', # defaults to 'en'
        country='us', # defaults to 'us'
        sort=Sort.NEWEST, # defaults to Sort.MOST_RELEVANT
    )

nhl_df = pd.DataFrame(np.array(nhl_reviews),columns=['review'])
nhl_df2 = nhl_df.join(pd.DataFrame(nhl_df.pop('review').tolist()))

# download nba app reviews
nba_reviews = reviews_all(
        'com.nbaimd.gametime.nba2011',
        sleep_milliseconds=0, # defaults to 0
        lang='en', # defaults to 'en'
        country='us', # defaults to 'us'
        sort=Sort.NEWEST, # defaults to Sort.MOST_RELEVANT
    )

nba_df = pd.DataFrame(np.array(nba_reviews),columns=['review'])
nba_df2 = nba_df.join(pd.DataFrame(nba_df.pop('review').tolist()))

# nfl app reviews
nfl_reviews = reviews_all(
        'com.gotv.nflgamecenter.us.lite',
        sleep_milliseconds=0, # defaults to 0
        lang='en', # defaults to 'en'
        country='us', # defaults to 'us'
        sort=Sort.NEWEST, # defaults to Sort.MOST_RELEVANT
    )

nfl_df = pd.DataFrame(np.array(nfl_reviews),columns=['review'])
nfl_df2 = nba_df.join(pd.DataFrame(nfl_df.pop('review').tolist()))
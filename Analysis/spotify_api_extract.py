import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from spotipy.cache_handler import CacheFileHandler
import pandas as pd
import os
import logging


# Custom cache handler that does nothing hence disabling caching
class NoCacheHandler(CacheFileHandler):
    def get_cached_token(self):
        return None

    def save_token_to_cache(self, token_info):
        pass

cache_handler = NoCacheHandler()

# Spotify API credentials
client_id = 'xxx'  
client_secret = 'xxx' 

#API client
try:
    auth_manager = SpotifyClientCredentials(
        client_id=client_id,
        client_secret=client_secret,
        cache_handler=cache_handler
    )
    sp = spotipy.Spotify(auth_manager=auth_manager)
    logging.info("Successfully initialized Spotify client")
except Exception as e:
    logging.error(f"Failed to initialize Spotify client: {e}")
    raise

#Only including track_id's that exists in the original dataset 
file_path = 'paradimeExport.csv' 
try:
    df = pd.read_csv(file_path)
    track_ids = df['spotify_track_id'].tolist()
    logging.info(f"Loaded {len(track_ids)} track IDs from CSV")
except Exception as e:
    logging.error(f"Failed to load CSV file: {e}")
    raise

def get_track_data(track_id):
    try:
        track_data = sp.track(track_id)
        track_features = sp.audio_features(track_id)[0]

        artists = ', '.join([artist['name'] for artist in track_data['artists']])
        artist_ids = ', '.join([artist['id'] for artist in track_data['artists']])

        data = {
            'track_id': track_data['id'],
            'track_name': track_data['name'],
            'popularity': track_data['popularity'],
            'duration_seconds': track_data['duration_ms'] / 1000,
            'artists': artists.replace("'", ""),
            'id_artists': artist_ids.replace("'", ""),
            'release_date': track_data['album']['release_date'],
            'danceability': track_features['danceability'],
            'energy': track_features['energy'],
            'loudness': track_features['loudness'],
            'speechiness': track_features['speechiness'],
            'acousticness': track_features['acousticness'],
            'instrumentalness': track_features['instrumentalness'],
            'liveness': track_features['liveness'],
            'positiveness': track_features['valence'],
            'tempo': track_features['tempo'],
            'beats_per_bar': track_features['time_signature']
        }
        return data
    except spotipy.exceptions.SpotifyException as e:
        # Rate limit handling
        if e.http_status == 429:  
            retry_after = int(e.headers.get('Retry-After', 1))  
            logging.warning(f"Rate limit hit. Retrying after {retry_after} seconds...")
            time.sleep(retry_after)  
            return get_track_data(track_id)  
        else:
            logging.error(f"Error fetching data for track {track_id}: {e}")
            return None

tracks_data = []
for track_id in track_ids:
    data = get_track_data(track_id)
    if data:
        tracks_data.append(data)
    else:
        logging.warning(f"Skipped track ID: {track_id}")

logging.info(f"Successfully fetched data for {len(tracks_data)} tracks")

df_tracks = pd.DataFrame(tracks_data)

print(df_tracks)

# df -> csv
output_file = 'spotify_tracks_data.csv'
df_tracks.to_csv(output_file, index=False)
logging.info(f"Saved data to {output_file}")

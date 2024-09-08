# Fetching video details from YouTube

# Importing required libraries (install first if not installed already)
import requests  # For making HTTP requests
import pandas as pd  # For data manipulation and analysis
import json  # For handling JSON data
import duckdb # For inserting data in motherduck warehouse

# Connect to MotherDuck
con = duckdb.connect('md:analytics?motherduck_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhldHZpcGFyZWtoQGJpdGdvLmNvbSIsInNlc3Npb24iOiJoZXR2aXBhcmVraC5iaXRnby5jb20iLCJwYXQiOiJpN01mTk4wNGt6clFKaEoxMXd5UW1Wa2lnakhtLXdnWmxJYzdRYjRraElJIiwidXNlcklkIjoiZTI1ZmUyN2QtZDU5ZS00YzkwLTlmNjQtZWIyOTJlYWM0YjRkIiwiaXNzIjoibWRfcGF0IiwiaWF0IjoxNzIyNzM5MDIxfQ.IveaSQdeSlIKSNFmskPUetgwUbn6TonMM__ogQuXu9o')
query = "select distinct video_id from source.trending_yt_videos"

# Execute the query to get the result set
video_id_list = con.execute(query).fetchdf()

def get_videos_details(api_key, video_ids):
    
    # YouTube API URL
    url = "https://www.googleapis.com/youtube/v3/videos"
    video_data = []
    
    # Split video_ids into chunks of 50 to comply with API limits
    for i in range(0, len(video_ids), 50):
        print(f"Current batch : {i}")
        chunk = video_ids[i:i + 50]  # Create a chunk of up to 50 video IDs
        video_ids_str = ",".join(chunk)  # Convert list of video IDs to a comma-separated string
        
        # Parameters for the API request
        params = {
            'part': 'snippet,contentDetails,statistics,status,player',  # Specify which parts of the video details to retrieve
            'id': video_ids_str,  # List of video IDs to fetch details for
            'key': api_key  # API key for authorization
        }
        
        # Making the API request
        response = requests.get(url, params=params)
        
        if response.status_code == 200:
            data = response.json()  # Parse response JSON
            for item in data['items']:
                # Append video details to the list
                video_data.append([item['id'], item['snippet']['categoryId'], item['contentDetails']])
        else:
            # Print error message if API request fails
            print(f"Failed to fetch video details for chunk starting with {chunk[0]}. Status code: {response.status_code}")

    return video_data  

# Call the get_videos_details function

api_key = "AIzaSyDBq-tIT9SVl0d6sYCWq3f4aLMGqi7xhAk"  # Replace with your actual API key
video_ids = video_id_list['video_id'].tolist()  # Load and extract unique video IDs

# Print total number of video IDs to be processed
print(f"Total Video IDs : {len(video_ids)}")  

# Fetch video data
video_data = get_videos_details(api_key, video_ids)

# Create a DataFrame from the video data
df_result = pd.DataFrame(video_data, columns=['video_id', 'category_id', 'content_details'])

# Function to extract 'duration' and 'caption' from JSON-like string
def extract_duration_and_caption(json_like_str):
    try:
        # Evaluate the string as a Python dictionary
        json_dict = eval(json_like_str)
        
        # Extract the 'duration' and 'caption' fields
        duration = json_dict.get('duration', None)
        caption = json_dict.get('caption', None)
        return pd.Series([duration, caption])
    
    except Exception as e:
        # Print error message if evaluation fails
        print(f"Error processing: {json_like_str}, error: {e}")
        return pd.Series([None, None])

# Apply the function to the entire column to extract 'duration' and 'caption' fields
df_result[['duration', 'caption']] = df_result['content_details'].apply(extract_duration_and_caption)

# Clean 'duration' column by removing 'P' and 'T' characters
df_result['duration'] = df_result['duration'].str.replace('P', '')
df_result['duration'] = df_result['duration'].str.replace('T', '')

# Create a table (if it doesn't exist)
con.execute("""
CREATE TABLE IF NOT EXISTS supporting_data.video_details (
    video_id varchar,
    category_id integer,
    content_details varchar,
    duration varchar,
    caption boolean
)
""")

# Insert data from DataFrame into the table
con.execute("INSERT INTO supporting_data.video_details SELECT * FROM df_result")

# Close the connection
con.close()
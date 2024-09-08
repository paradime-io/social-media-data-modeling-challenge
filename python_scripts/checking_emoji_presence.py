import pandas as pd  # For data manipulation
import emoji  # For emoji detection
import duckdb # For inserting data in motherduck warehouse

# Connect to MotherDuck
con = duckdb.connect('md:analytics?motherduck_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhldHZpcGFyZWtoQGJpdGdvLmNvbSIsInNlc3Npb24iOiJoZXR2aXBhcmVraC5iaXRnby5jb20iLCJwYXQiOiJpN01mTk4wNGt6clFKaEoxMXd5UW1Wa2lnakhtLXdnWmxJYzdRYjRraElJIiwidXNlcklkIjoiZTI1ZmUyN2QtZDU5ZS00YzkwLTlmNjQtZWIyOTJlYWM0YjRkIiwiaXNzIjoibWRfcGF0IiwiaWF0IjoxNzIyNzM5MDIxfQ.IveaSQdeSlIKSNFmskPUetgwUbn6TonMM__ogQuXu9o')
query = "select distinct video_id, title, description from source.trending_yt_videos_113_countries"

# Execute the query to get the result set
df = con.execute(query).fetchdf()

# Function to check if text contains any emoji
def contains_emoji(text):
    if pd.notna(text) and isinstance(text, str):  # Check if text is not NaN and is a string
        return any(char in emoji.EMOJI_DATA for char in text)
    return None  # Return None if text is NaN or not a string

# Function to remove emojis from text using list comprehension
def remove_emojis(text):
    if pd.notna(text) and isinstance(text, str):  # Check if text is not NaN and is a string
        return ''.join(char for char in text if not emoji.is_emoji(char))
    return text  # Return the original text if it's NaN or not a string

# Apply emoji detection to 'title' and 'description' columns
df['title_emoji_flag'] = df['title'].apply(contains_emoji)
df['description_emoji_flag'] = df['description'].apply(contains_emoji)

# Apply emoji removal to 'title' and 'description' columns
df['title_excluding_emoji'] = df['title'].apply(remove_emojis)
df['description_excluding_emoji'] = df['description'].apply(remove_emojis)

# Create a table (if it doesn't exist)
con.execute("""
CREATE TABLE IF NOT EXISTS supporting_data.title_description_emoji_presence (
    video_id varchar,
    title varchar,
    description varchar,
    title_emoji_flag boolean,
    description_emoji_flag boolean,
    title_excluding_emoji varchar,
    description_excluding_emoji varchar
)
""")

# Insert data from DataFrame into the table
con.execute("INSERT INTO supporting_data.title_description_emoji_presence SELECT * FROM df")

# Close the connection
con.close()
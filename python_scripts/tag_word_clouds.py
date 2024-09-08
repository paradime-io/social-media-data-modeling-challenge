import pandas as pd  # For data manipulation and handling
import duckdb  # For querying the data from the DuckDB/MotherDuck database
from wordcloud import WordCloud  # To generate word clouds
import matplotlib.pyplot as plt  # For plotting the word clouds
import nltk  # Natural Language Toolkit, used for text processing (e.g., stopwords and words corpus)
from nltk.corpus import stopwords, words  # For filtering out stopwords and validating English words
from collections import Counter  # To count the frequency of words in a text


# Connect to MotherDuck
con = duckdb.connect('md:analytics?motherduck_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhldHZpcGFyZWtoQGJpdGdvLmNvbSIsInNlc3Npb24iOiJoZXR2aXBhcmVraC5iaXRnby5jb20iLCJwYXQiOiJpN01mTk4wNGt6clFKaEoxMXd5UW1Wa2lnakhtLXdnWmxJYzdRYjRraElJIiwidXNlcklkIjoiZTI1ZmUyN2QtZDU5ZS00YzkwLTlmNjQtZWIyOTJlYWM0YjRkIiwiaXNzIjoibWRfcGF0IiwiaWF0IjoxNzIyNzM5MDIxfQ.IveaSQdeSlIKSNFmskPUetgwUbn6TonMM__ogQuXu9o')
query = """
with split_data as (
select video_id, category_name, string_split(video_tags, ', ') as tag
from analytics.dbt_hetviparekh.yt_trending_videos_deduped
where video_tags is not null
and category_name is not null)

select video_id, category_name, unnest(tag) AS tag
from split_data
"""

# # Execute the query to get the result set
df = con.execute(query).fetchdf()

# Download stopwords and words corpus from nltk
nltk.download('stopwords')
nltk.download('words')

# Set of stopwords in English and valid English words
stop_words = set(stopwords.words('english'))
english_words = set(words.words())

# Function to filter out non-English words, standardize text, and remove short words
def filter_non_english(text):
    # Convert to lowercase, split by words, filter out non-English and short words (less than 3 characters)
    filtered_words = [word.lower() for word in text.split() if word.lower() in english_words and len(word) > 2]
    
    # Count the frequency of each word
    word_counts = Counter(filtered_words)
    
    # Return the string with each word appearing the correct number of times
    return ' '.join([word for word, count in word_counts.items()])

# Function to generate and display word cloud by category, excluding stopwords and non-English words
def generate_word_cloud_by_category(df, category_col, tags_col):
    categories = df[category_col].unique() # 'Entertainment', 'People & Blogs', 'Sports', 'Music', 'Gaming', 'News & Politics'

    for category in categories:
        # Filter tags by category
        category_tags = df[df[category_col] == category][tags_col].str.cat(sep=' ')
        
        # Filter out non-English words, standardize the text (convert to lowercase), and remove short words
        category_tags = filter_non_english(category_tags)
        
        # Generate word cloud for top 250 words, excluding stopwords
        wordcloud = WordCloud(width=800, height=400, background_color='white', max_words=250, stopwords=stop_words).generate(category_tags)
        
        # Plot the word cloud
        plt.figure(figsize=(10, 5))
        plt.imshow(wordcloud, interpolation='bilinear')
        plt.axis('off')     
        plt.title(f'{category} Category', fontsize=16, pad = 20)
        plt.show()
        plt.close()  # Close the figure after displaying to prevent overlapping

# Assuming df is your DataFrame with 'category_name' and 'tag' columns
generate_word_cloud_by_category(df, 'category_name', 'tag')
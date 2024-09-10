"""
Note! This script is not runnable; only for demo purposes.
Code was run in Hex to generate model results
"""
import pandas as pd
import nltk
import re
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk.corpus import stopwords
import string
from nltk.tokenize import word_tokenize


nltk.download('vader_lexicon')
nltk.download('stopwords')
nltk.download('punkt')

def clean_tokenize(texts):
  stop_words = set(stopwords.words('english'))
  processed_texts = []

  for text in texts:
    tokens = word_tokenize(text.lower())  
    # Remove non-alpha characters, stopwords, and punctuation
    tokens = [word for word in tokens if word.isalpha() and word not in stop_words and word not in string.punctuation]
    cleaned_text = ' '.join(tokens)
    if cleaned_text:  # Ensure non emtpy
      processed_texts.append(cleaned_text)
  return processed_texts

def get_sentiment(text):
    vader = SentimentIntensityAnalyzer()
    return vader.polarity_scores(text)


def run(docs):
  clean_docs = clean_tokenize(docs)
  df = pd.DataFrame({'clean_text': clean_docs})
  df['sentiment'] = df['clean_text'].apply(get_sentiment)
  sentiment_scores = pd.json_normalize(df['sentiment'])
  print("done.")
  return sentiment_scores

def get_docs(df_story):
    df = df_story.copy() # Don't change original data
    df['post_content'] = df['title'].fillna('') + '. ' + df['text'].fillna('')
    docs = df['post_content'].unique()
    return [x for x in docs]
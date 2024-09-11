"""
Note! This script is not runnable; only for demo purposes.
Code was run in Hex to generate model results
"""
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk.stem import WordNetLemmatizer
from nltk import pos_tag
from sklearn.decomposition import NMF
from sklearn.feature_extraction.text import ENGLISH_STOP_WORDS
import nltk
import seaborn as sns
import matplotlib.pyplot as plt

nltk.download('stopwords')
nltk.download('wordnet')
nltk.download('punkt')
nltk.download('wordnet')
nltk.download('omw-1.4')
nltk.download('averaged_perceptron_tagger')


def get_top_words_per_topic(nmf_model, feature_names, num_top_words):
  topics_data = []
  for topic_idx, topic in enumerate(nmf_model.components_):
    top_word_indices = topic.argsort()[:-num_top_words - 1:-1]
    
    # get words & weights
    top_words = [feature_names[i] for i in top_word_indices]
    top_weights = topic[top_word_indices]

    for word, weight in zip(top_words, top_weights):
      topics_data.append([f"Topic {str(topic_idx + 1).zfill(2)}", word, weight])

  topics_df = pd.DataFrame(topics_data, columns=["Topic", "Word", "Weight"])
  
  return topics_df


def run_nmf(documents):
    # add domain specific stop words
    # eg show hn; ask hn
    domain_stop_words = ['x2f', 'hn', 'like', 'ask', 'quot', 'http', 'www', 'ha', 'wa', 'show', 'nofollow']
    combined_stop_words = list(ENGLISH_STOP_WORDS.union(domain_stop_words))

    lemmatizer = WordNetLemmatizer()

    def lemmatize(doc):
        words = nltk.word_tokenize(doc.lower())  
        # lemmatize only alphawords
        return ' '.join([lemmatizer.lemmatize(word) for word in words if word.isalpha()])  

    lemmatized_documents = [lemmatize(doc) for doc in documents]

    """
    max_df: Remove terms appearing >95% of docs
    min_df: Remove terms appearing <1% of docs
    """
    tfidf_vectorizer = TfidfVectorizer(max_df=0.95
                                    ,min_df=0.01
                                    ,stop_words=combined_stop_words)

    tfidf_matrix = tfidf_vectorizer.fit_transform(lemmatized_documents)

    tfidf_feature_names = tfidf_vectorizer.get_feature_names_out()

    """ NMF for topic modeling """
    num_topics = 10

    nmf_model = NMF(n_components=num_topics
                ,random_state=54
                ,max_iter=1000 # default 200
                ,l1_ratio=0.5
                #,init='nndsvd'
                )

    # fit & get topic distribution
    nmf_model.fit(tfidf_matrix)

    topic_term_matrix = nmf_model.components_ # H weights
    document_topic_matrix = nmf_model.transform(tfidf_matrix) # W weights

    def display_topics(model, feature_names, num_top_words):
        for topic_idx, topic in enumerate(model.components_):
            print(f"Topic {str(topic_idx + 1).zfill(2)}:")
            print(" | ".join([feature_names[i] for i in topic.argsort()[:-num_top_words - 1:-1]]))
            print()

    num_top_words = num_topics
    display_topics(nmf_model, tfidf_feature_names, num_top_words)
    
    
    return document_topic_matrix, get_top_words_per_topic(nmf_model, tfidf_feature_names, num_top_words)


def get_docs(df_story):
    df = df_story.copy() # Don't change original data
    df['post_content'] = df['title'].fillna('') + '. ' + df['text'].fillna('')
    docs = df['post_content'].unique()
    return [x for x in docs]


heatmap_data = topics_df.pivot(index='Word', columns='Topic', values='Weight')
plt.figure(figsize=(12, 20))
sns.heatmap(heatmap_data, cmap="YlGnBu", annot=True, fmt=".2f", linewidths=.5)
plt.title("Heatmap of Top Words Per Topic")
plt.xlabel("Topic")
plt.ylabel("Word")
plt.xticks(rotation=45)
plt.show()
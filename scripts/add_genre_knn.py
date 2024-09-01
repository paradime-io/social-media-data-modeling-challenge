import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
import duckdb

# Connecting to MotherDuck using DuckDB with a provided token and user agent
con = duckdb.connect("md:analytics", config={
        'motherduck_token': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpheWVzb24uZ2FvQGluc3RhY2FydC5jb20iLCJzZXNzaW9uIjoiamF5ZXNvbi5nYW8uaW5zdGFjYXJ0LmNvbSIsInBhdCI6IjdsWmVhSzBjODFnTjhKMFpMUVZIVlgzRldhTEN3aTNXcFEtQzJndXk5ZHMiLCJ1c2VySWQiOiIyZGVjNjc4Ny03NGJjLTQ5NzYtOWRiMC1mZGQyZGNkZTA5ZWYiLCJpc3MiOiJtZF9wYXQiLCJpYXQiOjE3MjQ5NjA2Nzl9.mthnVGQ49v0YhUfuN0SQ4Qr19LXyGft9VMovW62C234",
        'custom_user_agent': "Paradime_DBT"
});

def fetch_data(query, connection):
    return connection.execute(query).df()

# Fetching data from the specified datasets
df_train = fetch_data("SELECT * FROM dbt_jayeson_gao.stg_spotify_30k_songs", con)
df_test = fetch_data("SELECT * FROM dbt_jayeson_gao.stg_tiktok_songs_spotify", con)

# Preparing the data by excluding non-feature columns
X = df_train.drop(['track_name', 'track_artist', 'genre', 'subgenre'], axis=1)
y = df_train['genre']

# Splitting the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Setting up and training the K-Nearest Neighbors Classifier
# The number of neighbors can be tuned. Starting with 5 as a common default
model = KNeighborsClassifier(n_neighbors=30)
model.fit(X_train, y_train)

# Evaluating the model's accuracy
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

# Print model accuracy
# print("Accuracy of the model: {:.2f}%".format(accuracy * 100))

comparison_df = pd.DataFrame({'Actual': y_test, 'Predicted': y_pred})
print(comparison_df.head(10))

# Applying the model to the second dataset
X_final = df_test.drop(['track_name', 'track_artist', 'genre', 'subgenre'], axis=1, errors='ignore')
df_test['predicted_subgenre'] = model.predict(X_final)
import duckdb
import pandas as pd
import json
import ast
# Function to safely parse JSON strings
def safe_json_loads(s):
    try:
        # Replace single quotes with double quotes and parse
        return json.loads(s.replace("'", "\""))
    except json.JSONDecodeError:
        # Fallback to using ast.literal_eval if json.loads fails
        return ast.literal_eval(s)


row_count = 0
csv_file_path = './instagram_data_vargr.csv'

con = duckdb.connect('md:raw', config={ 'motherduck_token': 'token'})
for chunk in pd.read_csv(csv_file_path, chunksize=50000):
    row_count += len(chunk)

    # Normalize the JSON-like strings in the 'train' column
    normalized_chunk = chunk['train'].apply(safe_json_loads).apply(pd.json_normalize)
    
    schema_name = 'raw'
    table_name = 'instagram_data'

    df = pd.concat(normalized_chunk.values, ignore_index=True)

    # Load DataFrame into DuckDB
    con.execute(f"INSERT INTO {schema_name}.{table_name} SELECT * FROM df")

    print(row_count)
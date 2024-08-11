from datasets import load_dataset
import pandas as pd

#df = dd.read_parquet("hf://datasets/vargr/private_instagram/data/train-*-of-*.parquet")
# Load the dataset from Hugging Face
#dataset = load_dataset("joshuakelleych/text_detections_easyocr_yolov10")
ds = load_dataset("vargr/private_instagram")

# Convert the dataset to a pandas DataFrame
df = pd.DataFrame(ds)
print(df.head())

# Define the CSV file path
csv_file_path = './instagram_data_vargr.csv'

# Save the DataFrame to a CSV file
df.to_csv(csv_file_path, index=False)
import easyocr  # For optical character recognition
import cv2  # For image processing
import requests  # For HTTP requests
from io import BytesIO  # For handling binary data
from PIL import Image  # For image manipulation
import numpy as np  # For array operations
import pandas as pd  # For data manipulation
from tqdm import tqdm  # For progress bar
from concurrent.futures import ThreadPoolExecutor  # For parallel processing
from requests.adapters import HTTPAdapter  # For HTTP request adapters
from requests.packages.urllib3.util.retry import Retry  # For request retries
import duckdb # For inserting data in motherduck warehouse

# Connect to MotherDuck
con = duckdb.connect('md:analytics?motherduck_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhldHZpcGFyZWtoQGJpdGdvLmNvbSIsInNlc3Npb24iOiJoZXR2aXBhcmVraC5iaXRnby5jb20iLCJwYXQiOiJpN01mTk4wNGt6clFKaEoxMXd5UW1Wa2lnakhtLXdnWmxJYzdRYjRraElJIiwidXNlcklkIjoiZTI1ZmUyN2QtZDU5ZS00YzkwLTlmNjQtZWIyOTJlYWM0YjRkIiwiaXNzIjoibWRfcGF0IiwiaWF0IjoxNzIyNzM5MDIxfQ.IveaSQdeSlIKSNFmskPUetgwUbn6TonMM__ogQuXu9o')
query = "select distinct thumbnail_url from source.trending_yt_videos_113_countries where thumbnail_url is not null"

# Execute the query to get the result set
df = con.execute(query).fetchdf()

# -------------------------- Checking the presence of text in a thumbnail URL ------------------------------ #

# Initialize EasyOCR reader
languages = ['en']
reader = easyocr.Reader(languages)

def detect_text(image_url):
    try:
        # Download the image
        response = requests.get(image_url)
        img = Image.open(BytesIO(response.content))

        # Convert image to RGB (easyocr works with RGB images)
        img_rgb = img.convert("RGB")
        
        # Perform OCR to detect text
        result = reader.readtext(np.array(img_rgb))
        
        # Return True if text is detected, False otherwise
        return len(result) > 0
    except Exception as e:
        print(f"Error processing image: {e}")
        return 'NA'
    
def process_thumbnails(urls):
    with ThreadPoolExecutor(max_workers = 16) as executor:  # Adjust max_workers based on your CPU cores
        results = list(tqdm(executor.map(detect_text, urls), total=len(urls), desc="Processing Thumbnails"))
    return results    

# Apply the detect_text function to the entire column with a progress bar
df['text_present_flag'] = process_thumbnails(df['thumbnail_url'])


# -------------------------- Checking the presence of faces in a thumbnail URL ------------------------------ #

# Load the pre-trained models for face detection
modelFile = "./inputs/pre_trained_models/res10_300x300_ssd_iter_140000.caffemodel"
configFile = "./inputs/pre_trained_models/deploy.prototxt"
net = cv2.dnn.readNetFromCaffe(configFile, modelFile)

# Set up a requests session with retries
session = requests.Session()
retry = Retry(connect=5, backoff_factor=0.5)
adapter = HTTPAdapter(max_retries=retry)
session.mount('https://', adapter)

def is_face_present(image_url):
    try:
        # Fetch the image from the URL with retries
        response = session.get(image_url, timeout=10)
        response.raise_for_status()  # Raise an error for bad status codes

        img_array = np.asarray(bytearray(response.content), dtype=np.uint8)

        # Decode the image using OpenCV
        img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)

        if img is None:
            return 'NA'

        # Ensure the image is in the correct format (3 channels)
        if len(img.shape) != 3 or img.shape[2] != 3:
            return 'NA'

        # Resize image to the required input size for the model
        img = cv2.resize(img, (300, 300))

        # Prepare the image for detection
        blob = cv2.dnn.blobFromImage(img, 1.0, (300, 300), (104.0, 177.0, 123.0))

        # Perform face detection
        net.setInput(blob)
        detections = net.forward()

        # Check if any faces are detected
        for i in range(detections.shape[2]):
            confidence = detections[0, 0, i, 2]

            if confidence > 0.5:  # Confidence threshold
                return True

        return False

    except requests.exceptions.RequestException as e:
        print(f"Error processing image: {e}")
        return 'NA'

def process_thumbnails(df):
    # Use ThreadPoolExecutor for parallel processing
    with ThreadPoolExecutor() as executor:
        # Wrap the map with tqdm to add a progress bar
        df['face_present_flag'] = list(tqdm(executor.map(is_face_present, df['thumbnail_url']), total=len(df), desc="Processing Thumbnails"))

# Process the thumbnails and add the face_present column with a progress bar
process_thumbnails(df)

# Convert output columns to string
columns_to_convert = ['text_present_flag', 'face_present_flag']
df[columns_to_convert] = df[columns_to_convert].astype(str)

# Create a table (if it doesn't exist)
con.execute("""
CREATE TABLE IF NOT EXISTS supporting_data.thumbnail_analysis (
    thumbnail_url varchar,
    text_present_flag integer,
    face_present_flag varchar
)
""")

# Insert data from DataFrame into the table
con.execute("INSERT INTO supporting_data.thumbnail_analysis SELECT * FROM df_result")

# Close the connection
con.close()
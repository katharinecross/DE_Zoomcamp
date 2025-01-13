import os
import argparse
import requests
import gzip
import shutil 

from time import time

import pandas as pd
from sqlalchemy import create_engine

def main(params):
    # Parameters
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    # Step 1: Download the file
    file_name = url.split('/')[-1]  # Extract the file name from the URL
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()  # Raise an error for HTTP errors
        with open(file_name, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"Downloaded file: {file_name}")
    except Exception as e:
        print(f"Error downloading file: {e}")
        return

    # Step 2: Extract the file if it is gzipped
    if file_name.endswith('.csv.gz'):
        csv_file_name = file_name.replace('.gz', '')  # Remove .gz extension
        try:
            with gzip.open(file_name, 'rb') as gz_file:
                with open(csv_file_name, 'wb') as csv_file:
                    shutil.copyfileobj(gz_file, csv_file)
            print(f"Extracted file: {csv_file_name}")
        except Exception as e:
            print(f"Error extracting file: {e}")
            return
    else:
        csv_file_name = file_name

    # Step 3: Process the CSV file
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    df_iter = pd.read_csv(csv_file_name, iterator=True, chunksize=100000)

    df = next(df_iter)
    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    df.head(0).to_sql(name=table_name, con=engine, if_exists='replace')  # Create table
    df.to_sql(name=table_name, con=engine, if_exists='append')  # Insert first chunk

    while True:
        try:
            t_start = time()
            df = next(df_iter)
            df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
            df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
            df.to_sql(name=table_name, con=engine, if_exists='append')  # Insert chunk
            t_end = time()
            print(f"Inserted another chunk, took {t_end - t_start:.3f} seconds")
        except StopIteration:
            print("Finished ingesting data into the PostgreSQL database")
            break

# Import Python packages
import datetime
import pandas as pd
import os
import glob
import psycopg2
DB_ENDPOINT = "csvtoazurepostgres.postgres.database.azure.com"
DEFAULT_DB = 'postgres'
DB = 'csv_etl'
DB_USER = 'tempUser_accident_data_ETL'
DB_PASSWORD = 'A7.Kr2phuVjagj3'
DB_PORT = '5432'
try:
    conn = psycopg2.connect(
                        host=DB_ENDPOINT,
                        port=DB_PORT,
                        dbname=DEFAULT_DB,
                        user=DB_USER,
                        password=DB_PASSWORD)
    print("Connection established")
    conn.set_session(autocommit=True)
    print("Connection is in Auto Commit")
except psycopg2.Error as e:
    print("Error: Could not make connection to the Default Postgres database")
    print(e)

try: 
    cursor = conn.cursor()
except psycopg2.Error as e: 
    print("Error: Could not get cursor to the Database")
    print(e)
    
cursor.close()
conn.close()
try: 
    conn = psycopg2.connect(
                        host=DB_ENDPOINT,
                        port=DB_PORT,
                        dbname=DB,
                        user=DB_USER,
                        password=DB_PASSWORD)
    print("Connection established")
    conn.set_session(autocommit=True)
    print("Connection is in Auto Commit")
except psycopg2.Error as e: 
    print(f"Error: Could not make connection to the {DB} database")
    print(e)
    
try: 
    cursor = conn.cursor()
except psycopg2.Error as e: 
    print("Error: Could not get cursor to the Database")
    print(e)

# Show numeric output in decimal format e.g., 2.15
pd.options.display.float_format = '{:,.2f}'.format
data_frame_riders = pd.read_csv('./data/riders.csv',header=None,names=['rider_id','first','last','address','birthday','account_start_date','account_end_date','is_member'])
data_frame_payments = pd.read_csv('./data/payments.csv',header=None,names=['payment_id','date','amount','rider_id'])
data_frame_stations = pd.read_csv('./data/stations.csv',header=None,names=['station_id','name','latitude','longitude'])
data_frame_trips = pd.read_csv('./data/trips.csv',header=None,names=['trip_id','rideable_type','start_at','ended_at','start_station_id','end_station_id','rider_id'])
print(data_frame_payments.info())
data_frame_payments['date']  = pd.to_datetime(data_frame_payments['date'])
print(data_frame_payments.info())
print(data_frame_trips.info())
data_frame_trips['start_at']  = pd.to_datetime(data_frame_trips['start_at'])
data_frame_trips['ended_at']  = pd.to_datetime(data_frame_trips['ended_at'])
print(data_frame_trips.info())

for index, row in data_frame_payments.iterrows():   
    query = "INSERT INTO payment (payment_id, date, amount, rider_id)"
    query = query + "VALUES (%s, %s, %s, %s)"
    try:
        cursor.execute(query, (row["payment_id"], row["date"], row["amount"], row["rider_id"]))
    except Exception as e:
        print(e)
print("Finished Populating ")
"""
for index, row in data_frame_trips.iterrows():   
    query = "INSERT INTO trip (trip_id, rideable_type, start_at, ended_at, start_station_id, end_station_id, rider_id)"
    query = query + "VALUES (%s, %s, %s, %s, %s, %s, %s)"
    try:
        cursor.execute(query, (row["trip_id"], row["rideable_type"], row["start_at"], row["ended_at"], row["start_station_id"], row["end_station_id"], row["rider_id"]))
    except Exception as e:
        print(e)
Print("Finished Populating ")
"""
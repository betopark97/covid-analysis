import psycopg2
from sqlalchemy import create_engine
import pandas as pd
import os
from dotenv import load_dotenv
load_dotenv()

# Database connection parameters
db_params = {
    "host":"127.0.0.1",
    "database":"covidAnalysis",
    "user":"postgres",
    "password":os.environ.get('PASSWORD'),
    "port":"5432"
}

# Create a connection to the PostgreSQL server
conn = psycopg2.connect(
    host=db_params['host'],
    database=db_params['database'],
    user=db_params['user'],
    password=db_params['password']
)

# Connect to the database
db_params['database'] = 'covidAnalysis'
engine = create_engine(f'postgresql://{db_params["user"]}:{db_params["password"]}@{db_params["host"]}/{db_params["database"]}')

# Define the file paths for your CSV files
csv_files = {
    'covid_deaths': '/Users/robertopark/Documents/code-projects/datascience-projects/corona-analysis/data/covidDeaths.csv',
    'covid_vaccinations': '/Users/robertopark/Documents/code-projects/datascience-projects/corona-analysis/data/covidVaccinations.csv'
}

# Load and display the contents of each CSV file to check
for table_name, file_path in csv_files.items():
    print(f"Contents of '{table_name}' CSV file:")
    df = pd.read_csv(file_path)
    print(df.head(2))  # Display the first few rows of the DataFrame
    print("\n")
    
# Loop through the CSV files and import them into PostgreSQL
for table_name, file_path in csv_files.items():
    df = pd.read_csv(file_path)
    df.to_sql(table_name, engine, if_exists='replace', index=False)
import pandas as pd
from sqlalchemy import create_engine
import urllib

# 1. Load the data
file_path = 'WA_Fn-UseC_-Telco-Customer-Churn.csv'
df = pd.read_csv(file_path)

# 2. Senior Data Quality Check (Governance)
# TotalCharges often has empty strings that break SQL. We convert them to 0.
df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce').fillna(0)

# 3. Connection Setup (Docker SQL Server)
params = urllib.parse.quote_plus(
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost,1433;"
    "DATABASE=MyDatabase;"
    "UID=sa;"
    "PWD=Psw@12345678;" # Ensure this matches your Docker password
    "TrustServerCertificate=yes;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# 4. Upload to SQL
try:
    df.to_sql('Raw_Subscribers', con=engine, if_exists='replace', index=False)
    print("✅ Success: Data ingested into 'Raw_Subscribers' table.")
except Exception as e:
    print(f"❌ Error: {e}")
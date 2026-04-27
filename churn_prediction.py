"""
Orange Project: Churn Prediction

See requirements.txt for dependencies (pandas, scikit-learn, sqlalchemy, pyodbc).
See images/ for a high-res screenshot of the Looker Studio dashboard.

So What? This model enables Marketing to optimize campaign ROI by focusing outbound efforts on the top 10% high-risk/high-value customers, rather than wasting resources on low-risk or low-value segments.
"""

import pandas as pd
import sqlalchemy
import urllib
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
import datetime

# 1. DATABASE CONNECTION
driver_path = '/opt/homebrew/lib/libmsodbcsql.18.dylib' # Ensure this path is correct for your Mac
params = urllib.parse.quote_plus(
    f"DRIVER={{{driver_path}}};"
    "SERVER=localhost,1433;"
    "DATABASE=MyDatabase;"
    "UID=sa;"
    "PWD=Psw@12345678;" 
    "TrustServerCertificate=yes;"
)
engine = sqlalchemy.create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

print("Connecting to SQL Server...")
# Fetch data from your specific view
df = pd.read_sql("SELECT * FROM VW_Subscriber_Master_Insights", engine)

# 2. FEATURE ENGINEERING & PRE-PROCESSING
# We only want to train on "Active" vs "Churned" to predict future behavior
# In your view, Subscriber_Status tells us who has already left
df['target'] = df['Subscriber_Status'].apply(lambda x: 1 if x == 'Churned/Inactive' else 0)

# Select relevant features for the model (The "Senior" selection)
features = [
    'Network_Type', 'tenure', 'Contract', 'ARPU', 
    'Product_Density_Score', 'Customer_Segment'
]
X = df[features].copy()

# Encode Categorical Variables (ML models need numbers)
le = LabelEncoder()
for col in ['Network_Type', 'Contract', 'Customer_Segment']:
    X[col] = le.fit_transform(X[col].astype(str))

y = df['target']

# 3. MODEL TRAINING
# We split the data to test accuracy, but we'll use the whole set for the marketing list
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

print("Training Propensity Model...")
model = RandomForestClassifier(n_estimators=100, max_depth=10, random_state=42)
model.fit(X_train, y_train)

# 4. PREDICTION (Propensity Scoring)
# Calculate the probability of churn (0.0 to 1.0)
df['Churn_Probability'] = model.predict_proba(X)[:, 1]

# 5. GENERATE MARKETING TARGET LIST
# Marketing only needs to target ACTIVE customers who have a HIGH probability of leaving
target_list = df[df['Subscriber_Status'] == 'Active'].copy()

# Sort by highest risk first
target_list = target_list.sort_values(by='Churn_Probability', ascending=False)

# Add "Action" labels for Marketing
def suggest_action(row):
    if row['Churn_Probability'] > 0.8: return "Immediate Outbound Call"
    if row['Churn_Probability'] > 0.5: return "SMS Retention Offer"
    return "Nurture / No Action"

target_list['Recommended_Action'] = target_list.apply(suggest_action, axis=1)

# 6. EXPORT TO CSV
filename = f"Marketing_Churn_Target_List_{datetime.date.today()}.csv"
# We only send Marketing what they need to act (ID, Risk, and Action)
export_cols = [
    'customerID', 'Network_Type', 'ARPU', 'Customer_Segment', 
    'Churn_Probability', 'Recommended_Action'
]
target_list[export_cols].to_csv(filename, index=False)

print(f"✅ Success! Target list generated: {filename}")
print(f"Top 5 High-Risk Targets identified:\n{target_list[export_cols].head()}")
# Orange Project: Churn Prediction

## Overview
This project uses a machine learning model to predict customer churn for a telecom company. The model enables Marketing to optimize campaign ROI by focusing outbound efforts on the top 10% high-risk/high-value customers, rather than wasting resources on low-risk or low-value segments.

## How it Works
- Data is ingested from SQL Server and preprocessed for quality.
- A Random Forest model is trained to predict churn propensity.
- The output is a ranked list of active customers, with recommended marketing actions based on churn risk.
- A Looker Studio dashboard visualizes the results for business stakeholders.

## Requirements
See requirements.txt for dependencies.

## Visualization
See the images/ folder for a high-resolution screenshot of the Looker Studio dashboard.

## Usage
1. Install dependencies: `pip install -r requirements.txt`
2. Run the model: `python churn_prediction.py`
3. Review the generated marketing target list CSV and dashboard screenshot.

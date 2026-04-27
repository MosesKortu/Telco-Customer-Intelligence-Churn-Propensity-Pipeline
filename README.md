# 📊 Telco Customer Intelligence & Churn Propensity Pipeline

**A modern, production-grade end-to-end analytics pipeline for telecommunications** — turning raw technical logs into actionable executive insights and proactive churn mitigation.

---

## 🎯 Project Vision

This repository showcases a **full-scale Performance & Consumer Insights platform** built specifically for the telecom industry.

By combining **SQL governance**, **Python machine learning**, and **executive BI visualization**, the project goes beyond traditional reporting to deliver **proactive business strategy** — directly impacting key revenue levers such as **ARPU uplift** and **churn reduction**.

---

## 🏗️ The Data Value Chain

The pipeline closely mirrors real-world enterprise telecom environments, with clean data flow from raw logs to C-level decision making:

### 1. Ingestion & ETL
- Automated data loading using Python (`ingest_data.py`)
- Loads into a **Dockerized SQL Server** for consistency and scalability

### 2. KPI Governance & Metric Layer
- Robust SQL view (`VW_Subscriber_Master_Insights`) serving as the **Single Source of Truth**
- Ensures reporting accuracy and financial reconciliation across the organization

### 3. Predictive Modeling
- Random Forest classifier (`churn_prediction.py`) predicting churn probability for every active subscriber

### 4. Executive Visualization
- Interactive **Looker Studio** dashboards designed for the CEO Office and leadership team

---

## 🛠️ Key Features

### 1. KPI Governance & Metric Layer (SQL)

A powerful SQL metric layer that transforms raw technical data into high-value commercial KPIs:

- **Infrastructure Mapping**: Automatically converts technical service types into commercial offerings (e.g., Fiber optic → 4G)
- **Revenue Stability Segmentation**: Classifies customers as "At-Will" vs. "Contractual" to quantify baseline revenue risk
- **Product Density Score**: Measures customer "stickiness" based on integrated services (Voice, Data, VAS, MoMo)
- **Tenure Deciles**: Groups the subscriber base into 10% buckets to analyze lifecycle value evolution

### 2. Churn Propensity Modeling (Python)

Advanced machine learning module focused on **Customer Affinity Detection**:

- Random Forest Classification to uncover behavioral patterns preceding churn
- Assigns a **Churn Propensity Score** (0.0 – 1.0) to every active subscriber
- Generates a prioritized **Marketing Target List** with **Next-Best-Action** recommendations (e.g., "Immediate Outbound Call" for high-value, high-risk customers)

### 3. CEO Strategic Dashboards (Looker Studio)

Executive-ready visualizations built to serve as a **trusted business partner** to leadership:

- **Strategic Value Quadrant**: Bubble chart plotting customers by ARPU vs. Churn Risk
- **4G Migration Funnel**: Quantifies revenue opportunity in upgrading from 3G to 4G
- **Revenue Weight Treemap**: Highlights which customer segments drive the majority of total revenue

---

## 📂 Repository Structure

```bash
telco-customer-intelligence/
├── automation/
│   └── ingest_data.py                 # ETL pipeline for SQL Server ingestion
├── sql/
│   └── master_view_insights.sql       # KPI governance & metric layer logic
├── models/
│   └── churn_prediction.py            # Churn propensity modeling & targeting
├── assets/                            # Dashboard screenshots, architecture diagrams
├── requirements.txt                   # Python dependencies
├── docker-compose.yml                 # Docker setup for SQL Server
└── README.md                          # This file

🚀 How to Run
Prerequisites

Docker (for SQL Server)
Python 3.9+

1. Start the Database
Bashdocker-compose up -d
2. Install Dependencies
Bashpip install -r requirements.txt
3. Run Data Ingestion
Bashpython automation/ingest_data.py
4. Deploy KPI Metric Layer
Execute the SQL script in your SQL Server:
SQL-- Run sql/master_view_insights.sql
5. Generate Churn Predictions & Target List
Bashpython models/churn_prediction.py
This will output a CSV file with churn scores and recommended actions for the marketing team.

## Tech Stack

Database: SQL Server (Dockerized)
ETL: Python + pandas + pyodbc / SQLAlchemy
Analytics: SQL (Window functions, CTEs, complex joins)
Machine Learning: scikit-learn (Random Forest)
Visualization: Looker Studio
Orchestration: Python scripts + Docker


## Business Impact

Proactive churn mitigation through early identification of at-risk high-value customers
Revenue protection via contract vs. at-will risk visibility
Upsell & Migration opportunities clearly quantified (e.g., 3G → 4G)
Executive alignment with clear, visual strategic narratives


Built with ❤️ for Telecom Analysts, Data Scientists, and Revenue Growth teams.
Feel free to explore, fork, or adapt this pipeline for your own telco use cases!

🏷️ Keywords
Telecom Analytics • Customer Churn Prediction • KPI Governance • SQL Metric Layer • Looker Studio • Random Forest • ARPU • Customer Lifetime Value
textThis is now a complete, professional, and well-structured `README.md` ready for your GitHub portfolio.

**Tip**:  
You can add GitHub badges at the very top (right after the title) if you want it to look even more modern. Let me know if you'd like me to add badges for Python, SQL, Docker, scikit-learn, etc.


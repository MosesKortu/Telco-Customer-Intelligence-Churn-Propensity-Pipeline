#  Telco Customer Intelligence & Churn Propensity Pipeline

**A modern, production-grade end-to-end analytics pipeline for telecommunications** — turning raw technical logs into actionable executive insights and proactive churn mitigation.

---
## 🛠️ Tech Stack

### Languages & Core
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![SQL](https://img.shields.io/badge/sql-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)

### Data Engineering & Infastructure
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![ngrok](https://img.shields.io/badge/ngrok-001E2B?style=for-the-badge&logo=ngrok&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/sqlalchemy-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)

### Data Science & Analytics
![Pandas](https://img.shields.io/badge/pandas-%23150458.svg?style=for-the-badge&logo=pandas&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit--learn-%23F7931E.svg?style=for-the-badge&logo=scikit-learn&logoColor=white)
![Looker Studio](https://img.shields.io/badge/Looker%20Studio-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)

---
##  Project Vision

This repository showcases a **full-scale Performance & Consumer Insights platform** built specifically for the telecom industry.

By combining **SQL governance**, **Python machine learning**, and **executive BI visualization**, the project goes beyond traditional reporting to deliver **proactive business strategy** — directly impacting key revenue levers such as **ARPU uplift** and **churn reduction**.

---

## The Data Value Chain

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

##  Key Features

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

### 3. 📡 Connectivity & Infrastructure: The ngrok Tunnel
In this project, the data layer resides on a local Dockerized SQL Server, while the visualization layer is hosted in the Google Looker Studio Cloud. To bridge these environments, I implemented a secure TCP Tunneling strategy using ngrok.

The Challenge: Cloud-based BI tools cannot natively access localhost or private network databases due to firewall and IP restrictions.

The Solution: By initiating an ngrok tcp 1433 tunnel, I exposed the local SQL port through a secure, temporary public endpoint.

The Impact: This enabled a seamless Automated Reporting Pipeline, allowing cloud dashboards to query local "Big Data" sets in real-time without requiring complex VPN or static IP configurations.

### 4. CEO Strategic Dashboards (Looker Studio)

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


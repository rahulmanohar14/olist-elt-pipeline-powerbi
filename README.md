# 🛒 Olist E-Commerce Analytics Pipeline & Executive Dashboard

## 📌 Executive Summary
This project is an end-to-end analytics engineering solution built for Olist, the largest department store in Brazilian marketplaces. Moving beyond basic data visualization, this project implements a complete ELT (Extract, Load, Transform) pipeline to convert over 100,000 raw e-commerce records into a production-ready Star Schema, culminating in an interactive, 3-page Power BI application designed for executive decision-making.

## 🛠️ Technology Stack
* **Language & Extraction:** Python, Pandas, Jupyter Notebooks
* **Cloud Data Warehouse:** Google BigQuery
* **Data Transformation & Modeling:** dbt (data build tool)
* **Business Intelligence:** Microsoft Power BI

---

## 🏗️ Architecture & Data Pipeline

### 1. Python Extraction & Cloud Loading (`01_extract_and_load.ipynb`)
The pipeline begins with a custom Python script that extracts multiple raw, normalized CSV datasets (Customers, Orders, Reviews, Products, etc.). The script performs initial data type validation and schema enforcement before programmatically loading the raw tables into a staging dataset within **Google BigQuery** using the Google Cloud BigQuery API.

### 2. dbt Transformation & DAG
Once in BigQuery, **dbt** takes over to handle the heavy lifting of the transformations. I engineered SQL-based dbt models to clean the data, cast timestamps, and join the disparate raw tables into a clean `analytics_dev` presentation layer. 

*Below is the DAG (Directed Acyclic Graph) showing the data lineage from raw sources to the final analytical views:*

![dbt Lineage Graph](dbt_lineage.png)

### 3. Dimensional Modeling (Star Schema)
To ensure the Power BI dashboard performs lightning-fast cross-filtering, the BigQuery `analytics_dev` layer is structured into a strict Star Schema:
* **Fact Tables:** `fact_orders`, `fact_reviews`
* **Dimension Tables:** `dim_customers`, `dim_products`, `dim_date`

---

## 📊 Dashboard Previews & Key Insights

### Page 1: Executive KPI Summary
*(Designed for C-Suite quick-glance health checks)*
![Executive Summary](page1.png)
* **Insight:** Implemented an RFM (Recency, Frequency, Monetary) segmentation model to categorize users into New, Average, and Lost customers, providing immediate visibility into customer retention metrics and overall revenue trajectory.

### Page 2: Marketing Action Plan
*(Designed for the Director of Marketing & Regional Managers)*
![Marketing Action Plan](page2.png)
* **Insight:** Geospatial analysis revealed high concentrations of revenue in the southeastern Brazilian states (SP, RJ, MG). Cross-filtering this with the time-series analysis shows consistent order volume drops on weekends, indicating that promotional ad spend should be heavily weighted toward Monday-Wednesday in these specific regions.

### Page 3: Customer Experience & Sentiment Analysis
*(Designed for the Head of Customer Success)*
![Sentiment Analysis](page3.png)
* **Insight:** By filtering out partial-month data anomalies, the historical trendline revealed a severe drop in customer satisfaction between November 2017 and February 2018. This correlates directly with Black Friday and Holiday order surges, highlighting a critical supply-chain bottleneck during peak seasons that has since been corrected. 

---

## 🚀 How to Run Locally
1. Clone this repository.
2. Run `01_extract_and_load.ipynb` to push the raw data to your BigQuery project (requires GCP `credentials.json`).
3. Ensure you have `dbt-core` and `dbt-bigquery` installed. Update the `profiles.yml` file with your GCP credentials.
4. Run `dbt run` in the terminal to execute the models and build the views in BigQuery.
5. Open `Olist_Executive_Dashboard.pbix` in Power BI Desktop to view the visual layer.

---
**About the Author:** Rahul Manohar Durshinapally - Master of Science in Information Systems candidate at Northeastern University
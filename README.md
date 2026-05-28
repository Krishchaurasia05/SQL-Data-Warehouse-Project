# 📊 Sales Data Warehouse Project

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

---

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion](https://www.notion.com/):** All-in-one tool for project management and organization.
- **[Notion Project Steps](https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269?pvs=4):** Access to All Project Phases and Tasks.

---


# 🚀 Project Requirements

### Objective

Develop a SQL Server-based Data Warehouse to centralize and transform sales data for analytical reporting.

### Key Requirements

* Import data from ERP and CRM systems provided as CSV files
* Clean and preprocess raw datasets
* Resolve data quality issues
* Build a unified analytical data model
* Design ETL workflows
* Create documentation for business and analytics teams

---

# 🛠️ Tech Stack

* SQL Server
* T-SQL
* CSV Files
* ETL Concepts
* Data Modeling
* SSMS (SQL Server Management Studio)

---

# 🏗️ Data Architecture

The project follows a layered Data Warehouse architecture:

![Data Architecture](Docs/data_architecture.png)

### Bronze Layer

* Raw data ingestion from source systems
* Data stored without transformations

### Silver Layer

* Data cleansing and standardization
* Handling null values, duplicates, and inconsistencies

### Gold Layer

* Business-ready analytical model
* Optimized for reporting and dashboard creation

---

# 🔄 ETL Process

1. Extract data from ERP and CRM CSV files
2. Load raw data into Bronze layer
3. Transform and clean data in Silver layer
4. Build analytical tables in Gold layer
5. Generate business-ready datasets for reporting

---

# 📂 Project Structure

---text
.
├── Datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
├── Docs/
│   ├── data_architecture.drawio
│   ├── data_architecture.png
│   ├── data_catalog.md
│   ├── data_flow.drawio
│   ├── data_flow.png
│   ├── data_integration.drawio
│   ├── data_integration.png
│   ├── data_mart.drawio
│   └── data_mart.png
├── Scripts/
│   ├── Bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   ├── Gold/
│   │   └── ddl_gold.sql
│   ├── Silver/
│   │   ├── ddl_silver.sql
│   │   └── proc_load_silver.sql
│   └── init_database.sql
├── Tests/
│   ├── quality_checks_gold.sql
│   └── quality_checks_silver.sql
├── LICENSE
├── README.md
└── requirements.md
---
---

# 📊 Key Features

* Multi-source data integration
* Data cleansing and transformation
* Analytical data modeling
* ETL pipeline development
* Business-friendly schema design
* Scalable warehouse structure

---

# 📈 Business Use Cases

This warehouse can support:

* Sales trend analysis
* Customer analysis
* Product performance tracking
* Revenue reporting
* KPI dashboards

---

# 🎯 Learning Outcomes

Through this project, I gained hands-on experience in:

* SQL Server development
* Data Warehousing concepts
* ETL pipeline design
* Data cleaning and transformation
* Analytical data modeling
* Query optimization

---

## About Me

Hey there! I am **Krish Chaurasia** an aspiring Data Analyst and Data Engineer passionate about working with real-world data to uncover insights and solve business problems.

I’m currently building projects using Excel, SQL, Python, and Power BI while strengthening my skills in data analytics and data engineering fundamentals.

I enjoy creating dashboards, analyzing datasets, and learning how data-driven solutions support better decision-making.

## Connect With Me

- LinkedIn: www.linkedin.com/in/krishchaurasia
- Email: krishchaurasia244@gmail.com

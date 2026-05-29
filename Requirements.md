# 📋 Project Requirements

## SQL Data Warehouse Project

---

## 🚀 Project Requirements

### Building the Data Warehouse

#### Objective

Design and develop a modern SQL Server-based Data Warehouse to consolidate and transform sales data from multiple source systems (ERP and CRM), enabling efficient analytical reporting and data-driven decision-making through a clean, layered Medallion Architecture.

#### Project Requirements

* Import and integrate sales data from two different source systems (ERP and CRM) provided in CSV format across 6 source datasets.
* Perform data cleansing and preprocessing to handle inconsistencies, duplicates, missing values, invalid dates, and cross-system key mismatches.
* Build a unified, business-friendly data model using a Star Schema — with dedicated Fact and Dimension tables — optimized for analytical and reporting queries.
* Develop automated ETL workflows using SQL Server stored procedures to extract, transform, and load data across Bronze, Silver, and Gold layers.
* Implement data quality validation scripts to test and confirm data integrity at both the Silver and Gold layers before consumption.
* Focus on processing the latest available dataset; historical data tracking (SCD / historization) is out of scope.
* Create clear and structured documentation — including a data catalog, data flow diagrams, integration maps, and architecture diagrams — to support analytics teams and business stakeholders.
* Design the Gold layer to directly support business use cases: sales trend analysis, customer segmentation, product performance tracking, and revenue KPI reporting.

#### Tech Stack

* SQL Server 2022 Express
* T-SQL (DDL, DML, Stored Procedures, CTEs, Window Functions)
* CSV Data Sources (ERP + CRM systems)
* Medallion Architecture (Bronze / Silver / Gold)
* ETL Processes (Stored Procedure–driven pipelines)
* Dimensional Data Modeling (Star Schema — Fact & Dimension Tables)
* SSMS — SQL Server Management Studio
* DrawIO (Architecture & flow diagrams)
* Git & GitHub (Version control)

---

## 🖥️ System Requirements

| Component | Minimum | Recommended |
|---|---|---|
| Operating System | Windows 10 (64-bit) | Windows 10 / 11 (64-bit) |
| RAM | 4 GB | 8 GB or more |
| Disk Space | 2 GB free | 5 GB free |
| Processor | x64, 1.4 GHz | x64, 2.0 GHz or faster |
| Internet | Required for tool downloads | Required for tool downloads |

> **Note:** SQL Server Express and SSMS are Windows-only. macOS/Linux users can use [Azure Data Studio](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio) as a free alternative to SSMS — all `.sql` scripts are fully compatible.

---

## 🛠️ Tools & Setup

Everything listed here is **free to download and use**.

---

### 1. Microsoft SQL Server 2022 Express

The core database engine that hosts the Data Warehouse.

| Detail | Info |
|---|---|
| Version | SQL Server 2022 Express (or later) |
| License | Free — Express edition |
| Download | https://www.microsoft.com/en-us/sql-server/sql-server-downloads |

**Installation steps:**
1. Download the installer and select **"Basic"** installation type
2. Accept the license terms and complete the installation
3. Note the **server name** shown at the end (e.g. `.\SQLEXPRESS`) — you'll need this to connect in SSMS

---

### 2. SQL Server Management Studio (SSMS)

The graphical interface for connecting to SQL Server, running scripts, and inspecting results.

| Detail | Info |
|---|---|
| Version | SSMS 19.x or later |
| License | Free |
| Download | https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms |

**Installation steps:**
1. Run the SSMS installer with default settings
2. Restart your machine after installation
3. Open SSMS → connect using your server name (e.g. `.\SQLEXPRESS`) with **Windows Authentication**

---

### 3. Git

Required to clone the repository to your local machine.

| Detail | Info |
|---|---|
| Version | Git 2.x or later |
| License | Free / Open Source |
| Download | https://git-scm.com/downloads |

**Verify installation:**
```bash
git --version
# Expected: git version 2.x.x
```

---

### 4. DrawIO *(Optional — for viewing/editing diagrams)*

Used to open and edit the `.drawio` architecture, data flow, and star schema diagram files in the `Docs/` folder.

| Detail | Info |
|---|---|
| License | Free |
| Web app (no install needed) | https://app.diagrams.net |
| Desktop app | https://github.com/jgraph/drawio-desktop/releases |

---

### 5. Notion *(Optional — for project management reference)*

Used during development for tracking project phases and tasks.

| Detail | Info |
|---|---|
| License | Free (personal plan) |
| Access | https://www.notion.com |
| Project board | https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269 |

---

## 📂 Data Requirements

The project uses **6 CSV source files** included in the repository — no external downloads needed.

| File | Source System | Location |
|---|---|---|
| `cust_info.csv` | CRM | `Datasets/source_crm/` |
| `prd_info.csv` | CRM | `Datasets/source_crm/` |
| `sales_details.csv` | CRM | `Datasets/source_crm/` |
| `CUST_AZ12.csv` | ERP | `Datasets/source_erp/` |
| `LOC_A101.csv` | ERP | `Datasets/source_erp/` |
| `PX_CAT_G1V2.csv` | ERP | `Datasets/source_erp/` |

> **Before running the ETL pipeline**, update the `BULK INSERT` file paths inside `Scripts/Bronze/proc_load_bronze.sql` to match your local clone directory:

```sql
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\YourName\SQL-Data-Warehouse-Project\Datasets\source_crm\cust_info.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
```

---

## 🚀 Script Execution Order

Run scripts in this exact order for a clean, successful setup:

| Step | Script | Purpose |
|---|---|---|
| 1 | `Scripts/init_database.sql` | Creates `DataWarehouse` DB and Bronze, Silver, Gold schemas |
| 2 | `Scripts/Bronze/ddl_bronze.sql` | Creates all Bronze layer raw tables |
| 3 | `Scripts/Silver/ddl_silver.sql` | Creates all Silver layer cleansed tables |
| 4 | `Scripts/Gold/ddl_gold.sql` | Creates Gold layer analytical views/tables |
| 5 | `EXEC bronze.load_bronze;` | Runs Bronze ETL — loads all 6 CSVs into Bronze |
| 6 | `EXEC silver.load_silver;` | Runs Silver ETL — cleanses and transforms data |
| 7 | `Tests/quality_checks_silver.sql` | Validates Silver layer data quality |
| 8 | `Tests/quality_checks_gold.sql` | Validates Gold layer data integrity |

---

## ❌ Out of Scope

| Feature | Reason |
|---|---|
| SCD Type 2 / Historization | Project tracks latest snapshot only — by design |
| Incremental loading | Full refresh ETL used for simplicity |
| SQL Server Agent scheduling | Manual execution via SSMS |
| Power BI / SSRS integration | Analytics layer is SQL-only in this version |
| Cloud deployment (Azure SQL) | Local SQL Server Express only |
| Python / pandas ETL | Pure T-SQL pipeline by design |


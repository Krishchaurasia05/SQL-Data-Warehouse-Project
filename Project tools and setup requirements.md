# 📋 Project Requirements

## SQL Data Warehouse Project — Dependencies, Tools & Setup Requirements

---

## 🖥️ System Requirements

| Component | Minimum | Recommended |
|---|---|---|
| Operating System | Windows 10 (64-bit) | Windows 10 / 11 (64-bit) |
| RAM | 4 GB | 8 GB or more |
| Disk Space | 2 GB free | 5 GB free |
| Processor | x64, 1.4 GHz | x64, 2.0 GHz or faster |
| Internet | Required for initial tool downloads | Required for initial tool downloads |

> **Note:** SQL Server Express and SSMS are Windows-only tools. macOS/Linux users can use **Azure Data Studio** as an alternative to SSMS (see below).

---

## 🛠️ Required Tools

All tools listed here are **free to download and use**.

---

### 1. Microsoft SQL Server 2022 Express

The core database engine that hosts the Data Warehouse.

| Detail | Info |
|---|---|
| Version | SQL Server 2022 Express (or later) |
| License | Free — Express edition |
| Download | https://www.microsoft.com/en-us/sql-server/sql-server-downloads |
| Installer type | Choose **"Download Media"** → **EXE** for offline install |

**Installation steps:**
1. Download the installer from the link above
2. Select **"Basic"** installation type
3. Accept the license terms
4. Note the **server name** shown at the end of installation (e.g. `.\SQLEXPRESS`) — you'll need this to connect

---

### 2. SQL Server Management Studio (SSMS)

The graphical interface used to connect to SQL Server, run scripts, and inspect query results.

| Detail | Info |
|---|---|
| Version | SSMS 19.x or later |
| License | Free |
| Download | https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms |

**Installation steps:**
1. Download the SSMS installer from the link above
2. Run the installer with default settings
3. Restart your machine after installation
4. Open SSMS → connect using your server name (e.g. `.\SQLEXPRESS`) with **Windows Authentication**

> **macOS / Linux alternative:** Use [Azure Data Studio](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio) (free, cross-platform) instead of SSMS. All `.sql` scripts in this project are fully compatible.

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
# Expected output: git version 2.x.x
```

---

### 4. DrawIO (Optional — for viewing/editing diagrams)

Used to open and edit the architecture, data flow, and star schema diagrams included in the `/Docs` folder.

| Detail | Info |
|---|---|
| Type | Web app (no install needed) or Desktop app |
| License | Free |
| Web app | https://app.diagrams.net |
| Desktop | https://github.com/jgraph/drawio-desktop/releases |

**Usage:** Open any `.drawio` file from the `Docs/` folder directly in the web app or desktop client.

---

### 5. Notion (Optional — for project management reference)

Used to track project phases, tasks, and progress during development.

| Detail | Info |
|---|---|
| License | Free (personal plan) |
| Access | https://www.notion.com |
| Project board | https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269 |

---

## 📂 Data Requirements

The project uses **6 CSV source files** included in the repository under `Datasets/`.

| File | Source System | Location in Repo |
|---|---|---|
| `cust_info.csv` | CRM | `Datasets/source_crm/` |
| `prd_info.csv` | CRM | `Datasets/source_crm/` |
| `sales_details.csv` | CRM | `Datasets/source_crm/` |
| `CUST_AZ12.csv` | ERP | `Datasets/source_erp/` |
| `LOC_A101.csv` | ERP | `Datasets/source_erp/` |
| `PX_CAT_G1V2.csv` | ERP | `Datasets/source_erp/` |

> No external data downloads are needed. All datasets are bundled with the repository.

**Before running the ETL pipeline**, update the file paths inside `Scripts/Bronze/proc_load_bronze.sql` to match your local machine's directory:

```sql
-- Example: update this path to your actual clone location
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\YourName\SQL-Data-Warehouse-Project\Datasets\source_crm\cust_info.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
```

---

## 🗃️ SQL Server Configuration Requirements

| Setting | Required Value |
|---|---|
| SQL Server Edition | Express (or Standard / Developer) |
| Authentication Mode | Windows Authentication (default) or Mixed Mode |
| TCP/IP Protocol | Enabled (for remote connections — optional) |
| Collation | `SQL_Latin1_General_CP1_CI_AS` (default — no change needed) |
| Database Name | `DataWarehouse` (created by `init_database.sql`) |
| Schemas Created | `bronze`, `silver`, `gold` |

---

## 🚀 Script Execution Order

Run scripts in this exact order for a successful setup:

| Step | Script | Purpose |
|---|---|---|
| 1 | `Scripts/init_database.sql` | Creates `DataWarehouse` DB and all 3 schemas |
| 2 | `Scripts/Bronze/ddl_bronze.sql` | Creates all Bronze layer tables |
| 3 | `Scripts/Silver/ddl_silver.sql` | Creates all Silver layer tables |
| 4 | `Scripts/Gold/ddl_gold.sql` | Creates all Gold layer views/tables |
| 5 | `EXEC bronze.load_bronze;` | Runs Bronze ETL — loads raw CSVs |
| 6 | `EXEC silver.load_silver;` | Runs Silver ETL — cleanses & transforms |
| 7 | `Tests/quality_checks_silver.sql` | Validates Silver layer data quality |
| 8 | `Tests/quality_checks_gold.sql` | Validates Gold layer data integrity |

---

## ⚙️ SQL Server Features Used

| Feature | Used In |
|---|---|
| `BULK INSERT` | Bronze stored procedure — CSV ingestion |
| Stored Procedures | `proc_load_bronze.sql`, `proc_load_silver.sql` |
| CTEs (Common Table Expressions) | Silver transformation logic |
| Window Functions (`ROW_NUMBER`) | Duplicate detection and deduplication |
| `CASE` expressions | Null handling and value standardization |
| `CAST` / `CONVERT` | Data type normalization |
| `LEFT JOIN` / `JOIN` | Multi-source data integration |
| Views | Gold layer analytical tables |
| `TRY_CAST` | Safe type conversion with error handling |

---

## ❌ Out of Scope

The following are **intentionally excluded** from this project:

| Feature | Reason |
|---|---|
| SCD Type 2 / Historization | Project tracks latest snapshot only |
| Incremental loading | Full refresh ETL used for simplicity |
| SQL Server Agent scheduling | Manual execution via SSMS |
| Power BI / SSRS integration | Analytics layer is SQL-only in this version |
| Cloud deployment (Azure SQL) | Local SQL Server Express only |
| Python / pandas ETL | Pure T-SQL pipeline by design |

---

## 🔮 Future Requirements (Planned)

| Feature | Tool / Approach |
|---|---|
| Dashboard & visualization | Power BI Desktop (free) |
| Incremental ETL loading | SQL Server `MERGE` statements |
| SCD Type 2 historization | Timestamp + is_current flag pattern |
| Automated scheduling | SQL Server Agent |
| Containerization | Docker + SQL Server Linux image |

---

## 📬 Questions or Issues?

If you run into setup problems, feel free to open a [GitHub Issue](https://github.com/Krishchaurasia05/SQL-Data-Warehouse-Project/issues) or reach out:

- **LinkedIn:** [linkedin.com/in/krishchaurasia](https://www.linkedin.com/in/krishchaurasia)
- **Email:** krishchaurasia244@gmail.com

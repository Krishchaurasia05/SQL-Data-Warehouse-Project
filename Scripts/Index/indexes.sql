-- ============================================================

-- Description  : Strategic indexes on Silver layer base tables
--                for query optimization across Gold layer views
--
-- WHY SILVER LAYER?
-- Gold layer tables are VIEWS — indexes cannot be created
-- directly on regular SQL Server views. When Gold views are
-- queried, SQL Server automatically uses indexes on the
-- underlying Silver base tables.
--
-- SILVER BASE TABLES:
--   silver.crm_sales_details  → powers gold.fact_sales
--   silver.crm_cust_info      → powers gold.dim_customers
--   silver.erp_cust_info      → powers gold.dim_customers
--   silver.erp_loc            → powers gold.dim_customers
--   silver.crm_product_info   → powers gold.dim_products
--   silver.erp_px_cat         → powers gold.dim_products
--
-- GOLD VIEWS (for reference):
--   gold.fact_sales
--   gold.dim_customers
--   gold.dim_products
-- ============================================================


-- ============================================================
-- SECTION 1: CLUSTERED INDEXES
-- Auto-created by SQL Server via PRIMARY KEY constraints.
-- Listed here for documentation only — DO NOT run manually.
-- ============================================================

-- silver.crm_sales_details  → clustered on sls_id (PK)
-- silver.crm_cust_info      → clustered on cst_id (PK)
-- silver.erp_cust_info      → clustered on e_cst_cid (PK)
-- silver.erp_loc            → clustered on loc_cid (PK)
-- silver.crm_product_info   → clustered on prd_id (PK)
-- silver.erp_px_cat         → clustered on px_id (PK)


-- ============================================================
-- SECTION 2: NON-CLUSTERED INDEXES
-- ============================================================


-- ------------------------------------------------------------
-- TABLE: silver.crm_sales_details
-- Powers: gold.fact_sales
-- Used in: Q01 Revenue Trend, Q02 Top Products,
--          Q03 Customer Segmentation
-- ------------------------------------------------------------

-- Index 1: Date filter — Q01 filters and groups by order date
-- Covers: WHERE sls_order_date BETWEEN x AND y
-- Covers: YEAR(sls_order_date), MONTH(sls_order_date)
CREATE NONCLUSTERED INDEX idx_crm_sales_order_date
ON silver.crm_sales_details (sls_order_date);
GO

-- Index 2: Composite — date + sales for revenue aggregations
-- Covers: GROUP BY sls_order_date WITH SUM(sls_sales)
-- Avoids fetching full row — only needs date + sales amount
CREATE NONCLUSTERED INDEX idx_crm_sales_date_amount
ON silver.crm_sales_details (sls_order_date, sls_sales);
GO

-- Index 3: Product join — Q02 joins fact to dim_products
-- Covers: JOIN gold.dim_products ON sls_prd_key = product_number
CREATE NONCLUSTERED INDEX idx_crm_sales_product_key
ON silver.crm_sales_details (sls_prd_key);
GO

-- Index 4: Composite — product + date for yearly product ranking
-- Covers: GROUP BY sls_prd_key, YEAR(sls_order_date)
CREATE NONCLUSTERED INDEX idx_crm_sales_product_date
ON silver.crm_sales_details (sls_prd_key, sls_order_date);
GO

-- Index 5: Customer join — Q03 joins fact to dim_customers
-- Covers: JOIN gold.dim_customers ON sls_cst_id = customer_id
CREATE NONCLUSTERED INDEX idx_crm_sales_customer_id
ON silver.crm_sales_details (sls_cst_id);
GO

-- Index 6: Composite — customer + sales for lifetime spend
-- Covers: GROUP BY sls_cst_id WITH SUM(sls_sales)
-- Avoids fetching full row — only needs customer + sales amount
CREATE NONCLUSTERED INDEX idx_crm_sales_customer_amount
ON silver.crm_sales_details (sls_cst_id, sls_sales);
GO


-- ------------------------------------------------------------
-- TABLE: silver.crm_cust_info
-- Powers: gold.dim_customers (Master source for gender)
-- Used in: Q03 Customer Segmentation
-- ------------------------------------------------------------

-- Index 7: Customer key join — links CRM to ERP customer data
-- Covers: JOIN silver.erp_cust_info ON cst_key = e_cst_cid
CREATE NONCLUSTERED INDEX idx_crm_cust_key
ON silver.crm_cust_info (cst_key);
GO

-- Index 8: Customer ID lookup
-- Covers: JOIN gold.dim_customers ON sls_cst_id = cst_id
CREATE NONCLUSTERED INDEX idx_crm_cust_id
ON silver.crm_cust_info (cst_id);
GO

-- Index 9: Gender filter
-- Covers: CASE WHEN cst_gender != 'N/A'
CREATE NONCLUSTERED INDEX idx_crm_cust_gender
ON silver.crm_cust_info (cst_gender);
GO


-- ------------------------------------------------------------
-- TABLE: silver.erp_cust_info
-- Powers: gold.dim_customers (Secondary source for gender/DOB)
-- Used in: Q03 Customer Segmentation
-- ------------------------------------------------------------

-- Index 10: ERP customer ID join
-- Covers: JOIN silver.crm_cust_info ON e_cst_cid = cst_key
CREATE NONCLUSTERED INDEX idx_erp_cust_cid
ON silver.erp_cust_info (e_cst_cid);
GO


-- ------------------------------------------------------------
-- TABLE: silver.erp_loc
-- Powers: gold.dim_customers (Country lookup)
-- Used in: Customer country filtering
-- ------------------------------------------------------------

-- Index 11: Location customer ID join
-- Covers: JOIN silver.erp_loc ON cst_key = loc_cid
CREATE NONCLUSTERED INDEX idx_erp_loc_cid
ON silver.erp_loc (loc_cid);
GO

-- Index 12: Country filter
-- Covers: WHERE country = 'United States'
CREATE NONCLUSTERED INDEX idx_erp_loc_country
ON silver.erp_loc (loc_country);
GO


-- ------------------------------------------------------------
-- TABLE: silver.crm_product_info
-- Powers: gold.dim_products
-- Used in: Q02 Top Products by Revenue
-- ------------------------------------------------------------

-- Index 13: Product key join
-- Covers: JOIN gold.dim_products ON sls_prd_key = prd_key
CREATE NONCLUSTERED INDEX idx_crm_product_key
ON silver.crm_product_info (prd_key);
GO

-- Index 14: Active products filter
-- Covers: WHERE prd_end_date IS NULL (used in gold view)
CREATE NONCLUSTERED INDEX idx_crm_product_end_date
ON silver.crm_product_info (prd_end_date);
GO

-- Index 15: Category ID join — links to erp_px_cat
-- Covers: JOIN silver.erp_px_cat ON prd_cat = px_id
CREATE NONCLUSTERED INDEX idx_crm_product_cat
ON silver.crm_product_info (prd_cat);
GO

-- Index 16: Composite — start date + product ID for product_key
-- ROW_NUMBER() OVER(ORDER BY prd_start_date, prd_id)
-- in gold view benefits from this composite index
CREATE NONCLUSTERED INDEX idx_crm_product_start_date_id
ON silver.crm_product_info (prd_start_date, prd_id);
GO


-- ------------------------------------------------------------
-- TABLE: silver.erp_px_cat
-- Powers: gold.dim_products (Category & Sub-category lookup)
-- Used in: Q02 WHERE category = 'Bikes'
-- ------------------------------------------------------------

-- Index 17: Category ID join
-- Covers: JOIN silver.crm_product_info ON px_id = prd_cat
CREATE NONCLUSTERED INDEX idx_erp_px_cat_id
ON silver.erp_px_cat (px_id);
GO

-- Index 18: Category name filter
-- Covers: WHERE category = 'Bikes' in Q02
CREATE NONCLUSTERED INDEX idx_erp_px_category
ON silver.erp_px_cat (px_category);
GO


-- ============================================================
-- SECTION 3: UNIQUE NON-CLUSTERED INDEXES
-- Enforce data integrity on natural business keys
-- Prevents duplicate records in dimension source tables
-- ============================================================

-- Unique Index 1: No duplicate customer keys in crm_cust_info
CREATE UNIQUE NONCLUSTERED INDEX idx_crm_cust_unique_key
ON silver.crm_cust_info (cst_key);
GO

-- Unique Index 2: No duplicate product keys in crm_product_info
CREATE NONCLUSTERED INDEX idx_crm_product_unique_key
ON silver.crm_product_info (prd_key);
GO

-- Unique Index 3: No duplicate ERP customer IDs
CREATE UNIQUE NONCLUSTERED INDEX idx_erp_cust_unique_cid
ON silver.erp_cust_info (e_cst_cid);
GO



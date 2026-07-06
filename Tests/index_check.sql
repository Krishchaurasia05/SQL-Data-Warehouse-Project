-- Check indexes on silver.crm_sales_details
SELECT
    i.name          AS index_name,
    i.type_desc     AS index_type,
    i.is_unique,
    c.name          AS column_name,
    ic.key_ordinal  AS column_order
FROM sys.indexes i
JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
JOIN sys.columns c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('silver.crm_sales_details')
ORDER BY i.name, ic.key_ordinal;
GO

-- Check indexes on silver.crm_product_info
SELECT
    i.name          AS index_name,
    i.type_desc     AS index_type,
    i.is_unique,
    c.name          AS column_name,
    ic.key_ordinal  AS column_order
FROM sys.indexes i
JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
JOIN sys.columns c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('silver.crm_product_info')
ORDER BY i.name, ic.key_ordinal;
GO

-- Check indexes on silver.crm_cust_info
SELECT
    i.name          AS index_name,
    i.type_desc     AS index_type,
    i.is_unique,
    c.name          AS column_name,
    ic.key_ordinal  AS column_order
FROM sys.indexes i
JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
JOIN sys.columns c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('silver.crm_cust_info')
ORDER BY i.name, ic.key_ordinal;
GO


-- ============================================================
-- SECTION 2: VERIFY INDEX USAGE WITH EXECUTION PLAN
-- In SSMS: Press Ctrl + M before running query
-- Look for "Index Seek"  = index IS being used     ✅
-- Look for "Table Scan"  = index is NOT being used  ❌
-- ============================================================

-- Test 1: Verify date indexes work (Q01 Revenue Trend)
SELECT
    YEAR(s.sls_order_date)  AS order_year,
    MONTH(s.sls_order_date) AS order_month,
    SUM(s.sls_sales)        AS total_revenue
FROM silver.crm_sales_details s
WHERE s.sls_order_date BETWEEN '2011-01-01' AND '2013-12-31'
GROUP BY YEAR(s.sls_order_date), MONTH(s.sls_order_date)
ORDER BY order_year, order_month;
GO

-- Test 2: Verify product indexes work (Q02 Top Products)
SELECT
    p.prd_name,
    c.px_category,
    SUM(s.sls_sales) AS total_revenue
FROM silver.crm_sales_details s
JOIN silver.crm_product_info p
    ON s.sls_prd_key = p.prd_key
JOIN silver.erp_px_cat c
    ON p.prd_cat = c.px_id
WHERE p.prd_end_date IS NULL
GROUP BY p.prd_name, c.px_category
ORDER BY total_revenue DESC;
GO

-- Test 3: Verify customer indexes work (Q03 Segmentation)
SELECT
    s.sls_cst_id        AS customer_id,
    SUM(s.sls_sales)    AS lifetime_value,
    CASE
        WHEN SUM(s.sls_sales) >= 5000 THEN 'High'
        WHEN SUM(s.sls_sales) >= 1000 THEN 'Medium'
        ELSE 'Low'
    END                 AS customer_segment
FROM silver.crm_sales_details s
GROUP BY s.sls_cst_id
ORDER BY lifetime_value DESC;
GO

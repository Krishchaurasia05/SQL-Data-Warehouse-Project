/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS 
SELECT
    ROW_NUMBER() OVER(ORDER BY c1.cst_id)        AS customer_key,
    c1.cst_id                                    AS customer_id,
    c1.cst_key                                   AS customer_number,
    CONCAT(c1.cst_firstname,' ',c1.cst_lastname) AS full_name,
    c1.cst_marital_status                        AS marital_status,
    CASE 
        WHEN c1.cst_gender != 'N/A' THEN c1.cst_gender --- CRM is Master Source
        ELSE COALESCE(c2.e_cst_gender,'N/A') 
    END                                          AS gender,
    c3.loc_country                               AS country,
    c2.e_cst_birth_date                          AS birth_date,
    c1.cst_create_date                           AS create_date
FROM         silver.crm_cust_info c1
LEFT JOIN    silver.erp_cust_info c2
ON           c1.cst_key = c2.e_cst_cid
LEFT JOIN    silver.erp_loc c3
ON           c1.cst_key = c3.loc_cid;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO


CREATE VIEW gold.dim_products AS 
SELECT
    ROW_NUMBER() OVER(ORDER BY p1.prd_start_date, p1.prd_id) AS product_key,
    p1.prd_id                                                AS product_id,
    p1.prd_key                                               AS product_number,
    p1.prd_name                                              AS product_name,
    p1.prd_cat                                               AS category_id,
    COALESCE(p2.px_category,'N/A')                           AS category,
    COALESCE(p2.px_sub_category,'N/A')                       AS sub_category,
    COALESCE(p2.px_maintenance,'N/A')                        AS maintenance_required,
    p1.prd_cost                                              AS cost,
    p1.prd_line                                              AS product_line,
    p1.prd_start_date                                        AS start_date
FROM         silver.crm_product_info p1
LEFT JOIN    silver.erp_px_cat p2
ON           p1.prd_cat = p2.px_id
WHERE        p1.prd_end_date is null;
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO


CREATE VIEW gold.fact_sales AS
SELECT
    s1.sls_id              AS order_number,
    pr.product_key,
    cu.customer_key,
    s1.sls_order_date      AS order_date,
    s1.sls_due_date        AS due_date,
    s1.sls_shipping_date   AS shipping_date,
    s1.sls_sales           AS sales,
    s1.sls_quantity        AS quantity,
    s1.sls_price           AS price
FROM         silver.crm_sales_details s1
LEFT JOIN    gold.dim_products pr
ON           s1.sls_prd_key = pr.product_number
LEFT JOIN    gold.dim_customers cu
ON           s1.sls_cst_id = cu.customer_id;
GO

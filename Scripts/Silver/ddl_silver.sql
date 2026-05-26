/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info( 
	cst_id 					INT,
	cst_key 				NVARCHAR(50),
	cst_firstname 			NVARCHAR(50),
	cst_lastname 			NVARCHAR(50),
	cst_marital_status 		NVARCHAR(50),
	cst_gender 				NVARCHAR(50),
	cst_create_date 		DATE,
	dwh_create_date 		DATETIME2 DEFAULT GETdATE()
);
GO

IF OBJECT_ID('silver.crm_product_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_product_info;
CREATE TABLE silver.crm_product_info( 
	prd_id 				INT,
	prd_cat 			NVARCHAR(50),
	prd_key 			NVARCHAR(50),
	prd_name 			NVARCHAR(50),
	prd_cost 			INT,
	prd_line 			NVARCHAR(50),
	prd_start_date 		DATE,
	prd_end_date 		DATE,
	dwh_create_date 	DATETIME2 DEFAULT GETdATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details( 
	sls_id 				NVARCHAR(50),
	sls_prd_key 		NVARCHAR(50),
	sls_cst_id 			INT,
	sls_order_date 		DATE,
	sls_shipping_date 	DATE,
	sls_due_date 		DATE,
	sls_sales 			INT,
	sls_quantity 		INT,
	sls_price 			INT,
	dwh_create_date 	DATETIME2 DEFAULT GETdATE()
);
Go

IF OBJECT_ID('silver.erp_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_info;
CREATE TABLE silver.erp_cust_info( 
	e_cst_cid			NVARCHAR(50),
	e_cst_birth_date 	DATE,
	e_cst_gender 		NVARCHAR(50),
	dwh_create_date 	DATETIME2 DEFAULT GETdATE()
);
GO

IF OBJECT_ID('silver.erp_loc', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc;
CREATE TABLE silver.erp_loc(
	loc_cid 			NVARCHAR(50),
	loc_country 		NVARCHAR(50),
	dwh_create_date 	DATETIME2 DEFAULT GETdATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat;
CREATE TABLE silver.erp_px_cat(
	px_id 				NVARCHAR(50),
	px_category 		NVARCHAR(50),
	px_sub_category 	NVARCHAR(50),
	px_maintenance 		NVARCHAR(50),
	dwh_create_date 	DATETIME2 DEFAULT GETdATE()
);
GO

 

\*
==================================================================================================
DDL Script: Create Bronze tables
==================================================================================================
Script Purpose: 
      This script creates tables in the 'bronze' schema, dropping existing tables
      If they already exist.
      Run this script to redefine the DDL structure of 'bronze' tables

==================================================================================================
*/


IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info( 
	cst_id 				INT,
	cst_key 			NVARCHAR(50),
	cst_firstname 		NVARCHAR(50),
	cst_lastname 		NVARCHAR(50),
	cst_marital_status 	NVARCHAR(50),
	cst_gender 			NVARCHAR(50),
	cst_create_date 	DATE
);
GO

IF OBJECT_ID('bronze.crm_product_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_product_info;
CREATE TABLE bronze.crm_product_info( 
	prd_id 				INT,
	prd_key 			NVARCHAR(50),
	prd_name			NVARCHAR(50),
	prd_cost 			INT,
	prd_line 			NVARCHAR(50),
	prd_start_date 		DATETIME,
	prd_end_date		DATETIME
);
GO

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details( 
	sls_id 				NVARCHAR(50),
	sls_prd_key 		NVARCHAR(50),
	sls_cst_id 			INT,
	sls_order_date 		INT,
	sls_shipping_date 	INT,
	sls_due_date 		INT,
	sls_sales 			INT,
	sls_quantity 		INT,
	sls_price 			INT
);
Go

IF OBJECT_ID('bronze.erp_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_info;
CREATE TABLE bronze.erp_cust_info( 
	e_cst_cid 			NVARCHAR(50),
	e_cst_birth_date 	DATE,
	e_cst_gender 		NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_loc', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc;
CREATE TABLE bronze.erp_loc(
	loc_cid 		NVARCHAR(50),
	loc_country 	NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat;
CREATE TABLE bronze.erp_px_cat(
	px_id 				NVARCHAR(50),
	px_category 		NVARCHAR(50),
	px_sub_category 	NVARCHAR(50),
	px_maintenance 		NVARCHAR(50)
);
GO

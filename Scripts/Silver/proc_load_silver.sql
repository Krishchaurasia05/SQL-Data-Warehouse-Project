/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	    BEGIN TRY
	    Set @batch_start_time = GETDAtE()

        PRINT '=========================================================================================================================='
        PRINT '                                         Loading Silver layer' 
        PRINT '=========================================================================================================================='

        PRINT '=========================================================================================================================='
        PRINT '                                         silver.crm_cust_info' 
        PRINT '=========================================================================================================================='

        SET @start_time = GETDATE();

        PRINT '>> Truncating table silver.crm_cust_info'
        TRUNCATE TABLE silver.crm_cust_info

        PRINT '>>Inserting Data in table silver.crm_cust_info'
        INSERT INTO silver.crm_cust_info(cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_gender,
            cst_marital_status,
            cst_create_date
            )
            SELECT
                cst_id,
                cst_key,
                TRIM(cst_firstname) AS cst_firstname,
                TRIM(cst_lastname) AS cst_lastname,
                CASE UPPER(TRIM(cst_gender))
                    WHEN 'F' THEN 'Female'
                    WHEN 'M' THEN 'Male'
                    ELSE 'N/A'
                END cst_gender,
                CASE UPPER(TRIM(cst_marital_status))
                    WHEN 'S' THEN 'Single'
                    WHEN 'M' THEN 'Married'
                    ELSE 'N/A'
                END cst_marital_status,
                cst_create_date
            FROM (
	            select 
	            *,
	            ROW_NUMBER() OVER(partition by cst_id order by cst_create_date desc) flag
	            from bronze.crm_cust_info
                where cst_id IS NOT NULL
            )t
            where flag = 1

        SET @end_time = GETDATE();
        PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';


        PRINT '=========================================================================================================================='
        PRINT '                                         silver.crm_product_info' 
        PRINT '=========================================================================================================================='

        SET @start_time = GETDATE();

        PRINT '>> Truncating table silver.crm_product_info'
        TRUNCATE TABLE silver.crm_product_info

        PRINT '>>Inserting Data in table silver.crm_product_info'
        INSERT INTO silver.crm_product_info(
            prd_id,
            prd_cat,
            prd_key,
            prd_name,
            prd_cost,
            prd_line,
            prd_start_date,
            prd_end_date)

            SELECT
                prd_id,
                REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
                SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
                prd_name,
                ISNULL(prd_cost,0) AS prd_cost,
                CASE UPPER(TRIM(prd_line))
                    WHEN 'M' THEN 'Mountain'
                    WHEN 'R' THEN 'Road'
                    WHEN 'O' THEN 'Other Sales'
                    WHEN 'T' THEN 'Touring'
                    ELSE 'N/A'
                END prd_line,
                CAST(prd_start_date AS DATE) AS prd_start_date,
                CAST(LEAD(prd_start_date) over(partition by prd_key order by prd_start_date) - 1 AS DATE) AS prd_end_date_test
            FROM bronze.crm_product_info

        SET @end_time = GETDATE();
        PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        PRINT '=========================================================================================================================='
        PRINT '                                         silver.crm_sales_details' 
        PRINT '=========================================================================================================================='

        SET @start_time =GETDATE();

        PRINT '>> Truncating Table silver.crm_sales_details'
        TRUNCATE TABLE silver.crm_sales_details

        PRINT '>>Inserting Data in table silver.crm_sales_details'
        INSERT INTO silver.crm_sales_details(
            sls_id,
	        sls_prd_key,
	        sls_cst_id,
	        sls_order_date ,
	        sls_shipping_date,
	        sls_due_date,
	        sls_sales,
	        sls_prize,
	        sls_quantity
            )
            SELECT 
                sls_id,
                sls_prd_key,
                sls_cst_id,
                CASE WHEN sls_order_date =0 OR LEN(sls_order_date) != 8 THEN NULL
                     ELSE CAST(CAST(sls_order_date AS VARCHAR) AS DATE)
                END sls_order_date,
                CASE WHEN sls_shipping_date =0 OR LEN(sls_shipping_date) != 8 THEN NULL
                     ELSE CAST(CAST(sls_shipping_date AS VARCHAR) AS DATE)
                END sls_shipping_date,
                CASE WHEN sls_due_date =0 OR LEN(sls_due_date) != 8 THEN NULL
                     ELSE CAST(CAST(sls_due_date AS VARCHAR) AS DATE)
                END sls_due_date,
                CASE 
                    WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_prize) 
                    THEN sls_quantity * ABS(sls_prize)
	                ELSE sls_sales
	            end sls_sales,
                CASE
	                WHEN sls_prize <= 0 OR sls_prize IS NULL THEN sls_sales / NULLIF(sls_quantity,0)
	                else sls_prize
                END sls_prize,
                sls_quantity
              FROM bronze.crm_sales_details

        SET @end_time =GETDATE();
        PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        PRINT '=========================================================================================================================='
        PRINT '                                         silver.erp_cust_info' 
        PRINT '=========================================================================================================================='

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table silver.erp_cust_info'
        TRUNCATE TABLE silver.erp_cust_info

        PRINT '>>Inserting Data in table silver.erp_cust_info'
        INSERT INTO silver.erp_cust_info(
	        e_cst_cid,
	        e_cst_birth_date,
	        e_cst_gender
	        )
	        select 
		        CASE 
			        WHEN e_cst_cid like 'NAS%' THEN SUBSTRING(e_cst_cid,4,LEn(e_cst_cid))
			        ELSE e_cst_cid
		        END e_cst_cid,
		        CASE 
			        WHEN e_cst_birth_date > GETDATE() THEN NULL
			        ELSE e_cst_birth_date
		        END e_cst_birth_date,
		        CASE 
			        WHEN UPPER(TRIM(e_cst_gender)) IN ('F','FEMALE') THEN 'Female'
			        WHEN UPPER(TRIM(e_cst_gender)) IN ('M','MALE') THEN 'Male'
			        ELSE 'N/A'
		        END e_cst_gender
	        from bronze.erp_cust_info

        SET @end_time =GETDATE();
        PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        PRINT '=========================================================================================================================='
        PRINT '                                         silver.erp_loc' 
        PRINT '=========================================================================================================================='

        SET @start_time =GETDATE();

        PRINT '>> Truncating Table silver.erp_loc'
        TRUNCATE TABLE silver.erp_loc

        PRINT '>>Inserting Data in table silver.erp_loc'
        INSERT INTO silver.erp_loc(
	        loc_cid,
	        loc_country
	        )
	        select 
		         REPLACE(loc_cid,'-','') loc_cid,
		         CASE 
			        WHEN TRIM(loc_country) IS NULL OR loc_country = '' THEN 'N/A'
			        WHEN TRIM(loc_country) = 'DE' THEN 'Germany'
			        WHEN TRIM(loc_country) IN ('USA','US','United States') THEN 'United States'
			        ELSE TRIM(loc_country)
		         END loc_country
	        FROM bronze.erp_loc

        SET @end_time = GETDATE();
        PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        PRINT '=========================================================================================================================='
        PRINT '                                         silver.erp_px_cat' 
        PRINT '=========================================================================================================================='

        SET @start_time =GETDATE();

        PRINT '>> Truncating Table silver.erp_px_cat'
        TRUNCATE TABLE silver.erp_px_cat

        PRINT '>>Inserting Data in table silver.erp_px_cat'
        INSERT INTO silver.erp_px_cat
        ( 
	        px_id,
	        px_category,
	        px_maintenance,
	        px_sub_category
	        )
	        select 
		        px_id,
		        px_category,
		        px_maintenance,
		        px_sub_category
	        from bronze.erp_px_cat

        SET @end_time =GETDATE();
        PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        
        
        SET @batch_end_time = GETDATE()
		PRINT 'Duration of Loading Silver Layer ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
		PRINT '======================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================';
	END CATCH
END;

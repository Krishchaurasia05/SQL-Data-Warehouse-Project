/*
===================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================================================
Script Purpose:
      This stored procedure loads data into the 'bronze' schema from external CSV files.
      It performs the following actions:
      - Truncates the bronze tables before loading data.
      - Then use the 'Bulk Insert' command to load the data from CSV files to bronze tables.
Parameters: 
      None
      This stored procedure does not accept any parameters or return any values.
Use Example:
    EXEC bronze.load_bronze;
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
	Set @batch_start_time = GETDAtE()
		PRINT '===========================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '===========================================================';

		PRINT '===========================================================';
		PRINT 'Loading CRM Data ';
		PRINT '===========================================================';
		
		PRINT 'Truncating bronze.crm_cust_info';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT 'Loading Data in bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\krish\OneDrive\文档\Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		PRINT 'Truncating bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_product_info;
		PRINT 'Loading Data in bronze.crm_cust_info';
		BULK INSERT bronze.crm_product_info
		FROM 'C:\Users\krish\OneDrive\文档\Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT 'Truncating bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT 'Loading data in bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\krish\OneDrive\文档\Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';


		PRINT '===========================================================';
		PRINT 'Loading ERP Data ';
		PRINT '===========================================================';

		SET @start_time = GETDATE();
		PRINT 'Trancating bronze.erp_cust_info';
		TRUNCATE TABLE bronze.erp_cust_info;
		PRINT 'Loading data in bronze.erp_cust_info';
		BULK INSERT bronze.erp_cust_info
		FROM 'C:\Users\krish\OneDrive\文档\Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT 'Trancating bronze.erp_loc';
		TRUNCATE TABLE bronze.erp_loc;
		PRINT 'Loading data in bronze.erp_loc';
		BULK INSERT bronze.erp_loc
		FROM 'C:\Users\krish\OneDrive\文档\Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		PRINT 'Trancating bronze.erp_px_cat';
		TRUNCATE TABLE bronze.erp_px_cat;
		PRINT 'Loading data in bronze.erp_px_cat';
		BULK INSERT bronze.erp_px_cat
		FROM 'C:\Users\krish\OneDrive\文档\Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Duration ' + CAST (DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		SET @batch_end_time = GETDATE()
		PRINT 'Duration of Loading Bronze Layer ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
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

EXEC bronze.load_bronze

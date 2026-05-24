/* 
===================================================================
Create a New Database And Schema
====================================================================
Script Purpose :
	This script create a new Database named "DataWarehouse" after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script set up three 
	schemas within the database : 'bronze', 'silver', and 'gold'.

Warning :
	Running this script will drop the entire "DataWarehouse" database if it exists.
	All the data in the database will be permanently deleted. Procced with caution,
	and ensure you have a proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the "DataWarehouse" database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--Create Database DataWarehouse
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

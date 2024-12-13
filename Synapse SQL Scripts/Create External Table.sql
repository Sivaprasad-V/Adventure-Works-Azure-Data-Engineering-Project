-- Create a master key for encryption, using a password for security.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'give your password';

-- Create a database-scoped credential with a managed identity for authentication.
CREATE DATABASE SCOPED CREDENTIAL cred_siva
WITH 
    IDENTITY = 'Managed Identity';

-- Create an external data source named 'source_silver', which points to a specific location in Azure Data Lake Storage (Silver tier).
CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION = 'https://sivaadventureworkslake.dfs.core.windows.net/silver', -- URL to the external data storage location
    CREDENTIAL = cred_siva, -- Use the 'cred_siva' credential for authentication
);

-- Create another external data source named 'source_gold', pointing to the 'gold' directory in Azure Data Lake Storage.
CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION = 'https://sivaadventureworkslake.dfs.core.windows.net/gold', -- URL to the external data storage location
    CREDENTIAL = cred_siva, -- Use the 'cred_siva' credential for authentication
);

-- Create an external file format for reading Parquet files with Snappy compression.
CREATE EXTERNAL FILE FORMAT format_parquet 
WITH (
    FORMAT_TYPE = PARQUET, -- Specify the file format (Parquet)
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec' -- Use Snappy compression for Parquet files
);

-- Create an external table 'extsales' in the 'gold' schema, referencing the Parquet files in the 'gold' data source.
-- The table will be populated with the data from 'gold.sales'.
CREATE EXTERNAL TABLE gold.extsales
WITH (
    LOCATION = 'extsales', -- Path to the external data (relative to the data source location)
    DATA_SOURCE = source_gold, -- Use the 'source_gold' external data source for connection
    FILE_FORMAT = format_parquet -- Use the 'format_parquet' for reading the file
)
AS
SELECT * FROM gold.sales; -- Select all data from the 'gold.sales' table and load into the external table












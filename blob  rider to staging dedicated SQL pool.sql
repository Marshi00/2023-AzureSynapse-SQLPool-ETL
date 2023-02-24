IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'accidentdatafilesys_accidentdatalake_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [accidentdatafilesys_accidentdatalake_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://accidentdatafilesys@accidentdatalake.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE dbo.staging_rider (
	[rider_id] bigint,
	[first] VARCHAR(50),
	[last] VARCHAR(50),
	[address] VARCHAR(100),
	[birthday] VARCHAR(100),
	[account_start_date] VARCHAR(100),
	[account_end_date] VARCHAR(100),
	[is_member] bit
	)
	WITH (
	LOCATION = 'publicriders.csv',
	DATA_SOURCE = [accidentdatafilesys_accidentdatalake_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO
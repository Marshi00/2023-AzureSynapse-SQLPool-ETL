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

CREATE EXTERNAL TABLE dbo.staging_station (
	[station_id] VARCHAR(50),
	[name] VARCHAR(75),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'publicstation.csv',
	DATA_SOURCE = [accidentdatafilesys_accidentdatalake_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO
-- Define a temporary table to hold the calendar data
CREATE TABLE #calendar_tmp (
                               DateTime DATETIME2,
    [second] SMALLINT,
    [minute] SMALLINT,
    [hour] SMALLINT,
    [day] SMALLINT,
    [dayofweek] SMALLINT,
    [is_weekend] BIT,
    [month] SMALLINT,
    [Quarter] SMALLINT,
    [Year] SMALLINT
);

-- Insert the calendar data into the temporary table
INSERT INTO #calendar_tmp (DateTime, [second], [minute], [hour], [day], [dayofweek], [is_weekend], [month], [Quarter], [Year])
SELECT
    DateTime,
    DATEPART(SECOND, DateTime) AS [second],
    DATEPART(MINUTE, DateTime) AS [minute],
    DATEPART(HOUR, DateTime) AS [hour],
    DATEPART(DAY, DateTime) AS [day],
    DATEPART(WEEKDAY, DateTime) AS [dayofweek],
    CASE WHEN DATEPART(WEEKDAY, DateTime) > 4 THEN 1 ELSE 0 END AS [is_weekend],
    DATEPART(MONTH, DateTime) AS [month],
    DATEPART(QUARTER, DateTime) AS [Quarter],
    DATEPART(YEAR, DateTime) AS [Year]
FROM
    (
        SELECT TOP 1 CAST('1969-01-01 00:00:00' AS DATETIME2) AS DateTime FROM sys.objects
        UNION ALL
        SELECT DATEADD(SECOND, ROW_NUMBER() OVER (ORDER BY a.object_id) - 1, '1969-01-01 00:00:00') AS DateTime FROM sys.objects a, sys.objects b
    ) AS DateTime;

-- Create the final table with the calendar data
CREATE TABLE IF NOT EXISTS dimDate (
                                       DateTime DATETIME2 PRIMARY KEY,
    [second] SMALLINT,
    [minute] SMALLINT,
    [hour] SMALLINT,
    [day] SMALLINT,
    [dayofweek] SMALLINT,
    [is_weekend] BIT,
    [month] SMALLINT,
    [Quarter] SMALLINT,
[Year] SMALLINT
);

-- Insert the data from the temporary table into the final table
INSERT INTO dimDate (DateTime, [second], [minute], [hour], [day], [dayofweek], [is_weekend], [month], [Quarter], [Year])
SELECT * FROM #calendar_tmp;

-- Clean up the temporary table
DROP TABLE #calendar_tmp;

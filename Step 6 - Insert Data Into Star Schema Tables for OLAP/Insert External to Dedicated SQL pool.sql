-- Define a temporary table to hold the calendar data
CREATE TABLE #calendar_tmp (
    DateTime DATETIME,
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
        SELECT TOP 1 CAST('2012-01-01 00:00:00' AS DATETIME2) AS DateTime FROM sys.objects
        UNION ALL
        SELECT DATEADD(SECOND, ROW_NUMBER() OVER (ORDER BY a.object_id) - 1, '2012-01-01 00:00:00') AS DateTime FROM sys.objects a, sys.objects b
        WHERE DATEADD(SECOND, ROW_NUMBER() OVER (ORDER BY a.object_id) - 1, '2012-01-01 00:00:00') <= '2023-12-31 23:59:59'
    ) AS DateTime;

-- Create the final table with the calendar data
CREATE TABLE IF NOT EXISTS dimDate (
    DateTime DATETIME NOT NULL,
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

GO



INSERT INTO dimRiders (rider_key, first_name, last_name, address, birthday, account_start_date, account_end_date, is_member)
SELECT rider_id                  					 AS rider_key,
       first                                         AS first_name,
       last                                          AS last_name,
       address                                       AS address,
       CAST(birthday AS DATE)                        AS birthday,
       CAST(account_start_date AS DATETIME)          AS account_start_date,
       CAST(account_end_date AS DATETIME)            AS account_end_date,
       CASE WHEN is_member = 'true' THEN 1 ELSE 0 END    AS is_member
FROM riders

GO

INSERT INTO dimStation (station_key, station_name, latitude, longitude)
SELECT station_id                                     AS station_key,
       name                                           AS station_name,
       latitude                                       AS latitude,
       longitude                                      AS longitude
FROM station

GO

INSERT INTO FactPayment (payment_id, date_id, rider_id, amount)
SELECT p.payment_id                                  AS payment_id,
       d.date_time                                   AS date_id,
       p.rider_id                                    AS rider_id,
       CAST(p.amount AS DECIMAL(10,2))               AS amount
FROM payment p
JOIN dimDate d ON ( CAST(p.date AS DATETIME) = d.date_time )

GO

INSERT INTO FactTrip (trip_key, rideable_type, start_date_id, ended_date_id, start_station_id, end_station_id, rider_id, age, trip_duration)
SELECT t.trip_id                                            AS trip_key,
       t.rideable_type                                      AS rideable_type,
       st.date_time                                         AS start_date_id,
       sp.date_time                                         AS ended_date_id,
       t.start_station_id                                   AS start_station_id,
       t.end_station_id                                     AS end_station_id,
       t.rider_id                                           AS rider_id,
       (DATEDIFF(year, r.birthday,
    CONVERT(Datetime, SUBSTRING([t.started_at], 1, 19),120)) - (
        CASE WHEN MONTH(r.birthday) > MONTH(CONVERT(Datetime, SUBSTRING([t.started_at], 1, 19),120))
        OR MONTH(r.birthday) =
            MONTH(CONVERT(Datetime, SUBSTRING([t.started_at], 1, 19),120))
        AND DAY(r.birthday) >
            DAY(CONVERT(Datetime, SUBSTRING([t.started_at], 1, 19),120))
        THEN 1 ELSE 0 END
    ) AS age,
       DATEDIFF_BIG(SECOND, t.ended_at, t.start_at)         AS trip_duration
FROM trip t
JOIN dimDate start ON ( start.date_time = t.start_at )
JOIN dimDate stop ON ( stop.date_time = t.ended_at )
JOIN dimRiders as r ON (r.rider_key = t.rider_id)
WHERE DATEDIFF(minute, t.start_at, t.ended_at) <> 0

GO;
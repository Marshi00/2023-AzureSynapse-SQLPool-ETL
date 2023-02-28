%%sql
-- Define a temporary table to hold the calendar data
CREATE TEMP TABLE calendar_tmp (
    DateTime TIMESTAMP,
    second SMALLINT,
    minute SMALLINT,
    hour SMALLINT,
    day SMALLINT,
    dayofweek SMALLINT,
    is_weekend BOOLEAN,
    month SMALLINT,
    Quarter SMALLINT,
    Year SMALLINT
);

-- Insert the calendar data into the temporary table
INSERT INTO calendar_tmp (DateTime, second, minute, hour, day, dayofweek, is_weekend, month, Quarter, Year)
SELECT
    DateTime,
    EXTRACT(SECOND FROM DateTime) AS second,
EXTRACT(MINUTE FROM DateTime) AS minute,
EXTRACT(HOUR FROM DateTime) AS hour,
EXTRACT(DAY FROM DateTime) AS day,
EXTRACT(DOW FROM DateTime) AS dayofweek,
CASE WHEN EXTRACT(DOW FROM DateTime) > 4 THEN TRUE ELSE FALSE END AS is_weekend,
EXTRACT(MONTH FROM DateTime) AS month,
EXTRACT(QUARTER FROM DateTime) AS Quarter,
EXTRACT(YEAR FROM DateTime) AS Year
FROM
generate_series('1969-01-01 00:00:00'::TIMESTAMP, '2050-12-31 23:59:59'::TIMESTAMP, '1 second'::INTERVAL) AS DateTime;

-- Create the final table with the calendar data
CREATE TABLE IF NOT EXISTS dimDate (
                                       DateTime TIMESTAMP PRIMARY KEY,
                                       second SMALLINT,
                                       minute SMALLINT,
                                       hour SMALLINT,
                                       day SMALLINT,
                                       dayofweek SMALLINT,
                                       is_weekend BOOLEAN,
                                       month SMALLINT,
                                       Quarter SMALLINT,
                                       Year SMALLINT
);

-- Insert the data from the temporary table into the final table
INSERT INTO dimDate (DateTime, second, minute, hour, day, dayofweek, is_weekend, month, Quarter, Year)
SELECT * FROM calendar_tmp;

-- Clean up the temporary table
DROP TABLE calendar_tmp;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimRiders')
BEGIN
    CREATE TABLE dimRiders(
        rider_key            INT NOT NULL,
        first_name           VARCHAR(50) NOT NULL,
        last_name            VARCHAR(50) NOT NULL,
        address              VARCHAR(100) NOT NULL,
        birthday             DATETIME NOT NULL,
        account_start_date   DATETIME NOT NULL,
        account_end_date     DATE,
        is_member            BIT
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimStation')
BEGIN
    CREATE TABLE  dimStation
    (
        station_key          VARCHAR(50) NOT NULL,
        station_name         VARCHAR(75) NOT NULL,
        latitude             FLOAT NOT NULL,
        longitude            FLOAT NOT NULL
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dimDate')
BEGIN
    CREATE TABLE  dimDate
    (
        date_time           DATETIME NOT NULL,
        second              BIGINT,
        minute              BIGINT,
        hour                BIGINT,
        day                 BIGINT,
        dayofweek           BIGINT,
        is_weekend          BIT,
        month               BIGINT,
        Quarter             BIGINT,
        Year                BIGINT
    );
END

GO



GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactTrip')
BEGIN
CREATE TABLE FactTrip
    (
        trip_key             VARCHAR(50) NOT NULL,
        rideable_type        VARCHAR(75) NOT NULL,
        start_date_id        DATETIME NOT NULL ,
        ended_date_id        DATETIME NOT NULL ,
        start_station_id     VARCHAR(50) NOT NULL ,
        end_station_id       VARCHAR(50) NOT NULL ,
        rider_id             INT,
        age_sec              BIGINT,
        trip_duration_sec    BIGINT
    );
END

GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactPayment')
BEGIN
    CREATE TABLE FactPayment
    (
        payment_id           INT NOT NULL,
        date_id              DATETIME NOT NULL,
        rider_id             INT NOT NULL,
        amount               MONEY NOT NULL
    );
END

GO;